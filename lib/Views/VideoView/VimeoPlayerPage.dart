// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:lms_flutter_app/Controller/lesson_controller.dart';
import 'package:lms_flutter_app/Model/Course/Lesson.dart';
import 'package:lms_flutter_app/utils/widgets/connectivity_checker_widget.dart';
import 'package:url_launcher/url_launcher.dart';

// Project imports:

class VimeoPlayerPage extends StatefulWidget {
  final String? videoId;
  final String? videoTitle;
  final Lesson? lesson;

  VimeoPlayerPage({this.videoId, this.videoTitle, this.lesson});

  @override
  _VimeoPlayerPageState createState() => new _VimeoPlayerPageState();
}

class _VimeoPlayerPageState extends State<VimeoPlayerPage> {
  final LessonController lessonController = Get.put(LessonController());

  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  PullToRefreshController? pullToRefreshController;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft
    ]);

    url = widget.videoId ?? '';

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  void reload() {
    webViewController?.reload();
  }

  @override
  Widget build(BuildContext context) {
    return ConnectionCheckerWidget(
      child: SafeArea(
        child: OrientationBuilder(builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return WillPopScope(
              onWillPop: () async => true,
              child: Scaffold(
                backgroundColor: Colors.black,
                body: Stack(
                  children: [
                    Positioned.fill(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Stack(
                              children: [
                                InAppWebView(
                                  key: webViewKey,
                                  initialUrlRequest:
                                      URLRequest(url: Uri.parse(url)),
                                  initialOptions: options,
                                  pullToRefreshController:
                                      pullToRefreshController,
                                  onWebViewCreated: (controller) {
                                    webViewController = controller;
                                  },
                                  onLoadStart: (controller, url) {
                                    setState(() {
                                      this.url = url.toString();
                                      urlController.text = this.url;
                                    });
                                  },
                                  androidOnPermissionRequest:
                                      (controller, origin, resources) async {
                                    return PermissionRequestResponse(
                                        resources: resources,
                                        action: PermissionRequestResponseAction
                                            .GRANT);
                                  },
                                  shouldOverrideUrlLoading:
                                      (controller, navigationAction) async {
                                    var uri = navigationAction.request.url;
    
                                    if (![
                                      "http",
                                      "https",
                                      "file",
                                      "chrome",
                                      "data",
                                      "javascript",
                                      "about"
                                    ].contains(uri?.scheme)) {
                                      // ignore: deprecated_member_use
                                      if (await canLaunch(url)) {
                                        // Launch the App
                                        // ignore: deprecated_member_use
                                        await launch(
                                          url,
                                        );
                                        // and cancel the request
                                        return NavigationActionPolicy.CANCEL;
                                      }
                                    }
    
                                    return NavigationActionPolicy.ALLOW;
                                  },
                                  onLoadStop: (controller, url) async {
                                    pullToRefreshController?.endRefreshing();
                                    setState(() {
                                      this.url = url.toString();
                                      urlController.text = this.url;
                                    });
                                  },
                                  onLoadError: (controller, url, code, message) {
                                    pullToRefreshController?.endRefreshing();
                                  },
                                  onProgressChanged: (controller, progress) {
                                    if (progress == 100) {
                                      pullToRefreshController?.endRefreshing();
                                    }
                                    setState(() {
                                      this.progress = progress / 100;
                                      urlController.text = this.url;
                                    });
                                  },
                                  onUpdateVisitedHistory:
                                      (controller, url, androidIsReload) {
                                    setState(() {
                                      this.url = url.toString();
                                      urlController.text = this.url;
                                    });
                                  },
                                  onConsoleMessage:
                                      (controller, consoleMessage) async {
                                    if (widget.lesson != null) {
                                      if (consoleMessage.message == "ended") {
                                        await lessonController
                                            .updateLessonProgress(
                                                widget.lesson?.id,
                                                widget.lesson?.courseId,
                                                1)
                                            .then((value) {
                                          Get.back();
                                        });
                                      }
                                    }
                                  },
                                  onCloseWindow: (controller) {},
                                ),
                                progress < 1.0
                                    ? LinearProgressIndicator(value: progress)
                                    : Container(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 30,
                      left: 5,
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.cancel,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return WillPopScope(
              onWillPop: () async => true,
              child: Scaffold(
                backgroundColor: Colors.black,
                body: Column(
                  children: <Widget>[
                    Expanded(
                      child: Stack(
                        children: [
                          InAppWebView(
                            key: webViewKey,
                            initialUrlRequest: URLRequest(url: Uri.parse(url)),
                            initialOptions: options,
                            pullToRefreshController: pullToRefreshController,
                            onWebViewCreated: (controller) {
                              webViewController = controller;
                            },
                            onLoadStart: (controller, url) {
                              setState(() {
                                this.url = url.toString();
                                urlController.text = this.url;
                              });
                            },
                            androidOnPermissionRequest:
                                (controller, origin, resources) async {
                              return PermissionRequestResponse(
                                  resources: resources,
                                  action: PermissionRequestResponseAction.GRANT);
                            },
                            shouldOverrideUrlLoading:
                                (controller, navigationAction) async {
                              var uri = navigationAction.request.url;
    
                              if (![
                                "http",
                                "https",
                                "file",
                                "chrome",
                                "data",
                                "javascript",
                                "about"
                              ].contains(uri?.scheme)) {
                                // ignore: deprecated_member_use
                                if (await canLaunch(url)) {
                                  // Launch the App
                                  // ignore: deprecated_member_use
                                  await launch(
                                    url,
                                  );
                                  // and cancel the request
                                  return NavigationActionPolicy.CANCEL;
                                }
                              }
    
                              return NavigationActionPolicy.ALLOW;
                            },
                            onLoadStop: (controller, url) async {
                              pullToRefreshController?.endRefreshing();
                              setState(() {
                                this.url = url.toString();
                                urlController.text = this.url;
                              });
                            },
                            onLoadError: (controller, url, code, message) {
                              pullToRefreshController?.endRefreshing();
                            },
                            onProgressChanged: (controller, progress) {
                              if (progress == 100) {
                                pullToRefreshController?.endRefreshing();
                              }
                              setState(() {
                                this.progress = progress / 100;
                                urlController.text = this.url;
                              });
                            },
                            onUpdateVisitedHistory:
                                (controller, url, androidIsReload) {
                              setState(() {
                                this.url = url.toString();
                                urlController.text = this.url;
                              });
                            },
                            onConsoleMessage: (controller, consoleMessage) async {
                              if (widget.lesson != null) {
                                if (consoleMessage.message == "ended") {
                                  await lessonController
                                      .updateLessonProgress(widget.lesson?.id,
                                          widget.lesson?.courseId, 1)
                                      .then((value) {
                                    Get.back();
                                  });
                                }
                              }
                            },
                            onCloseWindow: (controller) {},
                          ),
                          progress < 1.0
                              ? LinearProgressIndicator(value: progress)
                              : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        }),
      ),
    );
  }
}
