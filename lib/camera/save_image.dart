import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

Future<void> saveImage(BuildContext context, String imagePath) async {
  try {
    final result = await ImageGallerySaver.saveFile(imagePath);

    if (result['isSuccess']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image saved to gallery')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save image')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to save image: $e')),
    );
  }
}
