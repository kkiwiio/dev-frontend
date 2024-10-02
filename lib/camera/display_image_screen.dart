import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'mission_result_dialogs.dart';

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

  Future<void> _submitPicture(BuildContext context) async {
    try {
      var uri = Uri.parse('http://10.0.2.2:8080/image/compare');
      print('Sending request to: $uri');

      var request = http.MultipartRequest('POST', uri);

      var file = File(imagePath);
      var fileStream = http.ByteStream(file.openRead());
      var fileLength = await file.length();

      var multipartFile = http.MultipartFile('image', fileStream, fileLength,
          filename: path.basename(imagePath));

      request.files.add(multipartFile);
      request.fields['buildingNumber'] = idNumber;

      print('Request fields: ${request.fields}');
      print('Request files: ${request.files.map((f) => f.filename).toList()}');

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        int result = int.parse(response.body);
        if (result == 1) {
          showMissionSuccessDialog(context, imagePath);
        } else if (result == 0) {
          showMissionFailureDialog(context);
        } else {
          throw Exception('Unexpected result: $result');
        }
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('인증되지 않은 사용자입니다. 다시 로그인해주세요.',
                  style: TextStyle(fontFamily: 'GmarketSansTTFMedium'))),
        );
      } else {
        throw Exception(
            'Failed to submit image: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error in _submitPicture: $e');
      showUploadFailureDialog(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('촬영된 사진',style:
        TextStyle(color: Colors.white)),
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
                        label: const Text('다시 찍기',
                            style:
                                TextStyle(fontFamily: 'GmarketSansTTFMedium')),
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
                        label: const Text('제출하기',
                            style:
                                TextStyle(fontFamily: 'GmarketSansTTFMedium')),
                        onPressed: () => _submitPicture(context),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFF87C159),
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
