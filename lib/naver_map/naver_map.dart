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

class _NaverMapAppState extends State<NaverMapApp> {
  late NaverMapController _mapController;
  late LocationService locationService;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<CampusMarker> sortedBuildings = [];

  void updateSortedBuildings(List<CampusMarker> buildings) {
    setState(() {
      sortedBuildings = buildings;
    });
  }

  @override
  Widget build(BuildContext context) {
    const initCameraPosition = NCameraPosition(
      target: NLatLng(37.48798339648247, 126.82544028277228),
      zoom: 17.8,
    );

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
              Set<NMarker> markers = buildCampusMarkers(context);
              _mapController.addOverlayAll(markers);

              locationService = LocationService(_mapController, context);
              locationService.onBuildingsSorted = updateSortedBuildings;

              // setMarkerTapListeners(markers, context, locationService);
            },
          ),
          Positioned(
            bottom: 20,
            width: MediaQuery.of(context).size.width * 0.7,
            right: 20,
            child: NearbyBuildingsSlider(
              buildings: sortedBuildings,
              onBuildingTap: (building) {
                _mapController.updateCamera(
                  NCameraUpdate.withParams(
                    target: building.position,
                    zoom: 17.8,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
