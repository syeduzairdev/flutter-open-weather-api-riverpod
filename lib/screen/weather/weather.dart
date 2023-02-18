import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location/location.dart';

import '../../repository/location_repository.dart';
import '../current_weather.dart';
import '../weather_forcast_screen.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
      ),
      body: Column(
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          SizedBox(height: 10.h),
          Container(
            margin: EdgeInsets.only(top: 20.h),
            padding: EdgeInsets.all(20.h),
            decoration: BoxDecoration(
              //color: currentTheme.dividerTheme.color!,

              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Column(
              children: [
                // Text('Location: ${latitude} ${longitude}'),
                //weather container
                const CurrentWeather(),
                SizedBox(height: 10.h),
                const WeatherForcastScreen(),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
