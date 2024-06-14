import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:project_heck/naver_map/maker_campus.dart';
import 'package:project_heck/naver_map/user_position.dart'; // 위치 서비스 임포트

class NaverMapApp extends StatefulWidget {
  const NaverMapApp({super.key});

  @override
  _NaverMapAppState createState() => _NaverMapAppState();
}

class _NaverMapAppState extends State<NaverMapApp> {
  late NaverMapController _mapController;
  late LocationService _locationService;

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
          locationButtonEnable: true,
          mapType: NMapType.basic,
          logoAlign: NLogoAlign.rightBottom,
          logoClickEnable: true,
          logoMargin: EdgeInsets.all(1000),
          activeLayerGroups: [NLayerGroup.building, NLayerGroup.transit],
          initialCameraPosition: initCameraPosition,
        ),
        onMapReady: (mapController) {
          _mapController = mapController;
          _mapController.addOverlayAll(buildCampusMarkers(context));

          // 위치 서비스 초기화
          _locationService = LocationService(_mapController);
        },
      ),
    );
  }
}