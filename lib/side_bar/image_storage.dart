import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ImageStorageScreen extends StatefulWidget {
  @override
  _ImageStorageScreenState createState() => _ImageStorageScreenState();
}

class _ImageStorageScreenState extends State<ImageStorageScreen> {
  List<String> _imageUrls = [];
  String? userId;
  bool _isLoading = true;  // 로딩 상태 플래그 추가

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
    if (userId != null) {
      _fetchImageUrls();
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchImageUrls() async {
    final url = Uri.parse('http://10.0.2.2:8080/api/images?userId=$userId');  // 포트 번호 수정
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        final imageUrls = jsonData.cast<String>().toList();
        setState(() {
          _imageUrls = imageUrls;
          _isLoading = false;  // 로딩 완료
        });
      } else {
        throw Exception('Failed to fetch image URLs');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to fetch images: $e'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('저장된 이미지'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Color(0xFFEFF2D7),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : (_imageUrls.isEmpty
            ? Center(child: Text("변환된 사진이 아직 없습니다!"))
            : Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: _imageUrls.length,
            itemBuilder: (context, index) {
              return Image.network(_imageUrls[index], fit: BoxFit.cover);
            },
          ),
        )),
      ),
    );
  }
}
