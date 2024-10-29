// lib/models/transform_task.dart
class TransformTask {
  final String taskId;
  final String imagePath;
  final DateTime createdAt;
  String? processedImageUrl;
  TaskStatus status;

  TransformTask({
    required this.taskId,
    required this.imagePath,
    required this.status,
    this.processedImageUrl,
  }) : createdAt = DateTime.now();
}

enum TaskStatus {
  pending, // 대기 중
  processing, // 처리 중
  completed, // 완료됨
  failed // 실패
}
