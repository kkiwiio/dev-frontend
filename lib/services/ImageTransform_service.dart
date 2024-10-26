import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import '../services/api_service.dart';
import 'dart:convert';

class ImageTransformationService {
  Future<void> startTransformation(String imagePath) async {
    try {
      final sessionCookie = await ApiService.getSessionCookie();
      if (sessionCookie == null) {
        throw Exception('No session cookie found');
      }

      var uri = Uri.parse('http://10.0.2.2:8080/image/transform');
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll({
        'Cookie': sessionCookie,
        'Accept': 'application/json',
      });

      var file = File(imagePath);
      var fileStream = http.ByteStream(file.openRead());
      var fileLength = await file.length();

      var multipartFile = http.MultipartFile('image', fileStream, fileLength,
          filename: path.basename(imagePath));

      request.files.add(multipartFile);

      var response = await request.send();
      await http.Response.fromStream(response);

      if (response.statusCode != 200) {
        throw Exception('Failed to start transformation');
      }
    } catch (e) {
      print('Error in startTransformation: $e');
      rethrow;
    }
  }

  Future<String> checkTransformationStatus() async {
    try {
      final sessionCookie = await ApiService.getSessionCookie();
      if (sessionCookie == null) {
        throw Exception('No session cookie found');
      }

      var uri = Uri.parse('http://10.0.2.2:8080/image/transform/status');
      var response = await http.get(
        uri,
        headers: {
          'Cookie': sessionCookie,
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return response.body.trim();
      } else {
        throw Exception('Failed to check status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in checkTransformationStatus: $e');
      rethrow;
    }
  }

  // 갤러리 이미지 URL 목록 가져오기
  Future<List<String>> getImageUrls() async {
    try {
      final sessionCookie = await ApiService.getSessionCookie();
      if (sessionCookie == null) {
        throw Exception('No session cookie found');
      }

      var uri = Uri.parse('http://10.0.2.2:8080/api/images');
      var response = await http.get(
        uri,
        headers: {
          'Cookie': sessionCookie,
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> urls = json.decode(response.body);
        return urls.cast<String>();
      } else {
        throw Exception('Failed to get image URLs: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getImageUrls: $e');
      rethrow;
    }
  }
}
