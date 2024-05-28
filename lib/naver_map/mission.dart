import 'package:flutter/material.dart';

class MissionDialog extends StatelessWidget {
  final String missionDescription;
  final String missionImage;

  const MissionDialog(
      {super.key,
      required this.missionDescription,
      required this.missionImage});

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
                  fontFamily: 'GmarketSansTTFBold',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                missionDescription,
                style: const TextStyle(
                  fontFamily: 'GmarketSansTTFMedium',
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
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.camera_alt, color: Colors.black),
                      SizedBox(width: 8),
                      Text(
                        "사진찍기",
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontFamily: 'GmarketSansTTFBol',
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
