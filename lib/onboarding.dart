import 'package:flutter/material.dart';
import '../widgets/login_modal.dart';
import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  OnboardingPageState createState() => OnboardingPageState();
}

class OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  bool _isLoginVisible = false;
  late List<OnboardingItem> _items;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _items = [
      OnboardingItem(
        image: 'assets/images/splash_img1.png',
        title: AppLocalizations.of(context)!.explore,
        description: AppLocalizations.of(context)!.exploreDescription,
      ),
      OnboardingItem(
        image: 'assets/images/splash_img2.png',
        title: AppLocalizations.of(context)!.capture,
        description: AppLocalizations.of(context)!.captureDescription,
      ),
      OnboardingItem(
        image: 'assets/images/splash_img3.png',
        title: AppLocalizations.of(context)!.submit,
        description: AppLocalizations.of(context)!.submitDescription,
      ),
    ];
  }

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
          child: Text(
            AppLocalizations.of(context)!.login,
            style: const TextStyle(
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
              fontSize: 24,
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
              fontSize: 18,
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
