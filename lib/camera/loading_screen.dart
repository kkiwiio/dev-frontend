import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              '이미지를 변환중이에요. 잠시만 기다려주세요...',
              style: TextStyle(
                fontFamily: 'GmarketSansTTFMedium',
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}