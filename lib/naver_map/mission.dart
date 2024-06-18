import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../camera/display.dart';

class MissionDialog extends StatelessWidget {
  final String missionDescription;
  final String missionImage;
  final String idNumber;
  final ImagePicker _picker = ImagePicker();
  MissionDialog({
    super.key,
    required this.missionDescription,
    required this.missionImage,
    required this.idNumber,
  });

  Future<void> _takePicture(BuildContext context) async {
    // 기본 카메라 앱을 사용하여 이미지 촬영
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      // 촬영한 이미지를 다음 화면으로 넘깁니다.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DisplayImageScreen(imagePath: image.path, idNumber: idNumber),
        ),
      );
    } else {
      // 촬영 취소 처리
      print('사진 촬영 취소');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                '미션',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                missionDescription,
                style: const TextStyle(
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Image.asset(
              missionImage,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 15),
            Center(
              child: SizedBox(
                width: 120,
                height: 35,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF6CBDCA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () => _takePicture(context),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.camera_alt, color: Colors.black),
                      SizedBox(width: 8),
                      Text(
                        "사진찍기",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
