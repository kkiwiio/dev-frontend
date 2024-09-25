import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';

class DisplayImageScreen extends StatelessWidget {
  final String imagePath;
  final String idNumber;
  final String filterImage;

  const DisplayImageScreen({
    super.key,
    required this.imagePath,
    required this.idNumber,
    required this.filterImage,
  });

  Future<File> _fixExifRotation(String imagePath) async {
    return await FlutterExifRotation.rotateImage(path: imagePath);
  }

  void _retakePicture(BuildContext context) {
    Navigator.pop(context);
  }

  void _submitPicture(BuildContext context) {
    // TODO: Implement submission logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('사진이 제출되었습니다!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('촬영된 사진'),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<File>(
        future: _fixExifRotation(imagePath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      image: DecorationImage(
                        image: FileImage(snapshot.data!),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('다시 찍기'),
                        onPressed: () => _retakePicture(context),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.grey[800],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.check),
                        label: const Text('제출하기'),
                        onPressed: () => _submitPicture(context),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
