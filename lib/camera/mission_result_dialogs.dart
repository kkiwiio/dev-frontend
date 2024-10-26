import 'package:flutter/material.dart';
import '../services/ImageTransform_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../naver_map/naver_map.dart';
import 'dart:async';

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
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const NaverMapApp()),
                  (Route<dynamic> route) => false,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.transformImage),
                    duration: const Duration(seconds: 3),
                  ),
                );

                try {
                  final imageTransformationService =
                      ImageTransformationService();
                  // 변환 시작
                  await imageTransformationService
                      .startTransformation(imagePath);

                  // 상태 확인 타이머 시작
                  Timer.periodic(const Duration(seconds: 3), (timer) async {
                    try {
                      final status = await imageTransformationService
                          .checkTransformationStatus();
                      print('Transform status: $status'); // 디버깅용

                      if (!context.mounted) {
                        timer.cancel();
                        return;
                      }

                      if (status == 'COMPLETED') {
                        timer.cancel();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                AppLocalizations.of(context)!.tranformalarm),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      } else if (status == 'FAILED') {
                        timer.cancel();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                AppLocalizations.of(context)!.transformError),
                            duration: const Duration(seconds: 3),
                          ),
                        );
                      }
                    } catch (e) {
                      print('Status check error: $e');
                      timer.cancel();
                    }
                  });
                } catch (e) {
                  print('Error starting transformation: $e');
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            AppLocalizations.of(context)!.transformingerror),
                        duration: const Duration(seconds: 3),
                      ),
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
