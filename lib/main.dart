import 'package:flutter/material.dart';
import 'onboarding.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize(
      clientId: '7vff5ieoeb', // 클라이언트 ID를 입력하세요.
      onAuthFailed: (e) => print("네이버맵 인증오류 : $e"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'skhu adventure',
      home: OnBoardingPage(),
    );
  }
}
