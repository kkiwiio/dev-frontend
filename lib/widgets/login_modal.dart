import 'package:flutter/material.dart';
import '../signup/signup_email.dart';
import '../naver_map/naver_map.dart';
import '../services/api_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginModal extends StatefulWidget {
  final VoidCallback onClose;

  const LoginModal({super.key, required this.onClose});

  @override
  _LoginModalState createState() => _LoginModalState();
}

class _LoginModalState extends State<LoginModal> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

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
    widget.onClose();
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await ApiService.login(
        _usernameController.text,
        _passwordController.text,
      );
      print('Login result: $result');

      // 세션 쿠키 확인
      final sessionCookie = await ApiService.getSessionCookie();
      print('Session cookie after login: $sessionCookie');

      if (result == 'Login successful') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const NaverMapApp()),
        );
      } else {
        // 로그인 실패 메시지 표시
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.loginError)),
        );
      }
    } catch (e) {
      print('Login failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.loginError)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final buttonWidth = size.width * 0.8;
    final inputWidth = size.width * 0.75;
    final modalHeight = size.height * 0.5;

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
                      padding: EdgeInsets.all(size.width * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.login,
                            style: TextStyle(
                              fontFamily: 'GmarketSansTTFBold',
                              fontSize: size.width * 0.06,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          SizedBox(
                            width: inputWidth,
                            child: TextField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!.id,
                                hintStyle: const TextStyle(
                                    fontFamily: 'GmarketSansTTFMedium'),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF87C159)),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                          SizedBox(
                            width: inputWidth,
                            child: TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText:
                                    AppLocalizations.of(context)!.password,
                                hintStyle: const TextStyle(
                                    fontFamily: 'GmarketSansTTFMedium'),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFF87C159)),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.05),
                          SizedBox(
                            width: buttonWidth,
                            height: size.height * 0.06,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF87C159),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : Text(
                                      AppLocalizations.of(context)!.startButton,
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
                                AppLocalizations.of(context)!.signup,
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
