// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
// import 'package:http/http.dart' as http;
// import 'package:path/path.dart' as path;
// import 'mission_result_dialogs.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class DisplayImageScreen extends StatelessWidget {
//   final String imagePath;
//   final String idNumber;
//   final String filterImage;

//   const DisplayImageScreen({
//     super.key,
//     required this.imagePath,
//     required this.idNumber,
//     required this.filterImage,
//   });

//   Future<File> _fixExifRotation(String imagePath) async {
//     return await FlutterExifRotation.rotateImage(path: imagePath);
//   }

//   void _retakePicture(BuildContext context) {
//     Navigator.pop(context);
//   }

//   Future<void> _submitPicture(BuildContext context) async {
//     try {
//       var uri = Uri.parse('http://10.0.2.2:8080/image/compare');
//       print('Sending request to: $uri');

//       var request = http.MultipartRequest('POST', uri);

//       var file = File(imagePath);
//       var fileStream = http.ByteStream(file.openRead());
//       var fileLength = await file.length();

//       var multipartFile = http.MultipartFile('image', fileStream, fileLength,
//           filename: path.basename(imagePath));

//       request.files.add(multipartFile);
//       request.fields['buildingNumber'] = idNumber;

//       print('Request fields: ${request.fields}');
//       print('Request files: ${request.files.map((f) => f.filename).toList()}');

//       var streamedResponse = await request.send();
//       var response = await http.Response.fromStream(streamedResponse);

//       print('Response status: ${response.statusCode}');
//       print('Response body: ${response.body}');

