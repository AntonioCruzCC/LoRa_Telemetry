import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationHandler {
  static final LocationHandler _locationSingleton = LocationHandler._internal();

  Location location = Location();
  bool? serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;

  factory LocationHandler() {
    return _locationSingleton;
  }

  LocationHandler._internal() {
    initGeolocation();
  }

  Future<void> initGeolocation() async {
    serviceEnabled = await location.serviceEnabled();

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    await refreshLocation();
  }

  refreshLocation() async {
    _locationData = await location.getLocation();
  }

  Future<LatLng> getCurrentLocation() async {
    return Future(() async {
      while (hasNoLocationAndPermissionGranted()) {
        serviceEnabled = await location.serviceEnabled();
        (serviceEnabled ?? false) && await refreshLocation();
        await Future.delayed(const Duration(milliseconds: 100));
      }
      return LatLng(_locationData?.latitude ?? 37.42796133580664,
          _locationData?.longitude ?? -122.085749655962);
    });
  }

  bool hasNoLocationAndPermissionGranted() {
    return _locationData == null &&
        ([PermissionStatus.granted, PermissionStatus.grantedLimited]
            .contains(_permissionGranted ?? PermissionStatus.granted));
  }
}
