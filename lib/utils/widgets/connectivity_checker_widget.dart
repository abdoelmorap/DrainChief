import 'dart:io';

import 'package:connection_notifier/connection_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lms_flutter_app/Config/app_config.dart';

class ConnectionCheckerWidget extends StatelessWidget {
  final Widget child;
  ConnectionCheckerWidget({required this.child});

  @override
  Widget build(BuildContext context) {
    return kDebugMode && Platform.isIOS
        ? child
        : ConnectionNotifierToggler(
            onConnectionStatusChanged: (connected) {
              /// that means it is still in the initialization phase.
              if (connected == null) return;
            },
            connected: child,
            disconnected: Scaffold(
              body: Center(
                key: UniqueKey(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/$appLogo',
                      width: Get.width * 0.3,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        "${stctrl.lang["Please check your Internet Connection"]}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
