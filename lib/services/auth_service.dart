import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends ChangeNotifier {
  Future<String?> register(String name, String email, String password,
      {int reward = 0}) async {
    // const url = 'http://10.0.2.2:8080/api/users/signup'; //로컬용
    const url = 'http://192.168.1.79:8080/api/users/login';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'email': email,
        'pw': password,
        'reward': reward,
      }),
    );

    if (response.statusCode == 201) {
      return "User registered successfully";
    } else {
      return "Failed to register user: ${response.body}";
    }
  }

  Future<String?> login(String email, String password) async {
    // const url = 'http://10.0.2.2:8080/api/users/login'; //로컬용
    const url = 'http://192.168.1.79:8080/api/users/login';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'pw': password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final userId = data['userId'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userId);

      return "로그인 성공";
    } else {
      return "Failed to login: ${response.body}";
    }
  }
}
