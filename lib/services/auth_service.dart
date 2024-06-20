import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences import

// class AuthService {
//   Future<String?> register(String name, String email, String password,
//       {int reward = 0}) async {
//     const url = 'http://192.168.1.79:8080/api/users/signup';
//     final response = await http.post(
//       Uri.parse(url),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, dynamic>{
//         'name': name,
//         'email': email,
//         'pw': password,
//         'reward': reward,
//       }),
//     );

//     if (response.statusCode == 201) {
//       return "User registered successfully";
//     } else {
//       return "Failed to register user: ${response.body}";
//     }
//   }

//   Future<String?> login(String email, String password) async {
//     const url = 'http://192.168.1.79:8080/api/users/login';
//     final response = await http.post(
//       Uri.parse(url),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'email': email,
//         'pw': password,
//       }),
//     );

//     if (response.statusCode == 200) {
//       return "Login successful";
//     } else {
//       return "Failed to login: ${response.body}";
//     }
//   }
// }

class AuthService extends ChangeNotifier {
  Future<String?> register(String name, String email, String password,
      {int reward = 0}) async {
    const url = 'http://10.0.2.2:8080/api/users/signup';
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
    const url = 'http://10.0.2.2:8080/api/users/login';
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

      // userId를 SharedPreferences에 저장
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userId);

      return "Login successful";
    } else {
      return "Failed to login: ${response.body}";
    }
  }

// 추가적인 메소드나 상태를 여기서 정의
}
