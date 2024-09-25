import 'package:flutter/material.dart';
import './signup_password.dart';

class EmailSignupPage extends StatefulWidget {
  const EmailSignupPage({super.key});

  @override
  _EmailSignupPageState createState() => _EmailSignupPageState();
}

class _EmailSignupPageState extends State<EmailSignupPage> {
  final _emailController = TextEditingController();
  bool _isEmailValid = false;
  String? _errorMessage;

  void _validateEmail(String value) {
    setState(() {
      if (value.isEmpty) {
        _isEmailValid = false;
        _errorMessage = null;
      } else {
        _isEmailValid =
            RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value);
        _errorMessage = _isEmailValid ? null : '이메일 양식을 확인해주세요';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
                child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxWidth * 0.1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: constraints.maxHeight * 0.2),
                      Text(
                        '스쿠벤처에 오신걸\n환영합니다👋',
                        style: TextStyle(
                          fontSize: constraints.maxWidth * 0.07,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'GmarketSansTTFBold',
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.15),
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 280),
                          child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: '이메일 주소를 입력해주세요',
                              hintStyle: const TextStyle(
                                  fontFamily: 'GmarketSansTTFMedium',
                                  fontSize: 15),
                              errorText: _errorMessage,
                              border: const UnderlineInputBorder(),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 0, 0, 0)),
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                            onChanged: _validateEmail,
                          ),
                        ),
                      ),
                      SizedBox(height: constraints.maxHeight * 0.03),
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 308),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isEmailValid
                                  ? () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SignupPassword(
                                                    email:
                                                        _emailController.text)),
                                      );
                                    }
                                  : null,
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.disabled)) {
                                      return const Color(
                                          0xffECECEC); // 비활성화 상태 색상
                                    }
                                    return const Color(0xFF87C159); // 활성화 상태 색상
                                  },
                                ),
                                foregroundColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                        (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.disabled)) {
                                    return const Color.fromARGB(
                                        255, 255, 255, 255); // 비활성화 상태 텍스트 색상
                                  }
                                  return Colors.white; // 활성화 상태 텍스트 색상
                                }),
                                shape: WidgetStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                padding: WidgetStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.symmetric(vertical: 15),
                                ),
                              ),
                              child: const Text('계속하기',
                                  style: TextStyle(
                                      fontFamily: 'GmarketSansTTFMedium')),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
          },
        ),
      ),
    );
  }
}
