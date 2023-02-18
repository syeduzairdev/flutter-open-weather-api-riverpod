import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../constants/constant.dart';
import '../model/weather_forcast.dart';
import '../model/weather_model.dart';

//WeatherRepository class, we define a getWeather method that sends an HTTP GET request to the weather API and returns the response data as a WeatherModel.
class WeatherRepository {
  _get(String endPoint) {
    String url = Weather_Api_Base_Url + endPoint;
    Uri uri = Uri.parse(url);
    return http.get(uri);
  }

//get current weather data from api
  Future<WeatherModel> getWeather(double lat, double long) async {
    http.Response response = await _get(
        "/weather?lat=$lat&lon=$long&appid=fa99c95462258c72b24c44d04ed72018&units=metric");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      WeatherModel weatherModel = WeatherModel.fromJson(data);
      return weatherModel;
    } else {
      throw Exception('Failed to load weather');
    }
  }

//get weather forecast data from api
  Future<WeatherForcast> getForcastWheather(double lat, double long) async {
    http.Response response = await _get(
        "/forecast?lat=$lat&lon=$long&appid=fa99c95462258c72b24c44d04ed72018&units=metric");
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      WeatherForcast weatherForcastModel = WeatherForcast.fromJson(data);
      return weatherForcastModel;
    } else {
      throw Exception('Failed to load weather forcast');
    }
  }
}

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepository();
});
