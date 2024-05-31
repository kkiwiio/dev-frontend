import 'dart:io';
import 'package:flutter/material.dart';

class DisplayImageScreen extends StatelessWidget {
  final String imagePath;

  const DisplayImageScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Image')),
      body: Center(
        child: Image.file(File(imagePath)), // File 객체를 사용하여 이미지를 로드하고 표시합니다.
      ),
    );
  }
}
