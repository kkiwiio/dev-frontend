import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './signup_userinfo.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignupPassword extends StatefulWidget {
  final String email;

  const SignupPassword({super.key, required this.email});

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
      _passwordErrorMessage =
          _isPasswordValid ? null : AppLocalizations.of(context)!.passwordValid;
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
              ? AppLocalizations.of(context)!.passwordConfirmError
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
                Text(
                  AppLocalizations.of(context)!.signup,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'GmarketSansTTFMedium'),
                ),
                SizedBox(height: screenHeight * 0.1),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.signupPasswordTitle,
                    style: const TextStyle(
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
                        hintText:
                            AppLocalizations.of(context)!.passwordPlaceholder,
                        hintStyle: const TextStyle(
                          fontFamily: 'GmarketSansTTFMedium',
                          fontSize: 12,
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
                          AppLocalizations.of(context)!.showPassword,
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
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.checkPassword,
                    style: const TextStyle(
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
                        hintText: AppLocalizations.of(context)!.confirmPassword,
                        hintStyle: const TextStyle(
                          fontFamily: 'GmarketSansTTFMedium',
                          fontSize: 12,
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
                                      builder: (context) => SignupForm(
                                          email: widget.email,
                                          password: _passwordController
                                              .text)), // SignupForm으로 이동
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
                        child: Text(
                            AppLocalizations.of(context)!.continueButton,
                            style: const TextStyle(
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
