import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:project_heck/naver_map/maker_campus.dart';
import 'package:project_heck/naver_map/user_position.dart';
import 'package:project_heck/naver_map/campusmarker_model.dart';
import 'package:project_heck/widgets/slider_widget.dart';
import '../widgets/side_drawer.dart';

class NaverMapApp extends StatefulWidget {
  const NaverMapApp({super.key});

  @override
  _NaverMapAppState createState() => _NaverMapAppState();
}

class _NaverMapAppState extends State<NaverMapApp> with WidgetsBindingObserver {
  NaverMapController? _mapController;
  late LocationService locationService;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<CampusMarker> sortedBuildings = [];
  bool _isMapReady = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _isDisposed = true;
    WidgetsBinding.instance.removeObserver(this);
    locationService.dispose();
    _mapController = null;
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _reloadMap();
    }
  }

  void updateSortedBuildings(List<CampusMarker> buildings) {
    if (mounted && !_isDisposed) {
      setState(() {
        sortedBuildings = buildings;
      });
    }
  }

  Future<void> _reloadMap() async {
    if (_mapController != null && _isMapReady && !_isDisposed) {
      try {
        final markers = buildCampusMarkers(context);
        for (final marker in markers) {
          await _mapController?.addOverlay(marker);
        }
      } catch (e) {
        print('Error reloading map: $e');
      }
    }
  }

  Future<void> _initializeMap(NaverMapController controller) async {
    if (_isDisposed) return;

    setState(() {
      _mapController = controller;
      _isMapReady = true;
    });

    // 지도가 완전히 로드될 때까지 대기
    await Future.delayed(const Duration(seconds: 1));

    if (_isDisposed) return;

    try {
      // 마커 추가
      final markers = buildCampusMarkers(context);
      for (final marker in markers) {
        if (_isDisposed) return;
        try {
          await controller.addOverlay(marker);
          await Future.delayed(const Duration(milliseconds: 50));
        } catch (e) {
          print('Error adding marker: $e');
        }
      }

      if (!_isDisposed && mounted) {
        locationService = LocationService(controller, context);
        locationService.onBuildingsSorted = updateSortedBuildings;
      }
    } catch (e) {
      print('Error in map initialization: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Color(0xFF333333),
          ),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: const CustomDrawer(),
      body: WillPopScope(
        onWillPop: () async {
          _isDisposed = true;
          return true;
        },
        child: Stack(
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
                initialCameraPosition: NCameraPosition(
                  target: NLatLng(37.48798339648247, 126.82544028277228),
                  zoom: 17.8,
                ),
              ),
              onMapReady: _initializeMap,
            ),
            if (_isMapReady && sortedBuildings.isNotEmpty)
              Positioned(
                bottom: 20,
                width: MediaQuery.of(context).size.width * 0.7,
                right: 20,
                child: NearbyBuildingsSlider(
                  buildings: sortedBuildings,
                  onBuildingTap: (building) {
                    if (_mapController != null && !_isDisposed) {
                      _updateCamera(building.position);
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateCamera(NLatLng target) async {
    if (_mapController != null && _isMapReady && !_isDisposed) {
      try {
        final cameraUpdate = NCameraUpdate.scrollAndZoomTo(
          target: target,
          zoom: 17.8,
        );
        cameraUpdate.setAnimation(
          animation: NCameraAnimation.easing,
          duration: const Duration(milliseconds: 800),
        );
        await _mapController!.updateCamera(cameraUpdate);
      } catch (e) {
        print('Error updating camera: $e');
      }
    }
  }
}
