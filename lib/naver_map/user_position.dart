import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  final NaverMapController mapController;
  NMarker? _currentLocationMarker;

  LocationService(this.mapController) {
    _initializeLocation();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _initializeLocation() async {
    try {
      Position position = await _determinePosition();

      _currentLocationMarker = NMarker(
        id: 'currentLocation',
        position: NLatLng(position.latitude, position.longitude),
        size: const NSize(36, 36),  // 마커 크기 설정
        icon: NOverlayImage.fromAssetImage('assets/images/current_location.png'),
      );

      mapController.moveCamera(
        NCameraUpdate.toLatLng(
          NLatLng(position.latitude, position.longitude),
          zoom: 17.8,
        ),
      );
      mapController.addOverlay(_currentLocationMarker!);

      // 위치 변화 감지 설정
      Geolocator.getPositionStream().listen((Position position) {
        if (_currentLocationMarker != null) {
          mapController.removeOverlay(_currentLocationMarker!);
        }
        _currentLocationMarker = NMarker(
          id: 'currentLocation',
          position: NLatLng(position.latitude, position.longitude),
          size: const NSize(36, 36),  // 마커 크기 설정
          icon: NOverlayImage.fromAssetImage('assets/images/current_location.png'),
        );
        mapController.addOverlay(_currentLocationMarker!);
      });
    } catch (e) {
      print('Error while getting location: $e');
    }
  }
}