import 'dart:async';

import 'package:campusgo/core/constants/constants.dart';
import 'package:campusgo/features/authentication/presentation/views/login.dart';
import 'package:campusgo/features/authentication/presentation/views/loginpage.dart';
import 'package:campusgo/core/assistant/assistant.dart';
import 'package:campusgo/features/home/presentation/pages/home2.dart';
import 'package:campusgo/features/onboarding/presentation/views/onboarding.dart';
import 'package:campusgo/global/global.dart';
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
  startTimer() {
    Timer(const Duration(seconds: 3), () async {
      if (await firebaseAuth.currentUser != null) {
        firebaseAuth.currentUser != null
            ? AssistantMethods.readCurrentOnlineUserInfo()
            : null;
        if (!mounted) return;
        Navigator.pushNamed(context, Homee.routeName);
      } else {
        if (!mounted) return;
        Navigator.pushNamed(context, LoginRegister.routeName);
      }
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(const Duration(seconds: 5), () {
    //   Navigator.pushNamedAndRemoveUntil(
    //       context, OnboardingScreen.routeName, (route) => false);
    // });
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