//       if (response.statusCode == 200) {
//         int result = int.parse(response.body);
//         if (result == 1) {
//           showMissionSuccessDialog(context, imagePath);
//         } else if (result == 0) {
//           showMissionFailureDialog(context);
//         } else {
//           throw Exception('Unexpected result: $result');
//         }
//       } else if (response.statusCode == 401) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content: Text('인증되지 않은 사용자입니다. 다시 로그인해주세요.',
//                   style: TextStyle(fontFamily: 'GmarketSansTTFMedium'))),
//         );
//       } else {
//         throw Exception(
//             'Failed to submit image: ${response.statusCode}, ${response.body}');
//       }
//     } catch (e) {
//       print('Error in _submitPicture: $e');
//       showUploadFailureDialog(context, e.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(AppLocalizations.of(context)!.phototaken,
//             style: const TextStyle(color: Colors.white)),
//         backgroundColor: Colors.black,
//       ),
//       body: FutureBuilder<File>(
//         future: _fixExifRotation(imagePath),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return Column(
//               children: [
//                 Expanded(
//                   child: Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       color: Colors.black,
//                       image: DecorationImage(
//                         image: FileImage(snapshot.data!),
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   padding: const EdgeInsets.all(16.0),
//                   color: Colors.black,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       ElevatedButton.icon(
//                         icon: const Icon(Icons.camera_alt),
//                         label: Text(AppLocalizations.of(context)!.photoagain,
//                             style: const TextStyle(
//                                 fontFamily: 'GmarketSansTTFMedium')),
//                         onPressed: () => _retakePicture(context),
//                         style: ElevatedButton.styleFrom(
//                           foregroundColor: Colors.white,
//                           backgroundColor: Colors.grey[800],
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 12),
//                         ),
//                       ),
//                       ElevatedButton.icon(
//                         icon: const Icon(Icons.check),
//                         label: Text(AppLocalizations.of(context)!.submitphoto,
//                             style: const TextStyle(
//                                 fontFamily: 'GmarketSansTTFMedium')),
//                         onPressed: () => _submitPicture(context),
//                         style: ElevatedButton.styleFrom(
//                           foregroundColor: Colors.white,
//                           backgroundColor: const Color(0xFF87C159),
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 12),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           } else {
//             return const Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
// }
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'mission_result_dialogs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../services/ImageTransform_service.dart';

class DisplayImageScreen extends StatelessWidget {
  final String imagePath;
  final String idNumber;
  final String filterImage;
  final imageTransformationService = ImageTransformationService();

  DisplayImageScreen({
    super.key,
    required this.imagePath,
    required this.idNumber,
    required this.filterImage,
  });

  Future<File> _fixExifRotation(String imagePath) async {
    return await FlutterExifRotation.rotateImage(path: imagePath);
  }

  void _retakePicture(BuildContext context) {
    Navigator.pop(context);
  }

  // Future<void> _submitPicture(BuildContext context) async {
  //   try {
  //     var uri = Uri.parse('http://10.0.2.2:8080/image/compare');
  //     print('Sending request to: $uri');

  //     var request = http.MultipartRequest('POST', uri);

  //     var file = File(imagePath);
  //     var fileStream = http.ByteStream(file.openRead());
  //     var fileLength = await file.length();

  //     var multipartFile = http.MultipartFile('image', fileStream, fileLength,
  //         filename: path.basename(imagePath));

  //     request.files.add(multipartFile);
  //     request.fields['buildingNumber'] = idNumber;

  //     print('Request fields: ${request.fields}');
  //     print('Request files: ${request.files.map((f) => f.filename).toList()}');

  //     var streamedResponse = await request.send();
  //     var response = await http.Response.fromStream(streamedResponse);

  //     print('Response status: ${response.statusCode}');
  //     print('Response body: ${response.body}');

  //     if (response.statusCode == 200) {
  //       int result = int.parse(response.body);
  //       if (result == 1) {
  //         // 미션 성공시 항상 일반 성공 다이얼로그 표시
  //         if (context.mounted) {
  //           showMissionSuccessDialog(context, imagePath);
  //         }
  //       } else if (result == 0) {
  //         showMissionFailureDialog(context);
  //       } else {
  //         throw Exception('Unexpected result: $result');
  //       }
  //     } else if (response.statusCode == 401) {
  //       if (context.mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //               content: Text('인증되지 않은 사용자입니다. 다시 로그인해주세요.',
  //                   style: TextStyle(fontFamily: 'GmarketSansTTFMedium'))),
  //         );
  //       }
  //     } else {
  //       throw Exception(
  //           'Failed to submit image: ${response.statusCode}, ${response.body}');
  //     }
  //   } catch (e) {
  //     print('Error in _submitPicture: $e');
  //     if (context.mounted) {
  //       showUploadFailureDialog(context, e.toString());
  //     }
  //   }
  // }
  Future<void> _submitPicture(BuildContext context) async {
    try {
      var uri = Uri.parse('http://10.0.2.2:8080/image/compare');
      print('Sending request to: $uri');

      // 미션 판정 요청 생성
      var request = http.MultipartRequest('POST', uri);
      var file = File(imagePath);
      var fileStream = http.ByteStream(file.openRead());
      var fileLength = await file.length();

      var multipartFile = http.MultipartFile('image', fileStream, fileLength,
          filename: path.basename(imagePath));

      request.files.add(multipartFile);
      request.fields['buildingNumber'] = idNumber;

      // 즉시 요청 전송
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // 응답 처리
      if (response.statusCode == 200) {
        int result = int.parse(response.body);

        // 성공/실패 즉시 표시
        if (result == 1) {
          if (context.mounted) {
            showMissionSuccessDialog(context, imagePath);
          }
        } else if (result == 0) {
          showMissionFailureDialog(context);
        }
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('인증되지 않은 사용자입니다. 다시 로그인해주세요.',
                style: TextStyle(fontFamily: 'GmarketSansTTFMedium')),
          ),
        );
      } else {
        throw Exception('Failed to submit image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in _submitPicture: $e');
      if (context.mounted) {
        showUploadFailureDialog(context, e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.phototaken,
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<File>(
        future: _fixExifRotation(imagePath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      image: DecorationImage(
                        image: FileImage(snapshot.data!),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.camera_alt),
                        label: Text(AppLocalizations.of(context)!.photoagain,
                            style: const TextStyle(
                                fontFamily: 'GmarketSansTTFMedium')),
                        onPressed: () => _retakePicture(context),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.grey[800],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.check),
                        label: Text(AppLocalizations.of(context)!.submitphoto,
                            style: const TextStyle(
                                fontFamily: 'GmarketSansTTFMedium')),
                        onPressed: () => _submitPicture(context),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF87C159),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
