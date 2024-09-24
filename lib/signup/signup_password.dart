// import 'package:flutter/material.dart';
// import './signup_userinfo.dart';

// class SignupPassword extends StatefulWidget {
//   const SignupPassword({super.key});

//   @override
//   _SignupPasswordState createState() => _SignupPasswordState();
// }

// class _SignupPasswordState extends State<SignupPassword> {
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   bool _isPasswordValid = false;
//   bool _isConfirmPasswordEnabled = false;
//   bool _doPasswordsMatch = false;
//   String? _passwordErrorMessage;
//   String? _confirmPasswordErrorMessage;
//   bool _isPasswordVisible = false;

//   final Color _checkboxActiveColor = const Color(0xFF87C159);
//   final Color _checkboxCheckColor = Colors.white;

//   @override
//   void initState() {
//     super.initState();
//     _passwordController.addListener(_validatePassword);
//     _confirmPasswordController.addListener(_validateConfirmPassword);
//   }

//   void _validatePassword() {
//     setState(() {
//       _isPasswordValid = _passwordController.text.length >= 6;
//       _passwordErrorMessage = _isPasswordValid ? null : '아직 6자리가 아니에요';
//       _isConfirmPasswordEnabled = _isPasswordValid;
//       if (!_isPasswordValid) {
//         _confirmPasswordController.clear();
//         _doPasswordsMatch = false;
//       }
//       _validateConfirmPassword();
//     });
//   }

//   void _validateConfirmPassword() {
//     setState(() {
//       _doPasswordsMatch =
//           _passwordController.text == _confirmPasswordController.text;
//       _confirmPasswordErrorMessage =
//           (_isConfirmPasswordEnabled && !_doPasswordsMatch)
//               ? '비밀번호가 일치하지 않습니다'
//               : null;
//     });
//   }

//   void _togglePasswordVisibility() {
//     setState(() {
//       _isPasswordVisible = !_isPasswordVisible;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             final titleStyle = TextStyle(
//               fontSize: constraints.maxWidth * 0.07,
//               fontWeight: FontWeight.bold,
//               fontFamily: 'GmarketSansTTFBold',
//             );

//             return SingleChildScrollView(
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(minHeight: constraints.maxHeight),
//                 child: IntrinsicHeight(
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(
//                         horizontal: constraints.maxWidth * 0.1),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(height: constraints.maxHeight * 0.03),
//                         const Center(
//                           child: Text(
//                             '회원가입',
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.w400,
//                               fontFamily: 'GmarketSansTTFMedium',
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: constraints.maxHeight * 0.1),
//                         Padding(
//                           padding: EdgeInsets.only(
//                               left: constraints.maxWidth * 0.05),
//                           child: Text('비밀번호 입력', style: titleStyle),
//                         ),
//                         SizedBox(height: constraints.maxHeight * 0.02),
//                         Center(
//                           child: ConstrainedBox(
//                             constraints: const BoxConstraints(maxWidth: 280),
//                             child: TextField(
//                               controller: _passwordController,
//                               obscureText: !_isPasswordVisible,
//                               decoration: InputDecoration(
//                                 hintText: '비밀번호를 입력해주세요',
//                                 hintStyle: const TextStyle(
//                                   fontFamily: 'GmarketSansTTFMedium',
//                                   fontSize: 15,
//                                 ),
//                                 errorText: _passwordErrorMessage,
//                                 border: const UnderlineInputBorder(),
//                                 focusedBorder: const UnderlineInputBorder(
//                                   borderSide: BorderSide(
//                                       color: Color.fromARGB(255, 0, 0, 0)),
//                                 ),
//                                 enabledBorder: const UnderlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.grey),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: constraints.maxHeight * 0.01),
//                         Center(
//                           child: ConstrainedBox(
//                             constraints: const BoxConstraints(maxWidth: 280),
//                             child: Row(
//                               children: [
//                                 Checkbox(
//                                   value: _isPasswordVisible,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       _isPasswordVisible = value ?? false;
//                                     });
//                                   },
//                                   activeColor: _checkboxActiveColor,
//                                   checkColor: _checkboxCheckColor,
//                                 ),
//                                 Text(
//                                   '비밀번호 보기',
//                                   style: TextStyle(
//                                     fontFamily: 'GmarketSansTTFMedium',
//                                     fontSize: constraints.maxWidth * 0.03,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: constraints.maxHeight * 0.07),
//                         Padding(
//                           padding: EdgeInsets.only(
//                               left: constraints.maxWidth * 0.05),
//                           child: Text('비밀번호 확인', style: titleStyle),
//                         ),
//                         SizedBox(height: constraints.maxHeight * 0.02),
//                         Center(
//                           child: ConstrainedBox(
//                             constraints: const BoxConstraints(maxWidth: 280),
//                             child: TextField(
//                               controller: _confirmPasswordController,
//                               obscureText: !_isPasswordVisible,
//                               enabled: _isConfirmPasswordEnabled,
//                               decoration: InputDecoration(
//                                 hintText: '다시 한번 입력해주세요',
//                                 hintStyle: const TextStyle(
//                                   fontFamily: 'GmarketSansTTFMedium',
//                                   fontSize: 15,
//                                 ),
//                                 errorText: _confirmPasswordErrorMessage,
//                                 border: const UnderlineInputBorder(),
//                                 focusedBorder: const UnderlineInputBorder(
//                                   borderSide: BorderSide(
//                                       color: Color.fromARGB(255, 0, 0, 0)),
//                                 ),
//                                 enabledBorder: const UnderlineInputBorder(
//                                   borderSide: BorderSide(color: Colors.grey),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: constraints.maxHeight * 0.03),
//                         Center(
//                           child: ConstrainedBox(
//                             constraints: const BoxConstraints(maxWidth: 308),
//                             child: SizedBox(
//                               width: double.infinity,
//                               child: ElevatedButton(
//                                 onPressed:
//                                     (_isPasswordValid && _doPasswordsMatch)
//                                         ? () {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                   builder: (context) =>
//                                                       const SignupForm()), // SignupForm으로 이동
//                                             );
//                                           }
//                                         : null,
//                                 style: ButtonStyle(
//                                   backgroundColor:
//                                       WidgetStateProperty.resolveWith<Color>(
//                                     (Set<WidgetState> states) {
//                                       if (states
//                                           .contains(WidgetState.disabled)) {
//                                         return const Color(
//                                             0xffECECEC); // 비활성화 상태 색상
//                                       }
//                                       return const Color(
//                                           0xFF87C159); // 활성화 상태 색상
//                                     },
//                                   ),
//                                   foregroundColor:
//                                       WidgetStateProperty.resolveWith<Color>(
//                                     (Set<WidgetState> states) {
//                                       if (states
//                                           .contains(WidgetState.disabled)) {
//                                         return const Color.fromARGB(255, 255,
//                                             255, 255); // 비활성화 상태 텍스트 색상
//                                       }
//                                       return Colors.white; // 활성화 상태 텍스트 색상
//                                     },
//                                   ),
//                                   shape: WidgetStateProperty.all<
//                                       RoundedRectangleBorder>(
//                                     RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                   ),
//                                   padding: WidgetStateProperty.all<EdgeInsets>(
//                                     const EdgeInsets.symmetric(vertical: 15),
//                                   ),
//                                 ),
//                                 child: const Text('계속하기',
//                                     style: TextStyle(
//                                         fontFamily: 'GmarketSansTTFMedium')),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }
// }
import 'package:flutter/material.dart';
import './signup_userinfo.dart';

