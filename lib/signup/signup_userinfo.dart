import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';

class SignupForm extends StatefulWidget {
  final String email;
  final String password;

  const SignupForm({super.key, required this.email, required this.password});

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  File? _image;
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _studentIdController = TextEditingController();
  String? _selectedMajor;
  final Map<String, int> _majorIdMap = {
    '일어일본한전공': 1,
    '중어중국학전공': 2,
    '종교와신학전공': 3,
    '경영학전공': 4,
    '사회복지학전공': 5,
    '사회학전공': 6,
    '경제학전공': 7,
    '정치외교학전공': 8,
    '신문방송학전공': 9,
    '디지털콘텐츠전공': 10,
    '영상콘텐츠전공': 11,
    '인공지능전공': 12,
    '빅데이터 응용전공': 13,
    '소프트웨어 융합전공': 14,
    '대학원': 15,
    '학과없음': 16,
  };

  Future<void> _getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        final user = Users(
          studentId: _studentIdController.text,
          password: widget.password,
          userName: _nameController.text,
          // majorId: _majors.indexOf(_selectedMajor!) + 1,
          majorId: _majorIdMap[_selectedMajor] ?? 0,
          userId: widget.email,
        );
        print('Sending user data: ${user.toJson()}');
        final result = await ApiService.signup(user);
        print('Signup successful: $result');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('회원가입이 완료되었습니다')),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      } catch (e) {
        print('Signup failed: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('회원가입에 실패했습니다: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.05),
                const Text(
                  '회원가입',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'GmarketSansTTFMedium'),
                ),
                SizedBox(height: screenHeight * 0.03),
                GestureDetector(
                  onTap: _getImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: screenWidth * 0.13,
                        backgroundColor: const Color(0xffD8D8D8),
                        backgroundImage:
                            _image != null ? FileImage(_image!) : null,
                        child: _image == null
                            ? Icon(
                                Icons.person,
                                size: screenWidth * 0.18,
                                color: const Color(0xffF3F3F3),
                              )
                            : null,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: screenWidth * 0.08,
                          height: screenWidth * 0.08,
                          decoration: const BoxDecoration(
                            color: Color(0xFF909090),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.add,
                              color: Colors.white, size: screenWidth * 0.05),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('이름',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'GmarketSansTTFBold',
                          )),
                      SizedBox(height: screenHeight * 0.01),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: '이름을 입력하세요',
                          hintStyle: TextStyle(
                            fontFamily: 'GmarketSansTTFMedium',
                            fontSize: 15,
                          ),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xffA1A1A1), width: 2.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '이름을 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      const Text('학번',
                          style: TextStyle(
                              fontSize: 20, fontFamily: 'GmarketSansTTFBold')),
                      SizedBox(height: screenHeight * 0.01),
                      TextFormField(
                        controller: _studentIdController,
                        decoration: const InputDecoration(
                          hintText: '학번(9자리)을 입력하세요',
                          hintStyle: TextStyle(
                            fontFamily: 'GmarketSansTTFMedium',
                            fontSize: 15,
                          ),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xffA1A1A1), width: 2.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '학번을 입력해주세요';
                          }
                          if (value.length != 9) {
                            return '학번은 9자리여야 합니다';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      const Text('전공',
                          style: TextStyle(
                              fontSize: 20, fontFamily: 'GmarketSansTTFBold')),
                      SizedBox(height: screenHeight * 0.01),
                      DropdownButtonFormField<String>(
                        value: _selectedMajor,
                        hint: const Text(
                          '전공을 선택하세요',
                          style: TextStyle(
                            fontFamily: 'GmarketSansTTFMedium',
                            fontSize: 15,
                          ),
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedMajor = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '전공을 선택해주세요';
                          }
                          return null;
                        },
                        items: _majorIdMap.keys
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                fontFamily: 'GmarketSansTTFMedium',
                                fontSize: 15,
                              ),
                            ),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xffA1A1A1), width: 2.0),
                          ),
                        ),
                        isExpanded: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF87C159),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('가입하기',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: 'GmarketSansTTFMedium',
                          color: Colors.white)),
                ),
                SizedBox(height: screenHeight * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
