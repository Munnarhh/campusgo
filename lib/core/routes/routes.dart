import 'package:campusgo/core/widgets/success_page.dart';
import 'package:campusgo/features/authentication/presentation/views/createpassword.dart';
import 'package:campusgo/features/authentication/presentation/views/forgot_password.dart';
import 'package:campusgo/features/authentication/presentation/views/otp_verification.dart';
import 'package:campusgo/features/menu/presentation/pages/promo.dart';
import 'package:campusgo/features/profile/presentation/pages/change_password.dart';
import 'package:campusgo/features/profile/presentation/pages/profile_page.dart';
import 'package:campusgo/features/ride/presentation/pages/calendar.dart';
import 'package:campusgo/features/ride/presentation/pages/my_ride.dart';
import 'package:campusgo/features/ride/presentation/pages/options_page.dart';
import 'package:campusgo/features/home/presentation/pages/home.dart';
import 'package:campusgo/features/authentication/presentation/views/login.dart';
import 'package:campusgo/features/authentication/presentation/views/loginpage.dart';
import 'package:campusgo/features/authentication/presentation/views/register.dart';
import 'package:campusgo/features/onboarding/presentation/views/onboarding.dart';
import 'package:campusgo/features/onboarding/presentation/views/splash_screen.dart';

import 'package:flutter/widgets.dart';

import '../../features/menu/presentation/pages/promo_page.dart';

Map<String, WidgetBuilder> routes = {
  //all screens here
  Home.routeName: (context) => const Home(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  OnboardingScreen.routeName: (context) => const OnboardingScreen(),
  LoginRegister.routeName: (context) => const LoginRegister(),
  RegistrationPage.routeName: (context) => const RegistrationPage(),
  LoginPage.routeName: (context) => const LoginPage(),
  CreatePassword.routeName: (context) => const CreatePassword(),
  OtpVerification.routeName: (context) => const OtpVerification(),
  SuccessPage.routeName: (context) => const SuccessPage(),
  ForgotPasswordPage.routeName: (context) => const ForgotPasswordPage(),
  OptionsPage.routeName: (context) => const OptionsPage(),
  ProfilePage.routeName: (context) => const ProfilePage(),
  ChangePasswordPage.routeName: (context) => const ChangePasswordPage(),
  SelectDatePage.routeName: (context) => const SelectDatePage(),
  PromoPage.routeName: (context) => const PromoPage(),
  PromoCodePage.routeName: (context) => const PromoCodePage(),
  MyRidesPage.routeName: (context) => const MyRidesPage(),
};
