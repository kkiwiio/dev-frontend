import 'package:flutter/material.dart';
import 'sign_up.dart';

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
              SizedBox(height: 40),
              _buildLogo(),
              _buildLoginForm(context),
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
          Padding(
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
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: '비밀번호'),
              obscureText: true,
            ),
            SizedBox(height: 40.0),
            _buildLoginButton(),
            _buildSignUpButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: 307,
      height: 47,
      child: ElevatedButton(
        onPressed: () {
          // Login button logic
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xFFF4FFCC)),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
        ),
        child: const Text('시작하기', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Sign_up()),
          );
        },
        child: const Text('회원가입', style: TextStyle(fontSize: 15)),
      ),
    );
  }
}
