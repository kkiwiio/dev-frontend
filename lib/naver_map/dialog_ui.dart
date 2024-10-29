import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:project_heck/naver_map/campusmarker_model.dart';
import 'package:project_heck/naver_map/mission.dart';
import 'package:project_heck/naver_map/quiz.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TopRoundedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 30);
    path.arcToPoint(
      Offset(size.width - 30, 0),
      radius: const Radius.circular(30),
      clockwise: false,
    );
    path.lineTo(30, 0);
    path.arcToPoint(
      const Offset(0, 30),
      radius: const Radius.circular(30),
      clockwise: false,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

void showMarkerDialog(BuildContext context, CampusMarker campusmarker) {
  log("showMarkerDialog called for ${campusmarker.buildingName}");
  showDialog(
    context: context,
    builder: (BuildContext context) {
      log("Building Dialog for ${campusmarker.buildingName}");
      return Dialog(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          width: 263,
          height: 320,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ClipPath(
                clipper: TopRoundedClipper(),
                child: Image.asset(
                  campusmarker.imagePath,
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                campusmarker.buildingName,
                style: const TextStyle(
                  fontFamily: 'GmarketSansTTFBold',
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              Text(
                campusmarker.buildingDescription,
                style: const TextStyle(
                  fontFamily: 'GmarketSansTTFMedium',
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 120,
                height: 35,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF6CBDCA),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    if (campusmarker.buildingName ==
                        AppLocalizations.of(context)!.building3) {
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const QuizScreen();
                        },
                      );
                    } else {
                      Navigator.of(context).pop();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return MissionDialog(
                            missionDescription: campusmarker.missionDescription,
                            missionImage: campusmarker.missionImage,
                            idNumber: campusmarker.idNumber,
                            filterImage: campusmarker.filterImg,
                          );
                        },
                      );
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.mission,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'GmarketSansTTFBol',
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
