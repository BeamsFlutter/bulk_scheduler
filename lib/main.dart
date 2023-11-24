import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:get/get.dart';
import 'package:scheduler/languages/locale_string.dart';
import 'package:scheduler/view/pages/login/login.dart';
import 'package:scheduler/view/pages/splashscreen/splashscreen.dart';
import 'package:scheduler/view/pages/splashscreen/splashscreen_driver.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var appMode =  "A"; //A --ADMIN U --USER
    return GetMaterialApp(
      title: 'Bits Scheduler',
      locale: const Locale('gu', 'IN'),
      translations: LocaleString(),
      fallbackLocale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      home: appMode == "U"? const SplashScreenUser() : const SplashScreen(),
    );
  }
}
class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    // etc.
  };
}