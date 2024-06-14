import 'dart:io';
import 'package:flutter/material.dart';
import './save_image.dart';
import 'package:image_picker/image_picker.dart';

class DisplayImageScreen extends StatelessWidget {
  final String imagePath;

  const DisplayImageScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.file(File(imagePath)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                        const Color.fromARGB(255, 108, 189, 202)),
                  ),
                  onPressed: () async {
                    final picker = ImagePicker();
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.camera);

                    if (pickedFile != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DisplayImageScreen(imagePath: pickedFile.path),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    '다시찍기',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'GmarketSansTTFBol',
                      fontSize: 14,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                        const Color.fromARGB(255, 108, 189, 202)),
                  ),
                  onPressed: () => saveImage(context, imagePath),
                  child: const Text(
                    '저장하기',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'GmarketSansTTFBol',
                      fontSize: 14,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      const Color.fromARGB(255, 108, 189, 202),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    '제출하기',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'GmarketSansTTFBol',
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
