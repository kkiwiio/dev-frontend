import 'package:flutter/material.dart';
import '../signup/signup_email.dart';
import '../naver_map/naver_map.dart';

class LoginModal extends StatefulWidget {
  final VoidCallback onClose;

  const LoginModal({super.key, required this.onClose});

  @override
  _LoginModalState createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onSignUpPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const EmailSignupPage()),
    );
    widget.onClose(); // 모달을 닫습니다.
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final buttonWidth = size.width * 0.8; // 80% of screen width
    final inputWidth = size.width * 0.75; // 75% of screen width
    final modalHeight = size.height * 0.5; // 50% of screen height

    return GestureDetector(
      onTap: widget.onClose,
      child: Container(
        color: Colors.black54,
        child: GestureDetector(
          onTap: () {},
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: modalHeight,
                  decoration: const BoxDecoration(
                    color: Color(0xffF5F5F5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(size.width * 0.05), // 5% padding
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '로그인',
                            style: TextStyle(
                              fontFamily: 'GmarketSansTTFBold',
                              fontSize:
                                  size.width * 0.06, // Responsive font size
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          SizedBox(
                            width: inputWidth,
                            child: TextField(
                              controller: _usernameController,
                              decoration: const InputDecoration(
                                hintText: '아이디',
                                hintStyle: TextStyle(
                                    fontFamily: 'GmarketSansTTFMedium'),
                                border: UnderlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                          SizedBox(
                            width: inputWidth,
                            child: TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: '비밀번호',
                                hintStyle: TextStyle(
                                    fontFamily: 'GmarketSansTTFMedium'),
                                border: UnderlineInputBorder(),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.05),
                          SizedBox(
                            width: buttonWidth,
                            height: size.height * 0.06, // 6% of screen height
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const NaverMapApp()),
                                );
                                widget.onClose();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF87C159),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                '시작하기',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.width * 0.045,
                                  fontFamily: 'GmarketSansTTFMedium',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: _onSignUpPressed,
                              child: Text(
                                '회원가입',
                                style: TextStyle(
                                  fontSize: size.width * 0.035,
                                  decoration: TextDecoration.underline,
                                  color: const Color(0xff595959),
                                  fontFamily: 'GmarketSansTTFMedium',
                                ),
                              ),
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
        ),
      ),
    );
  }
}
