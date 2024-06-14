import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:project_heck/naver_map/maker_campus.dart';

class NaverMapApp extends StatelessWidget {
  const NaverMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    const initCameraPosition = NCameraPosition(
      target: NLatLng(37.48798339648247, 126.82544028277228),
      zoom: 17.8,
    );

    return Scaffold(
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
        onMapReady: (mapController) {
          mapController.addOverlayAll(buildCampusMarkers(context));
        },
      ),
    );
  }
}
