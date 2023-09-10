// Dart imports:
import 'dart:developer';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:lms_flutter_app/Controller/lesson_controller.dart';
import 'package:lms_flutter_app/Model/Course/Lesson.dart';
import 'package:lms_flutter_app/utils/widgets/connectivity_checker_widget.dart';

import 'package:vdocipher_flutter/vdocipher_flutter.dart';

class VdoCipherPage extends StatefulWidget {
  final EmbedInfo? embedInfo;
  final Lesson? lesson;

  VdoCipherPage({this.embedInfo, this.lesson});

  @override
  _VdoCipherPageState createState() => _VdoCipherPageState();
}

class _VdoCipherPageState extends State<VdoCipherPage> {
  final LessonController lessonController = Get.put(LessonController());
  VdoPlayerController? vdoPlayerController;
  final double aspectRatio = 16 / 9;
  ValueNotifier<bool> _isFullScreen = ValueNotifier(false);

  String nativeAndroidLibraryVersion = 'Unknown';
  final urlController = TextEditingController();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft
    ]);

    // getOtpAndPlayBackInfo();

    log(widget.embedInfo.toString());

    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConnectionCheckerWidget(
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: VdoPlayer(
                          embedInfo: widget.embedInfo!,
                          onPlayerCreated: (controller) =>
                              _onPlayerCreated(controller),
                          onError: _onVdoError,
                          onFullscreenChange: _onFullscreenChange,
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: _isFullScreen,
                        builder: (context, value, child) {
                          return value != null
                              ? SizedBox.shrink()
                              : _nonFullScreenContent();
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 30,
                  left: 5,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        SystemChrome.setPreferredOrientations(
                            [DeviceOrientation.portraitUp]);
                      });
                      Get.back();
                    },
                    icon: Icon(Icons.cancel, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onVdoError(VdoError vdoError) {
    print("Oops, the system encountered a problem: " + vdoError.message);
  }

  _onEventChange(VdoPlayerController controller) {
    controller.addListener(() async {
      VdoPlayerValue value = controller.value;
      if (value.isEnded) {
        if (widget.lesson != null) {
          await lessonController
              .updateLessonProgress(widget.lesson?.id, widget.lesson?.courseId, 1)
              .then((value) {
            Get.back();
          });
        }
      }
    });
  }

  _onPlayerCreated(VdoPlayerController controller) {
    setState(() {
      vdoPlayerController = controller;
      _onEventChange(vdoPlayerController!);
    });
  }

  _onFullscreenChange(isFullscreen) {
    setState(() {
      _isFullScreen.value = isFullscreen;
    });
  }

  _nonFullScreenContent() {
    return Container();
  }

  // double _getHeightForWidth(double width) {
  //   return width / aspectRatio;
  // }
}