class SignupPassword extends StatefulWidget {
  const SignupPassword({super.key});

  @override
  _SignupPasswordState createState() => _SignupPasswordState();
}

class _SignupPasswordState extends State<SignupPassword> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordValid = false;
  bool _isConfirmPasswordEnabled = false;
  bool _doPasswordsMatch = false;
  String? _passwordErrorMessage;
  String? _confirmPasswordErrorMessage;
  bool _isPasswordVisible = false;

  final Color _checkboxActiveColor = const Color(0xFF87C159);
  final Color _checkboxCheckColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePassword);
    _confirmPasswordController.addListener(_validateConfirmPassword);
  }

  void _validatePassword() {
    setState(() {
      _isPasswordValid = _passwordController.text.length >= 6;
      _passwordErrorMessage = _isPasswordValid ? null : '아직 6자리가 아니에요';
      _isConfirmPasswordEnabled = _isPasswordValid;
      if (!_isPasswordValid) {
        _confirmPasswordController.clear();
        _doPasswordsMatch = false;
      }
      _validateConfirmPassword();
    });
  }

  void _validateConfirmPassword() {
    setState(() {
      _doPasswordsMatch =
          _passwordController.text == _confirmPasswordController.text;
      _confirmPasswordErrorMessage =
          (_isConfirmPasswordEnabled && !_doPasswordsMatch)
              ? '비밀번호가 일치하지 않습니다'
              : null;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.05),
                const Text(
                  '회원가입',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'GmarketSansTTFMedium'),
                ),
                SizedBox(height: screenHeight * 0.1),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '비밀번호 입력',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'GmarketSansTTFBold',
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 280),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: '비밀번호를 입력해주세요',
                        hintStyle: const TextStyle(
                          fontFamily: 'GmarketSansTTFMedium',
                          fontSize: 15,
                        ),
                        errorText: _passwordErrorMessage,
                        border: const UnderlineInputBorder(),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 280),
                    child: Row(
                      children: [
                        Checkbox(
                          value: _isPasswordVisible,
                          onChanged: (value) {
                            setState(() {
                              _isPasswordVisible = value ?? false;
                            });
                          },
                          activeColor: _checkboxActiveColor,
                          checkColor: _checkboxCheckColor,
                        ),
                        Text(
                          '비밀번호 보기',
                          style: TextStyle(
                            fontFamily: 'GmarketSansTTFMedium',
                            fontSize: screenWidth * 0.035,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.07),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '비밀번호 확인',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'GmarketSansTTFBold',
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 280),
                    child: TextField(
                      controller: _confirmPasswordController,
                      obscureText: !_isPasswordVisible,
                      enabled: _isConfirmPasswordEnabled,
                      decoration: InputDecoration(
                        hintText: '다시 한번 입력해주세요',
                        hintStyle: const TextStyle(
                          fontFamily: 'GmarketSansTTFMedium',
                          fontSize: 15,
                        ),
                        errorText: _confirmPasswordErrorMessage,
                        border: const UnderlineInputBorder(),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 308),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (_isPasswordValid && _doPasswordsMatch)
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignupForm()), // SignupForm으로 이동
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isPasswordValid && _doPasswordsMatch
                              ? const Color(0xFF87C159)
                              : const Color(0xffECECEC),
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('계속하기',
                            style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'GmarketSansTTFMedium',
                                color: Colors.white)),
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

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
