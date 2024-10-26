import 'package:flutter/material.dart';
import '../services/ImageTransform_service.dart';
import './transform_image_screen.dart';
import './loading_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void showMissionSuccessDialog(BuildContext context, String imagePath) {
  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.missionSuccess,
            style: const TextStyle(fontFamily: 'GmarketSansTTFMedium')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context)!.missionSuccessDescription,
                style: const TextStyle(fontFamily: 'GmarketSansTTFMedium')),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.important_devices),
              label: Text(AppLocalizations.of(context)!.transformImage,
                  style: const TextStyle(fontFamily: 'GmarketSansTTFMedium')),
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
                      SnackBar(
                          content: Text(
                              AppLocalizations.of(context)!.transformError)),
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
        title: Text(AppLocalizations.of(context)!.missionFailure,
            style: const TextStyle(fontFamily: 'GmarketSansTTFMedium')),
        content: Text(AppLocalizations.of(context)!.missionFailureDescription,
            style: const TextStyle(fontFamily: 'GmarketSansTTFMedium')),
        actions: [
          TextButton(
            child: Text(AppLocalizations.of(context)!.tryAgain,
                style: const TextStyle(fontFamily: 'GmarketSansTTFMedium')),
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: 여기에 미션을 다시 시도하는 로직을 추가하세요.
            },
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.cancel,
                style: const TextStyle(fontFamily: 'GmarketSansTTFMedium')),
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
        title: Text(AppLocalizations.of(context)!.uploadFailure),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.uploadFailureDescription),
            const SizedBox(height: 10),
            Text(errorMessage, style: const TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            child: Text(AppLocalizations.of(context)!.ok),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
