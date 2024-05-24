import 'package:project_heck/naver_map/maker_campus.dart';
import 'package:project_heck/naver_map/campusmarker_model.dart';

enum CampusType { hssc, nsc }

extension CampusTypeExtension on CampusType {
  List<CampusMarker> get markername {
    switch (this) {
      case CampusType.hssc:
        return hsscMarkers;
      case CampusType.nsc:
        return nscMarkers;
    }
  }
}
