import 'package:campusgo/features/home/presentation/pages/home.dart';
import 'package:campusgo/features/onboarding/presentation/views/splash_screen.dart';
import 'package:campusgo/core/routes/routes.dart';
import 'package:campusgo/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      //splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter On boarding',
          theme: theme(context),
          //home: const Home(),
          initialRoute: SplashScreen.routeName,
          routes: routes,
        );
      },
    );
  }
}
