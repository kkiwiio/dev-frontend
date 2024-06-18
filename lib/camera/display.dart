import 'dart:io';
import 'package:flutter/material.dart';
import './save_image.dart';
import 'package:image_picker/image_picker.dart';
import '../services/image_service.dart';

class DisplayImageScreen extends StatefulWidget {
  final String imagePath;
  final String idNumber;

  const DisplayImageScreen({
    super.key,
    required this.imagePath,
    required this.idNumber,
  });

  @override
  _DisplayImageScreenState createState() => _DisplayImageScreenState();
}

class _DisplayImageScreenState extends State<DisplayImageScreen> {
  int? _responseData;

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
              child: Image.file(File(widget.imagePath)),
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
                          builder: (context) => DisplayImageScreen(
                            imagePath: pickedFile.path,
                            idNumber: widget.idNumber,
                          ),
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
                  onPressed: () => saveImage(context, widget.imagePath),
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
                  onPressed: () async {
                    final imageFile = File(widget.imagePath);
                    final response = await ImageService.uploadImage(
                        imageFile, widget.idNumber);
                    if (response.statusCode == 200) {
                      setState(() {
                        _responseData =
                            int.parse(response.body); // 문자열을 int로 파싱
                      });
                    } else {
                      setState(() {
                        _responseData = null; // 에러 시 null로 설정
                      });
                    }
                  },
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
          if (_responseData != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _responseData == 0 ? '두 이미지가 다릅니다' : '두 이미지가 유사합니다',
              ),
            ),
        ],
      ),
    );
  }
}
