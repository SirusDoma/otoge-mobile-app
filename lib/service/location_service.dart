import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationService {
  LocationService();

  final GeolocatorPlatform _geolocator = GeolocatorPlatform.instance;

  Future<LatLng> getCurrentLocation() async {
    final coordinate = await _geolocator.getCurrentPosition();
    return LatLng(coordinate.latitude, coordinate.longitude);
  }

  Future<bool> hasPermission() async {
    var permission = await _geolocator.checkPermission();
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  Future<bool> requestPermission() async {
    if (await hasPermission()) {
      return true;
    }

    var permission = await _geolocator.requestPermission();
    return permission != LocationPermission.denied && permission != LocationPermission.deniedForever;
  }

  Future<bool> isEnabled() async {
    return _geolocator.isLocationServiceEnabled();
  }

  Future openLocationSettings() async {
    await _geolocator.openLocationSettings();
  }

  Future openAppSettings() async {
    await _geolocator.openAppSettings();
  }

}