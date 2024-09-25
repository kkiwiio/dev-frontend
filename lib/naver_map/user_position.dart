import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:location/location.dart';
import '../naver_map/campusmarker_model.dart';
import '../utils/distance_calc.dart';
import '../naver_map/maker_campus.dart'; // allMarkers를 가져오기 위해 추가

class LocationService {
  final NaverMapController mapController;
  NMarker? _currentLocationMarker;
  Location location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  StreamSubscription<LocationData>? _locationSubscription;

  List<CampusMarker> sortedBuildings = [];
  Function(List<CampusMarker>)? onBuildingsSorted;

  LocationService(this.mapController) {
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      await location.changeSettings(
        accuracy: LocationAccuracy.high,
        interval: 10000, // 10초마다 업데이트
      );

      await _startLocationUpdates();
    } catch (e) {
      debugPrint('Error while initializing location: $e');
    }
  }

  Future<bool> isBuildingInRange(
      CampusMarker building, double maxDistance) async {
    LocationData? userLocation = await getCurrentLocation();
    if (userLocation == null) return false;

    double distance = calculateDistance(
        userLocation.latitude!,
        userLocation.longitude!,
        building.position.latitude,
        building.position.longitude);

    return distance <= maxDistance;
  }

  Future<void> _startLocationUpdates() async {
    _locationSubscription =
        location.onLocationChanged.listen((LocationData locationData) {
      _updateUserLocation(locationData);
    });
  }

  List<CampusMarker> sortBuildingsByDistance(
      LocationData userLocation, List<CampusMarker> buildings) {
    for (var building in buildings) {
      building.distance = calculateDistance(
          userLocation.latitude!,
          userLocation.longitude!,
          building.position.latitude,
          building.position.longitude);
    }

    buildings.sort((a, b) => a.distance.compareTo(b.distance));
    return buildings;
  }

  void _updateUserLocation(LocationData locationData) {
    if (_currentLocationMarker != null) {
      mapController.deleteOverlay(_currentLocationMarker!.info);
    }

    _currentLocationMarker = NMarker(
      id: 'currentLocation',
      icon: const NOverlayImage.fromAssetImage(
          'assets/images/current_location.png'),
      position: NLatLng(locationData.latitude!, locationData.longitude!),
    );

    mapController.addOverlay(_currentLocationMarker!);
    mapController.updateCamera(
      NCameraUpdate.withParams(
        target: NLatLng(locationData.latitude!, locationData.longitude!),
        zoom: 17.8,
      ),
    );

    // 건물 정렬 및 UI 업데이트
    sortedBuildings = sortBuildingsByDistance(locationData, allMarkers);
    if (onBuildingsSorted != null) {
      onBuildingsSorted!(sortedBuildings);
    }
  }

  Future<LocationData?> getCurrentLocation() async {
    try {
      return await location.getLocation();
    } catch (e) {
      debugPrint('Error getting current location: $e');
      return null;
    }
  }

  void dispose() {
    _locationSubscription?.cancel();
  }
}
