import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../controller/weather_controller.dart';

class CurrentWeather extends ConsumerWidget {
  const CurrentWeather({super.key});

  /// add appropriete icon to page  according to response from API
  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentWeather = ref.watch(currentWeatherControllerProvider);
    return currentWeather.when(
     loading: () => const Center(
          child: SizedBox(height: 20,  child: Text('Loading...'))),
      data: (weatherModel) => buildCurrentWeather(weatherModel),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
    );
  }

  buildCurrentWeather(weatherModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('EEEE').format(DateTime.now()),
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
                Text(
                    getWeatherIcon(
                      weatherModel.weather![0].id!,
                    ),
                    style: const TextStyle(fontSize: 32)),

                // //import svg
                // SvgPicture.asset(
                //   "assets/images/svg/cloudy_1.svg",
                // ),
              ],
            ),
            SizedBox(
              height: 6.h,
            ),
            Text(
              "Hazy Sunshine",
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
                  //  color: Pallete.primaryColor,
                  size: 16.sp,
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
}
