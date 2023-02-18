import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:riverpod_crud/repository/location_repository.dart';
import 'package:riverpod_crud/repository/weather_repository.dart';

import '../model/weather_forcast.dart';

// final weatherForcastProvider =
//     FutureProvider.family<WeatherForcast, double>((ref, lat) async {
//   final weatherForcast =
//       await ref.read(weatherRepositoryProvider).getForcastWheather(lat, -127.0);
//   return weatherForcast;
// });

class WeatherForcastController
    extends StateNotifier<AsyncValue<WeatherForcast>> {
  WeatherForcastController(this._weatherRepository,
      {required this.lat, required this.lon})
      : super(const AsyncValue.loading()) {
    getWeather(
      lat: lat,
      lon: lon,
    );
  }
  final WeatherRepository _weatherRepository;
  final double lat;
  final double lon;

  Future<void> getWeather({required double lat, required double lon}) async {
 
    try {
      state = const AsyncValue.loading();

      final forecast = await _weatherRepository.getForcastWheather(lat, lon);
      state = AsyncValue.data(forecast);
    } on Exception catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final hourlyWeatherControllerProvider = StateNotifierProvider.autoDispose<
    WeatherForcastController, AsyncValue<WeatherForcast>>((ref) {
  final weatherRepository = ref.watch(weatherRepositoryProvider);
final lat = ref.watch(latProvider);
final long = ref.watch(lonProvider);
  return WeatherForcastController(weatherRepository, lat: lat, lon: long);
});
