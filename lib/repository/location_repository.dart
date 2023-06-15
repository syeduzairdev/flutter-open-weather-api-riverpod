import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

final latProvider = StateProvider<double>((ref) {
  return 0.0;
});

final lonProvider = StateProvider<double>((ref) {
  return 0.0;
});

class LocationRepository {
  WidgetRef ref;
  LocationRepository({required this.ref});

  Future<bool> checkLocationServiceEnabled() async {
    Location location = Location();
    bool serviceEnabled;
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
    }
    return serviceEnabled;
  }

  Future<PermissionStatus> getLocationPermission() async {
    Location location = Location();
    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }
    return permissionGranted;
  }

  Future<LocationData> getCurrentLocation() async {
    LocationData currentLocation;
    bool serviceEnabled = await checkLocationServiceEnabled();
    if (serviceEnabled) {
      PermissionStatus permissionGranted = await getLocationPermission();
      if (permissionGranted == PermissionStatus.granted) {
        Location location = Location();
        currentLocation = await location.getLocation();
        ref.read(latProvider.notifier).state = currentLocation.latitude!;
        ref.read(lonProvider.notifier).state = currentLocation.longitude!;
      } else {
        throw Exception('Location permissions are denied');
      }
    } else {
      throw Exception('Location services are disabled');
    }
    return currentLocation;
  }

  Future<void> updateLocation() async {
    try {
      await getCurrentLocation();
    } catch (e) {
      // Handle error
    }
  }
}
