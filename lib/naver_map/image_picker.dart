// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:project_heck/naver_map/display.dart';

// class CameraScreen extends StatelessWidget {
//   final ImagePicker _picker = ImagePicker();

//   CameraScreen({super.key});

//   Future<void> _takePicture(BuildContext context) async {
//     // 기본 카메라 앱을 사용하여 이미지 촬영
//     final XFile? image = await _picker.pickImage(source: ImageSource.camera);

//     if (image != null) {
//       // 촬영한 이미지를 다음 화면으로 넘깁니다.
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => DisplayImageScreen(imagePath: image.path),
//         ),
//       );
//     } else {
//       // 촬영 취소 처리
//       print('사진 촬영 취소');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Take a Picture')),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () => _takePicture(context),
//           child: const Text('Open Camera'),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'dart:io';

class DisplayImageScreen extends StatelessWidget {
  final String imagePath;

  const DisplayImageScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display Image')),
      body: Center(
        child: Image.file(
          File(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
