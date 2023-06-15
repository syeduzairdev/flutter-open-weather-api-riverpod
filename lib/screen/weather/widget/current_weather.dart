import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_crud/controller/weather_controller.dart';

class CurrentWeather extends ConsumerWidget {
  const CurrentWeather({super.key});

  /// add appropriete icon to page  according to response from API
  getWeatherIcon(String condition) {
    if (condition == "Clouds") {
      return _buildWeatherImage("assets/images/png/cloud.png");
    } else if (condition == "Rain") {
      return _buildWeatherImage("assets/images/png/cloud_drizzle.png");
    } else if (condition == "Snow") {
      return _buildWeatherImage("assets/images/png/snow.png");
    } else if (condition == "Clear") {
      return _buildWeatherImage("assets/images/png/cloud_sunny.png");
    } else if (condition == "Thunderstorm") {
      return _buildWeatherImage("assets/images/png/flash.png");
    } else if (condition == "Drizzle") {
      return _buildWeatherImage("assets/images/png/cloud_lightning.png");
    } else if (condition == "Haze") {
      return _buildWeatherImage("assets/images/png/cloud_cross.png");
    } else {
      return _buildWeatherImage("assets/images/png/neuro_logo.png");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(currentWeatherControllerProvider);
    return currentWeather.when(
      loading: () =>
          const Center(child: SizedBox(height: 20, child: Text('Loading...'))),
      data: (weatherModel) => buildCurrentWeather(weatherModel, ref),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
    );
  }

  buildCurrentWeather(weatherModel, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today, ${DateFormat('EEEE').format(DateTime.now())}',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 6.h,
            ),
            Row(
              children: [
                Text(
                  '${weatherModel.main!.temp!.toInt()}°',
                  style: TextStyle(
                    fontSize: 33.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  width: 6.w,
                ),
                getWeatherIcon(
                  weatherModel.weather![0].main!,
                )
              ],
            ),
            SizedBox(
              height: 6.h,
            ),
            Text(
              '${weatherModel.weather![0].main}',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.black,
                  size: 16.sp,
                ),
                SizedBox(
                  width: 6.w,
                ),
                Text(
                  '${weatherModel.name}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 6.h,
            ),
            Text(
              "${weatherModel.wind!.speed} km/h",
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 6.h,
            ),
            Text(
              "${weatherModel.main!.humidity} %",
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buildWeatherImage(String image) {
    return Image(
      image: AssetImage(image),
      fit: BoxFit.cover,
      height: 30.h,
      width: 30.w,
    );
  }
}
