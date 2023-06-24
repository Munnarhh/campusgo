import 'package:bot_toast/bot_toast.dart';
import 'package:campusgo/core/info_handler/app_info.dart';
import 'package:campusgo/features/onboarding/presentation/views/splash_screen.dart';
import 'package:campusgo/core/routes/routes.dart';
import 'package:campusgo/core/theme/theme.dart';
import 'package:campusgo/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppInfo(),
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        //splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter On boarding',
            theme: theme(context),
            builder: BotToastInit(),
            navigatorObservers: [BotToastNavigatorObserver()],
            //home: const Home(),
            initialRoute: SplashScreen.routeName,
            routes: routes,
          );
        },
      ),
    );
  }
}
