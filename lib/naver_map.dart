import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class NaverMapApp extends StatelessWidget {
  const NaverMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: NaverMap(
            options: NaverMapViewOptions(
      initialCameraPosition: NCameraPosition(
        target: NLatLng(37.488017, 126.825183),
        zoom: 17,
        bearing: 0,
        tilt: 0,
      ),
      mapType: NMapType.basic,
      locationButtonEnable: true,
      consumeSymbolTapEvents: false,
    )));
  }
}
