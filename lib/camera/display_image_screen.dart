import 'dart:io';
import 'package:flutter/material.dart';
import '../services/image_service.dart';
import './save_image.dart';
import './mission_result_dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../naver_map/naver_map.dart';

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
  String? _transformedImageUrl;
  int rewardPoints = 0;

  @override
  void initState() {
    super.initState();
    loadRewardPoints();
  }

  Future<void> loadRewardPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      rewardPoints = prefs.getInt('rewardPoints') ?? 0;
    });
  }

  Future<void> saveRewardPoints(int points) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('rewardPoints', points);
    setState(() {
      rewardPoints = points;
    });
  }

  Future<void> _submitImage() async {
    final imageFile = File(widget.imagePath);
    final response = await ImageService.uploadImage(imageFile, widget.idNumber);

    if (response.statusCode == 200) {
      final compareResult = int.parse(response.body);
      if (compareResult == 1) {
        showMissionSuccessDialog(context, rewardPoints + 1);
        saveRewardPoints(rewardPoints + 1);
      } else {
        showMissionFailureDialog(context);
      }
    } else {
      // showUploadFailureDialog(context);
      String errorMessage = response.body;
      showUploadFailureDialog(context, errorMessage);
    }
  }

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
              child: _transformedImageUrl != null
                  ? Image.network(_transformedImageUrl!)
                  : Image.file(File(widget.imagePath)),
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
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NaverMapApp(),
                      ),
                    );
                  },
                  child: const Text(
                    '처음으로',
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
                  onPressed: _submitImage,
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
        ],
      ),
    );
  }
}
