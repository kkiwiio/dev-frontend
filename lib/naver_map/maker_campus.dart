import "package:flutter_naver_map/flutter_naver_map.dart";
import "package:flutter/material.dart";
import "package:project_heck/naver_map/campusmarker_model.dart";
import 'package:project_heck/naver_map/campus_type.dart';

const icon = NOverlayImage.fromAssetImage('image/cat.png');

List<CampusMarker> hsscMarkers = [
  CampusMarker(
    idNumber: "1", //구두인관
    position: const NLatLng(37.48832747432825, 126.82506351811703),
  ),
  CampusMarker(
    idNumber: "2", //새천년관
    position: const NLatLng(37.488188312180334, 126.82539740407545),
  ),
  CampusMarker(
    idNumber: "3", //학관
    position: const NLatLng(37.48774629761304, 126.82504508594052),
  ),
  CampusMarker(
    idNumber: "4", //승연관
    position: const NLatLng(37.48744109239052, 126.82581467745024),
  ),
  CampusMarker(
    idNumber: "5", //미가엘+ 이천환
    position: const NLatLng(37.487239410430966, 126.8265246615199),
  ),
  CampusMarker(
    idNumber: "6", //도서관
    position: const NLatLng(37.48808089260987, 126.82587255444975),
  ),
  CampusMarker(
    idNumber: "7", //월당관
    position: const NLatLng(37.48719148022322, 126.82609793244394),
  ),
  CampusMarker(
    idNumber: "8", //일만관
    position: const NLatLng(37.487578953501995, 126.82612530194005),
  )
];

List<CampusMarker> nscMarkers = [
  CampusMarker(
    idNumber: "1",
    position: const NLatLng(37.587361, 126.994479),
  ),
];

List<NMarker> buildCampusMarkers(CampusType campusType) {
  return campusType.markername.map((campusmarker) {
    return NMarker(
      id: "line${campusmarker.idNumber}",
      position: campusmarker.position,
      size: const Size(25, 25),
      icon: icon,
      captionOffset: -22,
    );
  }).toList();
}
