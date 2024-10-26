import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  late Map<String, int> _majorIdMap;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _majorIdMap = {
      AppLocalizations.of(context)!.majorJapanese: 1,
      AppLocalizations.of(context)!.majorChinese: 2,
      AppLocalizations.of(context)!.majorTheology: 3,
      AppLocalizations.of(context)!.majorBusiness: 4,
      AppLocalizations.of(context)!.majorSocialWelfare: 5,
      AppLocalizations.of(context)!.majorSociology: 6,
      AppLocalizations.of(context)!.majorEconomics: 7,
      AppLocalizations.of(context)!.majorPolitics: 8,
      AppLocalizations.of(context)!.majorJournalism: 9,
      AppLocalizations.of(context)!.majorDigitalContents: 10,
      AppLocalizations.of(context)!.majorVideoContents: 11,
      AppLocalizations.of(context)!.majorAI: 12,
      AppLocalizations.of(context)!.majorBigData: 13,
      AppLocalizations.of(context)!.majorSoftware: 14,
      AppLocalizations.of(context)!.majorGraduate: 15,
      AppLocalizations.of(context)!.majorNone: 16,
    };
  }

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
        // print('Sending user data: ${user.toJson()}');
        final result = await ApiService.signup(user);
        // print('Signup successful: $result');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.signupSuccess)),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      } catch (e) {
        // print('Signup failed: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.signupError)),
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
                Text(
                  AppLocalizations.of(context)!.signup,
                  style: const TextStyle(
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
                      Text(AppLocalizations.of(context)!.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: 'GmarketSansTTFBold',
                          )),
                      SizedBox(height: screenHeight * 0.01),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText:
                              AppLocalizations.of(context)!.namePlaceholder,
                          hintStyle: const TextStyle(
                            fontFamily: 'GmarketSansTTFMedium',
                            fontSize: 12,
                          ),
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xffA1A1A1), width: 2.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.nameError;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(AppLocalizations.of(context)!.studentId,
                          style: const TextStyle(
                              fontSize: 20, fontFamily: 'GmarketSansTTFBold')),
                      SizedBox(height: screenHeight * 0.01),
                      TextFormField(
                        controller: _studentIdController,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!
                              .studentIdPlaceholder,
                          hintStyle: const TextStyle(
                            fontFamily: 'GmarketSansTTFMedium',
                            fontSize: 12,
                          ),
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color(0xffA1A1A1), width: 2.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!
                                .studentIdError2;
                          }
                          if (value.length != 9) {
                            return AppLocalizations.of(context)!.studentIdError;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Text(AppLocalizations.of(context)!.major,
                          style: const TextStyle(
                              fontSize: 20, fontFamily: 'GmarketSansTTFBold')),
                      SizedBox(height: screenHeight * 0.01),
                      DropdownButtonFormField<String>(
                        value: _selectedMajor,
                        hint: Text(
                          AppLocalizations.of(context)!.majorPlaceholder,
                          style: const TextStyle(
                            fontFamily: 'GmarketSansTTFMedium',
                            fontSize: 12,
                          ),
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedMajor = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.majorError;
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
                  child: Text(AppLocalizations.of(context)!.signupButton,
                      style: const TextStyle(
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
