import 'package:flutter/material.dart';
import 'onboarding.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'skhu adventure',
      home: OnBoardingPage(),
    );
  }
}

class LogIn extends StatefulWidget {
  const LogIn({super.key});
  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController controller2 = TextEditingController();

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
              Center(
                child: Column(
                  children: [
                    const Image(
                      image: AssetImage('image/main.png'),
                      width: 170.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: const Text(
                          '스쿠벤처에 오신걸 환영합니다',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                          )
                      ),
                    ),
                  ],
                ),
              ),
              Form(
                  child: Theme(
                    data: ThemeData(
                        primaryColor: Colors.teal,
                        inputDecorationTheme: const InputDecorationTheme(
                            labelStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 15.0
                            )
                        )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: controller,
                            autofocus: true,
                            decoration: const InputDecoration(labelText: '이메일'),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          TextField(
                            controller: controller2,
                            decoration: const InputDecoration(labelText: '비밀번호'),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                          ),
                          const SizedBox(height: 40.0),
                          SizedBox(
                            width: 307,  // 버튼의 너비를 지정
                            height: 47,  // 버튼의 높이를 지정
                            child: ElevatedButton(
                              onPressed: () {
                                if (controller.text == 'mei@hello.com' &&
                                    controller2.text == '1234') {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const NextPage()));
                                  // 이전과 동일한 로직
                                }
                                else if (controller.text == 'mei@hello.com' &&
                                    controller2.text != '1234') {
                                  showSnackBar(context, const Text('Wrong password'));
                                }
                                else if (controller.text != 'mei@hello.com' &&
                                    controller2.text == '1234') {
                                  showSnackBar(context, const Text('Wrong email'));
                                }
                                else {
                                  showSnackBar(context, const Text(
                                      'Check your info again'));
                                }
                              },
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all(Colors.grey[700]),
                                backgroundColor: MaterialStateProperty.all(const Color(0xFFF4FFCC)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                              child: const Text(
                                  '시작하기',
                                  style: TextStyle(
                                      fontSize: 16
                                  )
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}

void showSnackBar(BuildContext context, Text text) {
  final snackBar = SnackBar(
    content: text,
    backgroundColor: const Color(0xFFF29365),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

class NextPage extends StatelessWidget {
  const NextPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
