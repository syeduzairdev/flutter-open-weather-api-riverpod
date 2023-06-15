// ignore_for_file: prefer_const_constructors
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:location/location.dart';
import 'package:riverpod_crud/constants/constant.dart';
import 'package:riverpod_crud/repository/location_repository.dart';
import 'package:riverpod_crud/screen/weather/weather.dart';

class Splash extends ConsumerStatefulWidget {
  const Splash({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashState();
}

class _SplashState extends ConsumerState<Splash> {
  bool isLoading = true;

  @override
  void initState() {
    Future.delayed(Duration(seconds: 5)).then((value) {
      setState(() {
        isLoading = false;
      });
    });
    Future.delayed(Duration.zero).then((_) {
      navigateToNextScreen();
    });

    super.initState();
  }

  navigateToNextScreen() async {
    final lat = ref.watch(latProvider);
    final long = ref.watch(lonProvider);
    if (lat > 0.0 && long > 0.0) {
      print("Location Exists");
      nextScreen();
    } else {
      print("Location Not Exists");
      updateLocation();
    }
  }

  Future<LocationData?> updateLocation() async {
    Location location = Location();
    LocationData? currentLocation;
    PermissionStatus permissionGranted = await location.hasPermission();
    print(permissionGranted);
    if (permissionGranted == PermissionStatus.granted) {
      currentLocation = await location.getLocation();
      ref.read(latProvider.notifier).state = currentLocation.latitude!;
      ref.read(lonProvider.notifier).state = currentLocation.longitude!;
      nextScreen();
    }
    return currentLocation;
  }

  nextScreen() async {
    Future.delayed(Duration(seconds: 5)).then((value) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => WeatherScreen(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final latitude = ref.watch(latProvider);
    final longitude = ref.watch(lonProvider);
    print("latitude : $latitude :: longitude: $longitude");

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: 1.sh,
        width: 1.sw,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            // BG Image

            isLoading == true
                ? Column(
                    children: [
                      SizedBox(
                        height: 10.h,
                        width: 10.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      InitializationCompleted(
                          textOnCompleted: "Initializing Data ..."
                          // \n\nPlease wait while we are loading the data...",
                          ),
                    ],
                  )
                : ((latitude <= 0.0 && longitude <= 0.0) == false
                    ? Column(
                        children: [
                          SizedBox(height: 20.h),
                          InitializationCompleted(
                              textOnCompleted:
                                  "Your location lat long: $latitude, $longitude"
                              // \n\nPlease wait while we are loading the data...",
                              ),
                          // SizedBox(height: 10.h),
                          // CircularProgressIndicator(),
                        ],
                      )
                    : Column(
                        children: [
                          Text(
                            AppStartUpConstants.LOCATION_PERMISSION_MESSAGE,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          ElevatedButton(
                            onPressed: () {
                              _modalpopup();
                            },
                            style: TextButton.styleFrom(
                              minimumSize: Size(280.w, 49.h),
                              backgroundColor: Color(0xff007AFF),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.r)),
                            ),
                            child: Text(
                              AppStartUpConstants
                                  .LOCATION_PERMISSION_BUTTON_ALLOW,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.41.sp,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      )),
            Spacer(),
            Text(
              AppStartUpConstants.app_Version,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.24.sp,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 15.h),
          ],
        ),
      ),
    );
  }

  _modalpopup() {
    final navigatorContext = context;

    showDialog(
      context: navigatorContext,
      builder: (context) => AlertDialog(
        // backgroundColor: Colors.white,
        // backgroundColor: currentTheme.drawerTheme.backgroundColor,
        contentPadding: EdgeInsets.zero,
        title: Text(
          "Location Permission Required",
          style: TextStyle(
            fontSize: 21.5.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        actions: [
          Container(
            height: 43.h,
            decoration: BoxDecoration(
              color: Color(0xff007AFF),
              borderRadius: BorderRadius.circular(10.r),
            ),
            width: 140.w,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
                LocationRepository(ref: ref).getCurrentLocation().then((value) {
                  Timer(
                      Duration(seconds: 2),
                      () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => WeatherScreen(),
                            ),
                          ));
                });
              },
              child: Center(
                child: Text(
                  AppStartUpConstants.LOCATION_PERMISSION_BUTTON_ALLOW,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],

        content: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Text(
            AppStartUpConstants.LOCATION_PERMISSION_MESSAGE,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}

class InitializationCompleted extends StatelessWidget {
  const InitializationCompleted({Key? key, required this.textOnCompleted})
      : super(key: key);
  final String textOnCompleted;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        textOnCompleted,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 11.sp,
        ),
      ),
    );
  }
}
