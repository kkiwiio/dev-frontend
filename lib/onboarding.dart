import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'login/login.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
            title: '탐험하세요',
            body: '학교 구석구석을 탐방하여\n미션을 발견하세요',
            image: Image.asset('assets/images/splash1.png'),
            decoration: getPageDecoration()),
        PageViewModel(
            title: '촬영하세요',
            body: '학교 건물을 배경으로\n미션에 맞게 사진을 촬영하세요',
            image: Image.asset('assets/images/splash2.png'),
            decoration: getPageDecoration()),
        PageViewModel(
            title: '제출하세요',
            body: 'AI가 자동으로 장소를 인식하고\n 사진을 변환해줍니다',
            image: Image.asset('assets/images/splash3.png'),
            decoration: getPageDecoration()),
      ],
      done: const Text('시작하기'), //온보딩 화면 마지막에 도착하면 무엇을 할지 지정
      onDone: () {
        //onPressed와 역할 동일
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LogIn()),
        );
      },
      next: const Icon(Icons.arrow_forward),
      showSkipButton: true,
      skip: const Text('skip'),
      dotsDecorator: DotsDecorator(
          size: const Size(10, 10),
          activeSize: const Size(22, 10),
          activeShape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
      curve: Curves.bounceInOut,
    );
  }

  PageDecoration getPageDecoration() {
    return const PageDecoration(
      titleTextStyle: TextStyle(
          fontFamily: 'GmarketSansTTFMedium',
          fontSize: 28,
          color: Color(0xFF0A0240),
          fontWeight: FontWeight.bold),
      bodyTextStyle: TextStyle(
          fontFamily: 'GmarketSansTTFMedium',
          fontSize: 18,
          color: Color(0xFF0A0240)),
      imagePadding: EdgeInsets.only(top: 80),
    );
  }
}
