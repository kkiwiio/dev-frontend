import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';

class TransformImageSave {
  static Future<void> saveImage(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      final directory = await getTemporaryDirectory();
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final file = File('${directory.path}/$fileName.jpg');
      await file.writeAsBytes(response.bodyBytes);

      final result = await ImageGallerySaver.saveFile(file.path);
      print('이미지가 성공적으로 저장되었습니다. 결과: $result');
    } catch (e) {
      print('Error saving image: $e');
    }
  }
}