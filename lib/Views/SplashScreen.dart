import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Views/MainNavigationPage.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () {
      Get.off(() => MainNavigationPage());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Stack(
          children: [
            Image.asset(
              'images/$splashLogo',
              width: Get.width,
              height: Get.height,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(child: CupertinoActivityIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
