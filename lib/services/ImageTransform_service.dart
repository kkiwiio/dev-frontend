// lib/services/ImageTransform_service.dart
import 'dart:async';
import 'dart:io';
import 'dart:collection';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../services/api_service.dart';
import '../services/transform_task.dart';
import 'dart:convert';
import '../services/transform_message.dart';

class ImageTransformationService {
  static final ImageTransformationService _instance =
      ImageTransformationService._internal();
  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  NotificationMessages? _messages; // 알림 메시지 저장

  // 작업 큐와 상태 관리
  final Queue<TransformTask> _taskQueue = Queue<TransformTask>();
  final Map<String, TransformTask> _taskMap = {};
  bool _isProcessing = false;
  bool _isInitialized = false;

  // 상태 스트림
  final _taskStateController =
      StreamController<Map<String, TransformTask>>.broadcast();
  Stream<Map<String, TransformTask>> get taskStateStream =>
      _taskStateController.stream;

  factory ImageTransformationService() => _instance;

  ImageTransformationService._internal() {
    _initializeNotifications();
  }

  Future<void> initialize() async {
    if (!_isInitialized) {
      await _initializeNotifications();
      _isInitialized = true;
    }
  }

  void setNotificationMessages(NotificationMessages messages) {
    _messages = messages;
  }

  Future<void> _initializeNotifications() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await _notifications.initialize(settings);
  }

  Future<String> queueTransformation(String imagePath) async {
    final taskId = DateTime.now().millisecondsSinceEpoch.toString();

    final task = TransformTask(
      taskId: taskId,
      imagePath: imagePath,
      status: TaskStatus.pending,
    );

    _taskMap[taskId] = task;
    _taskQueue.add(task);
    _taskStateController.add(_taskMap);

    if (!_isProcessing) {
      _processQueue();
    }

    return taskId;
  }

  Future<void> _processQueue() async {
    if (_isProcessing || _taskQueue.isEmpty) return;

    _isProcessing = true;

    while (_taskQueue.isNotEmpty) {
      final task = _taskQueue.first;
      task.status = TaskStatus.processing;
      _taskStateController.add(_taskMap);

      try {
        final processedUrl = await _transformImage(task.imagePath);
        task.processedImageUrl = processedUrl;
        task.status = TaskStatus.completed;

        if (_messages != null) {
          await _showNotification(_messages!.transformCompleteBody);
        }
      } catch (e) {
        print('Error processing image: $e');
        task.status = TaskStatus.failed;

        if (_messages != null) {
          await _showNotification(_messages!.transformFailBody);
        }
      }

      _taskQueue.removeFirst();
      _taskStateController.add(_taskMap);
    }

    _isProcessing = false;
  }

  Future<void> retryTransformation(String imageUrl) async {
    final failedTask = _taskMap.values.firstWhere(
      (task) =>
          task.processedImageUrl == imageUrl &&
          task.status == TaskStatus.failed,
      orElse: () => throw Exception('Failed task not found'),
    );

    final newTask = TransformTask(
      taskId: DateTime.now().millisecondsSinceEpoch.toString(),
      imagePath: failedTask.imagePath,
      status: TaskStatus.pending,
    );

    _taskMap[newTask.taskId] = newTask;
    _taskQueue.add(newTask);
    _taskStateController.add(_taskMap);

    if (!_isProcessing) {
      _processQueue();
    }
  }

  Future<void> _showNotification(String body) async {
    const androidDetails = AndroidNotificationDetails(
      'image_transform_channel',
      '이미지 변환 알림',
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);
    final notificationId = DateTime.now().millisecondsSinceEpoch % 0x7FFFFFFF;

    await _notifications.show(
      notificationId,
      '',
      body,
      details,
    );
  }

  Future<String> _transformImage(String imagePath) async {
    final sessionCookie = await ApiService.getSessionCookie();
    if (sessionCookie == null) {
      throw Exception('No session cookie found');
    }

    var uri = Uri.parse('http://10.0.2.2:8080/image/transform');
    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({
      'Cookie': sessionCookie,
      'Accept': 'application/json',
    });

    var file = File(imagePath);
    var fileStream = http.ByteStream(file.openRead());
    var fileLength = await file.length();

    var multipartFile = http.MultipartFile('image', fileStream, fileLength,
        filename: path.basename(imagePath));

    request.files.add(multipartFile);
    var response = await request.send();
    var responseData = await http.Response.fromStream(response);

    if (response.statusCode != 200) {
      throw Exception('Failed to transform image');
    }

    return responseData.body;
  }

  Future<List<String>> getImageUrls() async {
    try {
      final sessionCookie = await ApiService.getSessionCookie();
      if (sessionCookie == null) {
        throw Exception('No session cookie found');
      }

      var uri = Uri.parse('http://10.0.2.2:8080/api/images');
      var response = await http.get(
        uri,
        headers: {
          'Cookie': sessionCookie,
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> urls = json.decode(response.body);
        return urls.cast<String>();
      } else {
        throw Exception('Failed to get image URLs: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getImageUrls: $e');
      rethrow;
    }
  }

  // 상태 조회 메서드들
  TransformTask? getTask(String taskId) => _taskMap[taskId];
  List<TransformTask> getPendingTasks() => _taskQueue.toList();
  bool get hasActiveTasks => _taskQueue.isNotEmpty;

  // 리소스 정리
  void dispose() {
    _taskStateController.close();
  }
}
