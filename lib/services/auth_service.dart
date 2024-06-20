import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  Future<String?> register(String name, String email, String password,
      {int reward = 0}) async {
    const url = 'http://192.168.1.79:8080/api/users/signup';
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
      return "Login successful";
    } else {
      return "Failed to login: ${response.body}";
    }
  }
}
