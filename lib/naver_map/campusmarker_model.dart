import 'package:flutter_naver_map/flutter_naver_map.dart';

class CampusMarker {
  final String idNumber;
  final NLatLng position;
  final String buildingName;
  final String buildingDescription;
  final String missionDescription;
  final String imagePath;
  final String missionImage;
  double distance = 0;

  CampusMarker({
    required this.idNumber,
    required this.position,
    required this.buildingName,
    required this.buildingDescription,
    required this.missionDescription,
    required this.imagePath,
    required this.missionImage,
    this.distance = 0,
  });
}
