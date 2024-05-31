import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; // 카메라 패키지를 import
import 'onboarding.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

List<CameraDescription> cameras = []; // 카메라 리스트를 저장할 전역 변수

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 카메라 사용 가능 리스트를 불러옵니다.
  cameras = await availableCameras();
  // Naver Map SDK 초기화
  await NaverMapSdk.instance.initialize(
    clientId: '7vff5ieoeb', // 클라이언트 ID를 입력하세요.
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'skhu adventure',
      home: OnBoardingPage(), // 변경 없이 OnBoardingPage 유지
    );
  }
}
