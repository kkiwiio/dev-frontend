import 'package:flutter/material.dart';
import '../services/ImageTransform_service.dart';
import './transform_image_screen.dart';
import './loading_screen.dart';

void showMissionSuccessDialog(BuildContext context, String imagePath) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('미션 성공',
            style: TextStyle(fontFamily: 'GmarketSansTTFMedium')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('미션을 성공적으로 완료했습니다!',
                style: TextStyle(fontFamily: 'GmarketSansTTFMedium')),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.important_devices),
              label: const Text('이미지 변환',
                  style: TextStyle(fontFamily: 'GmarketSansTTFMedium')),
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // 다이얼로그 닫기

                // 로딩 화면 표시
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const LoadingScreen(),
                ));

                try {
                  final imageTransformationService =
                      ImageTransformationService();
                  final transformedImageUrl = await imageTransformationService
                      .transformImage(imagePath);
                  print(
                      'Transformed Image URL: $transformedImageUrl'); // URL 확인용 로그

                  if (context.mounted) {
                    // 로딩 화면을 제거하고 변환된 이미지 화면으로 전환
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) =>
                          TransformedImageScreen(imageUrl: transformedImageUrl),
                    ));
                  }
                } catch (e) {
                  print('Error transforming image: $e');
                  if (context.mounted) {
                    // 오류 발생 시 로딩 화면 제거
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('이미지 변환 중 오류가 발생했습니다: $e')),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      );
    },
  );
}

void showMissionFailureDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('미션 실패',style: TextStyle(fontFamily: 'GmarketSansTTFMedium')),
        content: const Text('미션에 실패했습니다. \n다시 시도하시겠습니까?',  style: TextStyle(fontFamily: 'GmarketSansTTFMedium')),
        actions: [
          TextButton(
            child: const Text('다시 시도',  style: TextStyle(fontFamily: 'GmarketSansTTFMedium')),
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: 여기에 미션을 다시 시도하는 로직을 추가하세요.
            },
          ),
          TextButton(
            child: const Text('취소',  style: TextStyle(fontFamily: 'GmarketSansTTFMedium')),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

void showUploadFailureDialog(BuildContext context, String errorMessage) {
  print('이미지 업로드 실패: $errorMessage');
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('업로드 실패'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('이미지 업로드에 실패했습니다. 다시 시도해 주세요.'),
            const SizedBox(height: 10),
            const Text('오류 상세:'),
            Text(errorMessage, style: const TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('확인'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
