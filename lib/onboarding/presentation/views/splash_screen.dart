import 'package:campusgo/constants/constants.dart';
import 'package:campusgo/home.dart';
import 'package:campusgo/onboarding/presentation/views/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter_svg/svg.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = 'SplashScreen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushNamedAndRemoveUntil(
          context, OnboardingScreen.routeName, (route) => false);
    });
    return Scaffold(
      backgroundColor: const Color(kPrimaryColor),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(kLogo),
          SizedBox(
            height: 110.h,
          ),
          Center(
            child: Text(
              'Easier Movement',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 90.h),
          const SpinKitFadingCube(
            color: Colors.white,
          )
        ],
      ),
    );
  }
}
