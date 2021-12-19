import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 2000), () {
      Get.toNamed('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset('assets/images/logo.png'),
      splashTransition: SplashTransition.rotationTransition,
      backgroundColor: Get.theme.backgroundColor,
      curve: Curves.easeInOutQuart,
      nextScreen: SplashPage(),
      disableNavigation: true,
      animationDuration: Duration(milliseconds: 800),
      splashIconSize: Get.size.shortestSide / 4,
    );
  }
}
