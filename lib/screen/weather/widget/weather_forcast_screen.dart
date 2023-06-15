import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../../controller/weather_forcast_controller.dart';

class WeatherForcastScreen extends ConsumerWidget {
  const WeatherForcastScreen({super.key});
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
      return _buildWeatherImage("assets/images/png/cloud_cross.png");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecastDataValue = ref.watch(hourlyWeatherControllerProvider);
    return forecastDataValue.when(
      loading: () =>
          const Center(child: SizedBox(height: 20, child: Text('Loading...'))),
      data: (weatherForcastModel) =>
          buildWeatherForcast(weatherForcastModel, ref),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
    );
  }

  buildWeatherForcast(weatherForcastModel, WidgetRef ref) {
    //convert timestap to time

    return SizedBox(
        height: 80.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: (DateTime.now().hour == 23) ? 8 : 9,
          itemBuilder: (context, index) {
            // ignore: non_constant_identifier_names
            DateTime TimeStamp = DateTime.parse(
                weatherForcastModel!.list![index].dtTxt!.toString());
            String formattedTime = DateFormat('hh:mm a').format(TimeStamp);
            String degree = weatherForcastModel!.list![index].main!.temp!
                .toInt()
                .toString();

            return Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Column(
                children: [
                  Text(formattedTime,
                      style: TextStyle(
                        fontSize: 13.sp,
                      )),
                  SizedBox(height: 6.h),
                  getWeatherIcon(
                      weatherForcastModel.list![index].weather![0].main!),
                  SizedBox(height: 6.h),
                  Text('$degree°'),
                ],
              ),
            );
          },
        ));
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
