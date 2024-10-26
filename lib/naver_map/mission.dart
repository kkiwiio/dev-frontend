import 'package:flutter/material.dart';
import '../camera/guided_camera_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MissionDialog extends StatelessWidget {
  final String missionDescription;
  final String missionImage;
  final String idNumber;
  final String filterImage;

  const MissionDialog({
    super.key,
    required this.missionDescription,
    required this.missionImage,
    required this.idNumber,
    required this.filterImage,
  });

  void _openCamera(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GuidedCameraScreen(
          filterImage: filterImage,
          idNumber: idNumber,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                AppLocalizations.of(context)!.mission,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'GmarketSansTTFBold',
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                missionDescription,
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'GmarketSansTTFMedium',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            Image.asset(
              missionImage,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 15),
            Center(
              child: SizedBox(
                width: 120,
                height: 35,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF6CBDCA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () => _openCamera(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.camera_alt, color: Colors.black),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.photo,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
