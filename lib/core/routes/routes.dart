import 'package:campusgo/core/widgets/success_page.dart';
import 'package:campusgo/features/login/presentation/views/createpassword.dart';
import 'package:campusgo/features/login/presentation/views/forgot_password.dart';
import 'package:campusgo/features/login/presentation/views/otp_verification.dart';
import 'package:campusgo/home.dart';
import 'package:campusgo/features/login/presentation/views/login.dart';
import 'package:campusgo/features/login/presentation/views/loginpage.dart';
import 'package:campusgo/features/login/presentation/views/register.dart';
import 'package:campusgo/features/onboarding/presentation/views/onboarding.dart';
import 'package:campusgo/features/onboarding/presentation/views/splash_screen.dart';

import 'package:flutter/widgets.dart';

Map<String, WidgetBuilder> routes = {
  //all screens here
  Home.routeName: (context) => const Home(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  OnboardingScreen.routeName: (context) => const OnboardingScreen(),
  LoginRegister.routeName: (context) => const LoginRegister(),
  RegistrationPage.routename: (context) => const RegistrationPage(),
  LoginPage.routename: (context) => const LoginPage(),
  CreatePassword.routename: (context) => const CreatePassword(),
  OtpVerification.routeName: (context) => const OtpVerification(),
  SuccessPage.routeName: (context) => const SuccessPage(),
  ForgotPasswordPage.routeName: (context) => const ForgotPasswordPage(),
};
