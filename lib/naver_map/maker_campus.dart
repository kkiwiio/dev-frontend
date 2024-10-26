import "dart:developer";
import "package:flutter_naver_map/flutter_naver_map.dart";
import "package:flutter/material.dart";
import "../naver_map/campusmarker_model.dart";
import "../naver_map/dialog_ui.dart";
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

const icon = NOverlayImage.fromAssetImage(
  'assets/images/mark.png',
);

List<CampusMarker> getAllMarkers(BuildContext context) {
  return [
    CampusMarker(
      idNumber: "1", //구두인관
      position: const NLatLng(37.48834872, 126.82502522),
      buildingName: AppLocalizations.of(context)!.building10,
      buildingDescription: AppLocalizations.of(context)!.description10,
      missionDescription: AppLocalizations.of(context)!.mission10,
      imagePath: 'assets/images/building_img/1.jpg',
      missionImage: 'assets/images/mission_img/구두인관미션.jpg',
      filterImg: 'assets/images/filter_img/구두인관필터.png',
    ),
    CampusMarker(
        idNumber: "2", //새천년관
        position: const NLatLng(37.48823757, 126.82539904),
        buildingName: AppLocalizations.of(context)!.building7,
        buildingDescription: AppLocalizations.of(context)!.description7,
        missionDescription: AppLocalizations.of(context)!.mission7,
        imagePath: 'assets/images/building_img/2.jpg',
        missionImage: 'assets/images/mission_img/새천년관미션.jpg',
        filterImg: 'assets/images/filter_img/새천년필터.png'),
    CampusMarker(
        idNumber: "3", //학관
        position: const NLatLng(37.4877332, 126.82487129),
        buildingName: AppLocalizations.of(context)!.building5,
        buildingDescription: AppLocalizations.of(context)!.description5,
        missionDescription: AppLocalizations.of(context)!.mission5,
        imagePath: 'assets/images/building_img/3.jpg',
        missionImage: 'assets/images/mission_img/학관미션.jpg',
        filterImg: 'assets/images/filter_img/학관필터.png'),
    CampusMarker(
        idNumber: "4", //승연관
        position: const NLatLng(37.48749122, 126.82580057),
        buildingName: AppLocalizations.of(context)!.building1,
        buildingDescription: AppLocalizations.of(context)!.description1,
        missionDescription: AppLocalizations.of(context)!.mission1,
        imagePath: 'assets/images/building_img/4.jpg',
        missionImage: 'assets/images/mission_img/승연관미션.jpg',
        filterImg: 'assets/images/filter_img/승연관필터.png'),
    CampusMarker(
      idNumber: "5", //미가엘+ 이천환
      position: const NLatLng(37.48725603, 126.8265476),
      buildingName: AppLocalizations.of(context)!.building6,
      buildingDescription: AppLocalizations.of(context)!.description6,
      missionDescription: AppLocalizations.of(context)!.mission6,
      imagePath: 'assets/images/building_img/5.jpg',
      missionImage: 'assets/images/mission_img/이천환미션.jpg',
      filterImg: 'assets/images/filter_img/이천환필터.png',
    ),
    CampusMarker(
        idNumber: "6", //도서관
        position: const NLatLng(37.48814075, 126.82585164),
        buildingName: AppLocalizations.of(context)!.building8,
        buildingDescription: AppLocalizations.of(context)!.description8,
        missionDescription: AppLocalizations.of(context)!.mission8,
        imagePath: 'assets/images/building_img/6.jpg',
        missionImage: 'assets/images/mission_img/중앙도서관미션.jpg',
        filterImg: 'assets/images/filter_img/중앙도서관필터.png'),
    CampusMarker(
        idNumber: "7", //월당관
        position: const NLatLng(37.48721646, 126.82607443),
        buildingName: AppLocalizations.of(context)!.building3,
        buildingDescription: AppLocalizations.of(context)!.description3,
        missionDescription: AppLocalizations.of(context)!.mission3,
        imagePath: 'assets/images/building_img/7.jpg',
        missionImage: 'assets/images/mission.jpg',
        filterImg: 'assets/images/filter_img/구두인관필터.png'),
    CampusMarker(
        idNumber: "8", //일만관
        position: const NLatLng(37.4875581, 126.82613706),
        buildingName: AppLocalizations.of(context)!.building2,
        buildingDescription: AppLocalizations.of(context)!.description2,
        missionDescription: AppLocalizations.of(context)!.mission2,
        imagePath: 'assets/images/building_img/8.jpg',
        missionImage: 'assets/images/mission_img/일만관미션.jpg',
        filterImg: 'assets/images/filter_img/일만관필터.png'),
  ];
}

Set<NMarker> buildCampusMarkers(BuildContext context) {
  final markers = getAllMarkers(context);
  return markers.map((campusmarker) {
    final marker = NMarker(
      id: "marker${campusmarker.idNumber}",
      position: campusmarker.position,
      size: const Size(35, 40),
      icon: icon,
    );

    marker.setOnTapListener((NMarker marker) {
      log("Marker ${campusmarker.buildingName} clicked");
      showMarkerDialog(context, campusmarker);
    });
    return marker;
  }).toSet();
}
