// initial_screen.dart 파일 생성 (스플래시 스크린 대신 InitialScreen이라는 이름으로 생성)
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../onboarding.dart';
import '../naver_map/naver_map.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // flutter_native_splash가 표시되므로 추가 지연 없이 바로 체크
    final isLoggedIn = await ApiService.isLoggedIn();

    if (!mounted) return;

    // 페이지 전환 시 애니메이션 효과 제거하여 자연스러운 전환
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            isLoggedIn ? const NaverMapApp() : const OnboardingPage(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // flutter_native_splash가 표시되므로 빈 화면 반환
    return const Scaffold(
      backgroundColor: Colors.white,
    );
  }
}
