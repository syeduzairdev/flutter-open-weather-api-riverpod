import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../controller/weather_forcast_controller.dart';

class WeatherForcastScreen extends ConsumerWidget {
  const WeatherForcastScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forecastDataValue = ref.watch(hourlyWeatherControllerProvider);
    return forecastDataValue.when(
      loading: () =>
          const Center(child: SizedBox(height: 20, child: Text('Loading...'))),
      data: (weatherForcastModel) => buildWeatherForcast(weatherForcastModel),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
    );
  }

  buildWeatherForcast(weatherForcastModel) {
    //convert timestap to time

    return SizedBox(
        height: 49.h,
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

            print(TimeStamp);
            print(DateTime.now());
            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                children: [
                  Text(formattedTime,
                      style: TextStyle(
                        fontSize: 12.sp,
                        // color: (DateTime.now() == TimeStamp)
                        //     ? Pallete.primaryColor
                        //     : Colors.black
                      )),
                  SizedBox(height: 6.h),
                  Text(degree + '°'),
                ],
              ),
            );
          },
        ));
  }
}
