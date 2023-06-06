import 'package:campusgo/home.dart';
import 'package:campusgo/login/presentation/views/login.dart';
import 'package:campusgo/onboarding/presentation/views/onboarding.dart';
import 'package:campusgo/onboarding/presentation/views/splash_screen.dart';

import 'package:flutter/widgets.dart';

Map<String, WidgetBuilder> routes = {
  //all screens here
  Home.routeName: (context) => const Home(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  OnboardingScreen.routeName: (context) => const OnboardingScreen(),
  LoginRegister.routeName: (context) => const LoginRegister(),
};
