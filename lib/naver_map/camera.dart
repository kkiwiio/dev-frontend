import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({super.key, required this.camera});

  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // 카메라 컨트롤러 초기화
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // 컨트롤러 해제
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('사진 찍기')),
      // 카메라 미리보기 화면
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // 카메라 초기화 완료 시 카메라 미리보기 제공
            return CameraPreview(_controller);
          } else {
            // 초기화 중 로딩 인디케이터 표시
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_alt),
        // 사진 촬영 버튼
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            // 사진 촬영
            final image = await _controller.takePicture();
            // 사진 촬영 후 결과 페이지로 이동 혹은 결과 처리
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    DisplayPictureScreen(imagePath: image.path),
              ),
            );
          } catch (e) {
            print(e);
            // 에러 처리
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('카메라 사용 중 오류 발생: $e')),
            );
          }
        },
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('사진 미리보기')),
      // 이미지 파일을 사용하여 사진 미리보기
      body: Image.file(File(imagePath)),
    );
  }
}
