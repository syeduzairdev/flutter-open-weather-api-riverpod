import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

final latProvider = StateProvider<double>((ref) {
  return 0.0;
});
final lonProvider = StateProvider<double>((ref) {
  return 0.0;
});

class LocationRepository {
  final Ref ref;
  LocationRepository({required this.ref});

  Future<LocationData> getCurrentLocation() async {
    Location location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {}
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return Future.microtask(() => throw PlatformException(
            code: 'PERMISSION_DENIED',
            message: 'Location permissions are denied',
            details: null));
      }
    }

    LocationData currentLocation = await location.getLocation();
    ref.read(latProvider.state).state = currentLocation.latitude!;
    ref.read(lonProvider.state).state = currentLocation.longitude!;
    return currentLocation;
  }
}
