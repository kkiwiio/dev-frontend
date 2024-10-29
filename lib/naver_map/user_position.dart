import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:location/location.dart';
import '../naver_map/campusmarker_model.dart';
import '../utils/distance_calc.dart';
import '../naver_map/maker_campus.dart';

class LocationService {
  final NaverMapController mapController;
  final BuildContext context;
  NMarker? _currentLocationMarker;
  Location location = Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  StreamSubscription<LocationData>? _locationSubscription;
  bool _isDisposed = false;

  List<CampusMarker> sortedBuildings = [];
  Function(List<CampusMarker>)? onBuildingsSorted;
  List<CampusMarker>? _markers;

  LocationService(this.mapController, this.context) {
    _markers = getAllMarkers(context);
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    if (_isDisposed) return;

    try {
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) return;
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) return;
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
    if (_isDisposed) return false;

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
    if (_isDisposed) return;

    _locationSubscription =
        location.onLocationChanged.listen((LocationData locationData) {
      if (!_isDisposed) {
        _updateUserLocation(locationData);
      }
    });
  }

  List<CampusMarker> sortBuildingsByDistance(
      LocationData userLocation, List<CampusMarker> buildings) {
    if (_isDisposed) return [];

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

  void _updateUserLocation(LocationData locationData) async {
    if (_isDisposed) return;

    try {
      if (_currentLocationMarker != null) {
        try {
          await mapController.deleteOverlay(_currentLocationMarker!.info);
        } catch (e) {
          print('Error deleting overlay: $e');
        }
      }

      if (_isDisposed) return;

      _currentLocationMarker = NMarker(
        id: 'currentLocation',
        icon: const NOverlayImage.fromAssetImage(
            'assets/images/current_location.png'),
        position: NLatLng(locationData.latitude!, locationData.longitude!),
      );

      try {
        if (!_isDisposed) {
          await mapController.addOverlay(_currentLocationMarker!);
        }
      } catch (e) {
        print('Error adding overlay: $e');
      }

      try {
        if (!_isDisposed) {
          final cameraUpdate = NCameraUpdate.scrollAndZoomTo(
            target: NLatLng(locationData.latitude!, locationData.longitude!),
            zoom: 17.8,
          );

          cameraUpdate.setAnimation(
            animation: NCameraAnimation.easing,
            duration: const Duration(milliseconds: 800),
          );

          await mapController.updateCamera(cameraUpdate);
        }
      } catch (e) {
        print('Error updating camera: $e');
      }

      if (_markers != null && !_isDisposed) {
        sortedBuildings = sortBuildingsByDistance(locationData, _markers!);
        if (onBuildingsSorted != null) {
          onBuildingsSorted!(sortedBuildings);
        }
      }
    } catch (e) {
      print('Error in _updateUserLocation: $e');
    }
  }

  Future<LocationData?> getCurrentLocation() async {
    if (_isDisposed) return null;

    try {
      return await location.getLocation();
    } catch (e) {
      debugPrint('Error getting current location: $e');
      return null;
    }
  }

  void dispose() {
    _isDisposed = true;
    _locationSubscription?.cancel();
    _currentLocationMarker = null;
    _markers = null;
    sortedBuildings.clear();
    onBuildingsSorted = null;
  }
}
