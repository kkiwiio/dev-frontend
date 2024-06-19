import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ImageTransform extends StatefulWidget {
  final int rewardPoints;

  const ImageTransform({Key? key, required this.rewardPoints}) : super(key: key);

  @override
  _ImageTransformState createState() => _ImageTransformState();
}

class _ImageTransformState extends State<ImageTransform> {
  File? _selectedImage;
  String? _transformedImageUrl;
  String userEmail = '';
  int rewardPoints = 0;

  @override
  void initState() {
    super.initState();
    getUserEmail().then((email) {
      setState(() {
        userEmail = email;
      });
    });
    loadRewardPoints();
  }

  Future<String> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail') ?? '';
  }

  Future<void> loadRewardPoints() async {
    setState(() {
      rewardPoints = widget.rewardPoints;
    });
  }

  Future<void> saveRewardPoints(int points) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('rewardPoints', points);
    setState(() {
      rewardPoints = points;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _transformedImageUrl = null;
      });
    }
  }

  Future<void> _transformImage() async {
    if (_selectedImage != null && rewardPoints > 0) {
      final response = await _uploadImage(_selectedImage!);

      if (response.statusCode == 200) {
        final transformedUrl = response.body;
        setState(() {
          _transformedImageUrl = transformedUrl;
        });
        saveRewardPoints(rewardPoints - 1);
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('알림'),
            content: const Text('이미지 변환에 실패했습니다.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('확인'),
              ),
            ],
          ),
        );
      }
    } else if (rewardPoints <= 0) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('알림'),
          content: const Text('포인트가 부족합니다.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인'),
            ),
          ],
        ),
      );
    }
  }

  Future<http.Response> _uploadImage(File imageFile) async {
    final url = 'http://10.0.2.2:8081/model/transform';

    var request = http.MultipartRequest('POST', Uri.parse(url));
    print(url);
    request.fields['userEmail'] = userEmail;
    final imageBytes = await imageFile.readAsBytes();
    final fileName = 'image.jpg';
    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: fileName,
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    var response = await request.send();
    final statusCode = response.statusCode;
    print('Response status code: $statusCode');

    final responseBody = await response.stream.bytesToString(); // 응답 본문을 문자열로 가져옴
    print('Response body: $responseBody'); // 응답 본문(URL) 출력

    if (statusCode == 200) {
      return http.Response(responseBody, statusCode); // 성공적인 응답인 경우 HTTP 응답 객체 반환
    } else {
      return http.Response(responseBody, statusCode); // 실패한 응답인 경우에도 HTTP 응답 객체 반환
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('생성형이미지 바꾸기'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('이미지 선택하기'),
            ),
            const SizedBox(height: 20),
            _selectedImage != null
                ? Image.file(
              _selectedImage!,
              height: 200,
            )
                : const SizedBox(),
            const SizedBox(height: 20),
            _selectedImage != null
                ? ElevatedButton(
              onPressed: _transformImage,
              child: const Text('변환하기'),
            )
                : const SizedBox(),
            const SizedBox(height: 20),
            _transformedImageUrl != null
                ? Image.network(
              _transformedImageUrl!,
              height: 200,
            )
                : const SizedBox(),
            const SizedBox(height: 20),
            Text('남은 포인트: $rewardPoints'),
          ],
        ),
      ),
    );
  }
}