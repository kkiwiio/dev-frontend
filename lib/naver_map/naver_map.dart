import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:project_heck/naver_map/maker_campus.dart';
import 'package:project_heck/naver_map/user_position.dart';
import 'package:project_heck/side_bar/side_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NaverMapApp extends StatefulWidget {
  const NaverMapApp({super.key});

  @override
  _NaverMapAppState createState() => _NaverMapAppState();
}

class _NaverMapAppState extends State<NaverMapApp> {
  late NaverMapController _mapController;
  late LocationService _locationService;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Future<int> loadRewardPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('rewardPoints') ?? 0;
  }
  Future<void> openSidebar() async {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    const initCameraPosition = NCameraPosition(
      target: NLatLng(37.48798339648247, 126.82544028277228),
      zoom: 17.8,
    );

    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          NaverMap(
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
          Positioned(
              top: 50,
              left: 0,
              right: 350,
              child: Center(
                child: Builder(
                    builder: (context) {
                      return GestureDetector(
                        onTap: openSidebar,
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/transform.png',
                              width: 65,
                              height: 65,
                            ),
                            const SizedBox(height: 5),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'AI 변환',
                                style: TextStyle(
                                  fontFamily: 'GmarketSansTTFMedium',
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }
                ),
              )
          )
        ],
      ),
      drawer: FutureBuilder<int>(
        future: loadRewardPoints(),
        builder: (context, snapshot) {
          final rewardPoints = snapshot.data ?? 0;
          return Sidebar(rewardPoints: rewardPoints);
        },
        ),
    );
  }
}