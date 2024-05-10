import 'package:flutter/material.dart';



class Sign_up extends StatefulWidget {
  @override
  _Sign_upState createState() => _Sign_upState();
}

class _Sign_upState extends State<Sign_up> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Column(
            children: <Widget>[
              Center(
                child: Text(
                  'Sign up',
                  style: TextStyle(
                      height: 1.5,
                      fontWeight: FontWeight.bold,
                      fontSize: 35,
                      fontFamily: 'Nanum Barumpen',
                      //나눔 글꼴
                      fontStyle: FontStyle.normal),
                ),
              ),
            ],
          ),
        ),
      ),

      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                    icon: Icon(Icons.account_circle),
                    labelText: "회원가입할 이메일을 입력해주세요",
                    border: OutlineInputBorder(),
                    hintText: 'E-mail'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "이메일을 입력해주세요";
                  }
                  return null;
                },
              ),
              /*Container(
                margin: const EdgeInsets.only(top: 16.0),
                alignment: Alignment.centerRight,
                child: RaisedButton(
                  onPressed: () {
                    //클릭시 검증
                  },
                  child: Text(
                      '이메일 인증'
                  ),
                ),
              ),*/
              SizedBox(
                height: 30.0,
              ),
              TextFormField(
                obscureText: true, // 비밀번호를 적을때 안보이도록
                controller: _passwordController,
                decoration: InputDecoration(
                    icon: Icon(Icons.vpn_key),
                    labelText: "회원가입할 비밀번호를 입력해주세요",
                    border: OutlineInputBorder(),
                    hintText: 'password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "비밀번호를 입력해주세요";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                obscureText: true, // 비밀번호를 적을때 안보이도록
                decoration: InputDecoration(
                    icon: Icon(Icons.vpn_key),
                    labelText: "비밀번호를 한번 더 입력해주세요",
                    border: OutlineInputBorder(),
                    hintText: 'password'),
                validator: (value) {
                  if (value != _passwordController) {
                    return "비밀번호가 일치하지 않습니다.";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
