import 'package:flutter/material.dart';
import '../services/ImageTransform_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../naver_map/naver_map.dart';
import '../services/transform_message.dart';

// mission_result_dialogs.dart

// lib/dialogs/mission_result_dialogs.dart
void showMissionSuccessDialog(BuildContext context, String imagePath) {
  final imageTransformationService = ImageTransformationService();

  imageTransformationService.setNotificationMessages(NotificationMessages(
    transformCompleteBody: AppLocalizations.of(context)!.transformingImage,
    transformFailBody: AppLocalizations.of(context)!.transformingerror,
  ));

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
                try {
                  await imageTransformationService
                      .queueTransformation(imagePath);

                  if (context.mounted) {
                    Navigator.of(dialogContext).pop();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NaverMapApp()),
                      (Route<dynamic> route) => false,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            AppLocalizations.of(context)!.transformingImage),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                } catch (e) {
                  print('Error in transform request: $e');
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            AppLocalizations.of(context)!.transformingImage),
                        backgroundColor: Colors.red,
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
