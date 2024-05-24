import 'package:flutter/material.dart';
import 'package:project_heck/naver_map/naver_map.dart';
import 'package:project_heck/login/sign_up.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              _buildLogo(),
              _buildLoginForm(context),
              _buildSignUpButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: Column(
        children: [
          Image.asset('image/main.png', width: 170.0),
          const Padding(
            padding: EdgeInsets.only(top: 30),
            child: Text(
              '스쿠벤처에 오신걸 환영합니다',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              autofocus: true,
              decoration: const InputDecoration(labelText: '이메일'),
              keyboardType: TextInputType.emailAddress,
              onSubmitted: (value) {
                if (!value.contains('@')) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('유효한 이메일 주소를 입력해주세요.')),
                  );
                }
              },
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            const SizedBox(height: 40.0),
            _buildLoginButton(
                context), // Updated to use new login button method
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: 307,
      height: 47,
      child: ElevatedButton(
        onPressed: () {
          if (emailController.text.contains('@') &&
              passwordController.text.isNotEmpty) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const NaverMapApp()));
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color(0xFFF4FFCC)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          )),
        ),
        child: const Text('Login'),
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: TextButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const SignUp()));
        },
        child:
            const Text('회원가입', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
