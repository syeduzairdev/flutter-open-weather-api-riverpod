// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:location/location.dart';

// import '../repository/location_repository.dart';

// class LocationController extends StateNotifier<AsyncValue<LocationData>> {
//   final Ref ref;

//   LocationController(this.ref) : super(const AsyncValue.loading()) {
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     try {
//       final location =
//           await ref.read(locationControllerProvider).getCurrentLocation();
//       state = AsyncValue.data(location);
//     } catch (error) {
//       state = AsyncValue.error(error, StackTrace.current);
//     }
//   }
// }
