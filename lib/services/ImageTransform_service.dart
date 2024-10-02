import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class ImageTransformationService {
  Future<String> transformImage(String imagePath) async {
    var uri = Uri.parse('http://10.0.2.2:8080/image/transform');
    var request = http.MultipartRequest('POST', uri);

    var file = File(imagePath);
    var fileStream = http.ByteStream(file.openRead());
    var fileLength = await file.length();

    var multipartFile = http.MultipartFile('image', fileStream, fileLength,
        filename: path.basename(imagePath));

    request.files.add(multipartFile);

    try {
      print('Sending image transformation request...');
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print('Received response. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        print('Transformation successful. Returned URL: ${response.body}');

        return response.body.trim();
      } else if (response.statusCode == 401) {
        print('Authentication error');
        throw Exception('User not authenticated');
      } else {
        print('Transformation failed');
        throw Exception(
            'Failed to transform image: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error during image transformation: $e');
      throw Exception('Error in image transformation: $e');
    }
  }
}
