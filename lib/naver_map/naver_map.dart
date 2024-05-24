import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:project_heck/naver_map/campus_type.dart';
import 'package:project_heck/naver_map/maker_campus.dart';

class NaverMapApp extends StatelessWidget {
  const NaverMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    const initCameraPosition = NCameraPosition(
      target: NLatLng(37.48798339648247, 126.82544028277228),
      zoom: 15.8,
      bearing: 330,
      tilt: 50,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Naver Map')),
      body: NaverMap(
        options: const NaverMapViewOptions(
          zoomGesturesEnable: true,
          locationButtonEnable: false,
          mapType: NMapType.basic,
          logoAlign: NLogoAlign.rightBottom,
          logoClickEnable: true,
          logoMargin: EdgeInsets.all(1000),
          activeLayerGroups: [NLayerGroup.building, NLayerGroup.transit],
          initialCameraPosition: initCameraPosition,
        ),
        onMapReady: (mapcontroller) {
          mapcontroller.addOverlayAll({...buildCampusMarkers(CampusType.hssc)});
        },
      ),
    );
  }
}


// const initCameraPosition = NCameraPosition(
//   target: NLatLng(37.5666102, 126.9783881),
//   zoom: 15.8,
//   bearing: 330,
//   tilt: 50,
// );
// NaverMap buildMap() {
//   return NaverMap(

//     options: const NaverMapViewOptions(
//       zoomGesturesEnable: true,
//       locationButtonEnable: false,
//       mapType: NMapType.basic,
//       logoAlign: NLogoAlign.rightBottom,
//       logoClickEnable: true,
//       logoMargin: EdgeInsets.all(1000),
//       activeLayerGroups: [NLayerGroup.building, NLayerGroup.transit],
//       initialCameraPosition: initCameraPosition,
//     ),
//     onMapReady: (mapcontroller) {
//       mapcontroller.addOverlayAll({...buildCampusMarkers(CampusType.hssc)});
//     },
//   );
// }
