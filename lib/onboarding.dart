import 'package:flutter/material.dart';
import '../widgets/login_modal.dart';
import 'dart:async';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  bool _isLoginVisible = false;

  final List<OnboardingItem> _items = [
    OnboardingItem(
      image: 'assets/images/splash_img1.png',
      title: '탐험하세요',
      description: '학교 구석구석을 탐방하여\n미션을 발견하세요',
    ),
    OnboardingItem(
      image: 'assets/images/splash_img2.png',
      title: '촬영하세요',
      description: '학교 건물을 배경으로\n미션에 맞게 사진을 촬영하세요',
    ),
    OnboardingItem(
      image: 'assets/images/splash_img3.png',
      title: '제출하세요',
      description: 'AI가 자동으로 장소를 인식하고\n사진을 변환해줍니다',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentPage < _items.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  void _toggleLoginVisibility() {
    setState(() {
      _isLoginVisible = !_isLoginVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildOnboardingContent(),
          if (_isLoginVisible)
            Positioned.fill(
              child: LoginModal(onClose: _toggleLoginVisibility),
            ),
        ],
      ),
    );
  }

  Widget _buildOnboardingContent() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _items.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return OnboardingItemWidget(item: _items[index]);
              },
            ),
          ),
          _buildLoginButton(),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32, left: 24, right: 24),
      child: SizedBox(
        width: 308,
        height: 55,
        child: ElevatedButton(
          onPressed: _toggleLoginVisibility,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF87C159),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            '로그인',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontFamily: 'GmarketSansTTFMedium',
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingItem {
  final String image;
  final String title;
  final String description;

  OnboardingItem({
    required this.image,
    required this.title,
    required this.description,
  });
}

class OnboardingItemWidget extends StatelessWidget {
  final OnboardingItem item;

  const OnboardingItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          Expanded(
            flex: 3,
            child: Image.asset(item.image, fit: BoxFit.contain),
          ),
          const Spacer(flex: 1),
          Text(
            item.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xff595959),
              fontFamily: 'GmarketSansTTFBold',
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 154,
            height: 2,
            color: const Color(0xff595959),
          ),
          const SizedBox(height: 16),
          Text(
            item.description,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xff595959),
              fontFamily: 'GmarketSansTTFMedium',
            ),
            textAlign: TextAlign.center,
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
