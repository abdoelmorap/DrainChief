// Dart imports:
import 'dart:convert';
import 'dart:io';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/course_details_tab_controller.dart';
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';
import 'package:lms_flutter_app/Controller/download_controller.dart';
import 'package:lms_flutter_app/Controller/home_controller.dart';
import 'package:lms_flutter_app/Controller/lesson_controller.dart';
import 'package:lms_flutter_app/Model/Course/Lesson.dart';
import 'package:lms_flutter_app/Service/iap_service.dart';
import 'package:lms_flutter_app/Views/VideoView/PDFViewPage.dart';
import 'package:lms_flutter_app/Views/VideoView/VideoChipherPage.dart';
import 'package:lms_flutter_app/Views/VideoView/VideoPlayerPage.dart';
import 'package:lms_flutter_app/Views/VideoView/VimeoPlayerPage.dart';
import 'package:lms_flutter_app/utils/CustomAlertBox.dart';
import 'package:lms_flutter_app/utils/CustomExpansionTileCard.dart';
import 'package:lms_flutter_app/utils/CustomSnackBar.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';
import 'package:lms_flutter_app/utils/MediaUtils.dart';
import 'package:lms_flutter_app/utils/SliverAppBarTitleWidget.dart';
import 'package:lms_flutter_app/utils/styles.dart';
import 'package:lms_flutter_app/utils/widgets/StarCounterWidget.dart';
import 'package:lms_flutter_app/utils/widgets/course_details_flexible_space_bar.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:octo_image/octo_image.dart';
import 'package:open_document/open_document.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';

// ignore: must_be_immutable
class CourseDetailsPage extends StatefulWidget {
  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  GetStorage userToken = GetStorage();

  String tokenKey = "token";

  double width = 0;

  double percentageWidth = 0;

  double height = 0;

  double percentageHeight = 0;

  bool isReview = false;

  bool isSignIn = true;

  bool playing = false;

  final HomeController controller = Get.put(HomeController());

  @override
  void initState() {
    if (Platform.isIOS) {
      controller.isPurchasingIAP.value = false;
      IAPService().initPlatformState();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController =
        Get.put(DashboardController());

    final CourseDetailsTabController _tabx =
        Get.put(CourseDetailsTabController());

    final double statusBarHeight = MediaQuery.of(context).padding.top;
    // ignore: unused_local_variable
    var pinnedHeaderHeight = statusBarHeight + kToolbarHeight;

    width = MediaQuery.of(context).size.width;
    percentageWidth = width / 100;
    height = MediaQuery.of(context).size.height;
    percentageHeight = height / 100;

    return Scaffold(
      body: LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
          child: SpinKitPulse(
            color: Get.theme.primaryColor,
            size: 30.0,
          ),
        ),
        child: Obx(() {
          if (controller.isCourseLoading.value)
            return Center(
              child: CupertinoActivityIndicator(),
            );
          return NestedScrollView(
            // floatHeaderSlivers: true,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 280.0,
                  automaticallyImplyLeading: false,
                  titleSpacing: 20,
                  title: SliverAppBarTitleWidget(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Icon(
                            Icons.arrow_back_outlined,
                            color: Get.textTheme.titleMedium?.color,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            controller.courseDetails.value
                                    .title?['${stctrl.code.value}'] ??
                                "${controller.courseDetails.value.title?['en']}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Get.textTheme.titleMedium,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      background: CourseDetailsFlexilbleSpaceBar(
                          controller.courseDetails.value)),
                ),
              ];
            },
            // pinnedHeaderSliverHeightBuilder: () {
            //   return pinnedHeaderHeight;
            // },
            body: Column(
              children: <Widget>[
                TabBar(
                  labelColor: Colors.white,
                  tabs: _tabx.myTabs,
                  unselectedLabelColor: AppStyles.unSelectedTabTextColor,
                  controller: _tabx.controller,
                  indicator: Get.theme.tabBarTheme.indicator,
                  automaticIndicatorColorAdjustment: true,
                  isScrollable: false,
                  labelStyle: Get.textTheme.titleSmall,
                  unselectedLabelStyle: Get.textTheme.titleSmall,
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabx.controller,
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      descriptionWidget(controller, dashboardController),
                      curriculumWidget(controller, dashboardController),
                      reviewWidget(controller, dashboardController),
                    ],
                  ),
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget descriptionWidget(
      HomeController controller, DashboardController dashboardController) {
    return ExtendedVisibilityDetector(
      uniqueKey:  const Key('Tab1'),
      child: Obx(() {
        return Scaffold(
          body: ListView(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            children: [
              Container(
                width: percentageWidth * 100,
                padding: EdgeInsets.fromLTRB(0, percentageHeight * 3, 0, 0),
                child: HtmlWidget(
                  '''
                    ${controller.courseDetails.value.about?['${stctrl.code.value}'] ?? "${controller.courseDetails.value.about?['en']}"}
                    ''',
                  customStylesBuilder: (element) {
                    if (element.classes.contains('foo')) {
                      return {'color': 'red'};
                    }
                    return null;
                  },
                  customWidgetBuilder: (element) {
                    if (element.attributes['foo'] == 'bar') {
                      // return FooBarWidget();
                    }
                    return null;
                  },
                  textStyle: Get.textTheme.titleSmall,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                "${stctrl.lang["Outcome"]}",
                style: Get.textTheme.titleSmall,
              ),
              Container(
                width: percentageWidth * 100,
                padding: EdgeInsets.fromLTRB(0, percentageHeight * 3, 0, 0),
                child: HtmlWidget(
                  '''
                    ${controller.courseDetails.value.outcomes?['${stctrl.code.value}'] ?? "${controller.courseDetails.value.outcomes?['en']}" ?? "${controller.courseDetails.value.outcomes?['en']}"}
                    ''',
                  customStylesBuilder: (element) {
                    if (element.classes.contains('foo')) {
                      return {'color': 'red'};
                    }
                    return null;
                  },
                  customWidgetBuilder: (element) {
                    if (element.attributes['foo'] == 'bar') {
                      // return FooBarWidget();
                    }
                    return null;
                  },
                  textStyle: Get.textTheme.titleSmall,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                "${stctrl.lang["Requirements"]}",
                style: Get.textTheme.titleSmall,
              ),
              Container(
                width: percentageWidth * 100,
                // height: percentageHeight * 25,
                padding: EdgeInsets.fromLTRB(0, percentageHeight * 3, 0, 0),
                child: HtmlWidget(
                  '''
                    ${controller.courseDetails.value.requirements?['${stctrl.code.value}'] ?? "" ?? ""}
                    ''',
                  customStylesBuilder: (element) {
                    if (element.classes.contains('foo')) {
                      return {'color': 'red'};
                    }
                    return null;
                  },
                  customWidgetBuilder: (element) {
                    if (element.attributes['foo'] == 'bar') {
                      // return FooBarWidget();
                    }
                    return null;
                  },
                  textStyle: Get.textTheme.titleSmall,
                ),
              ),
              SizedBox(
                height: 100,
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: dashboardController.loggedIn.value
              ? controller.isCourseBought.value
                  ? SizedBox.shrink()
                  : controller.courseDetails.value.price == 0
                      ? ElevatedButton(
                          child: Text(
                            "${stctrl.lang["Enroll the Course"]}",
                            style: Get.textTheme.titleSmall
                                ?.copyWith(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          style: Get.theme.elevatedButtonTheme.style,
                          onPressed: () async {
                            await controller
                                .buyNow(controller.courseDetails.value.id)
                                .then((value) async {
                              if (value) {
                                await Future.delayed(Duration(seconds: 5), () {
                                  Get.back();
                                  dashboardController
                                      .changeTabIndex(Platform.isIOS ? 1 : 2);
                                });
                              }
                            });
                          },
                        )
                      : controller.cartAdded.value && !Platform.isIOS
                          ? ElevatedButton(
                              child: Text(
                                "${stctrl.lang["View On Cart"]}",
                                style: Get.textTheme.titleSmall
                                    ?.copyWith(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () {
                                Get.back();
                                dashboardController.changeTabIndex(1);
                              },
                            )
                          : ElevatedButton(
                              child: AnimatedSwitcher(
                                duration: Duration(milliseconds: 500),
                                child: controller.isPurchasingIAP.value
                                    ? CupertinoActivityIndicator(
                                        color: Colors.white,
                                      )
                                    : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "${stctrl.lang["Enroll the Course"]}",
                                            style: Get.textTheme.titleSmall
                                                ?.copyWith(color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "${controller.courseDetails.value.discountPrice == null || controller.courseDetails.value.discountPrice == 0 ? controller.courseDetails.value.price.toString() : controller.courseDetails.value.discountPrice.toString()} $appCurrency",
                                            style: context.textTheme.titleMedium
                                                ?.copyWith(color: Colors.white),
                                          ),
                                        ],
                                      ),
                              ),
                              onPressed: () async {
                                if (Platform.isIOS) {
                                  try {
                                    print(
                                        "IAP Product ID -> ${controller.courseDetails.value.iapProductId}");
                                    controller.isPurchasingIAP.value = true;
                                    CustomerInfo purchaserInfo =
                                        await Purchases.purchaseProduct(
                                            controller.courseDetails.value
                                                .iapProductId ?? '');
                                    print(jsonEncode(purchaserInfo.toJson()));

                                    await controller
                                        .enrollIAP(
                                            controller.courseDetails.value.id)
                                        .then((value) {
                                      Get.back();
                                      dashboardController.changeTabIndex(1);
                                    });
                                    controller.isPurchasingIAP.value = false;
                                  } on PlatformException catch (e) {
                                    var errorCode =
                                        PurchasesErrorHelper.getErrorCode(e);
                                    if (errorCode ==
                                        PurchasesErrorCode
                                            .purchaseCancelledError) {
                                      print("Cancelled");
                                      CustomSnackBar()
                                          .snackBarWarning("Cancelled");
                                    } else if (errorCode ==
                                        PurchasesErrorCode
                                            .purchaseNotAllowedError) {
                                      CustomSnackBar().snackBarWarning(
                                          "User not allowed to purchase");
                                    } else if (errorCode ==
                                        PurchasesErrorCode
                                            .paymentPendingError) {
                                      CustomSnackBar().snackBarWarning(
                                          "Payment is pending");
                                    } else {
                                      print(e);
                                    }
                                    controller.isPurchasingIAP.value = false;
                                  } catch (e) {
                                    print(e);
                                    controller.isPurchasingIAP.value = false;
                                  }
                                } else {
                                  await controller.addToCart(controller
                                      .courseDetails.value.id
                                      .toString());
                                }
                              },
                            )
              : ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.back();
                    dashboardController.changeTabIndex(1);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD7598F)),
                  child: Text(
                    "${stctrl.lang["Get Full Access"]}",
                    style:
                        Get.textTheme.titleSmall?.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
        );
      }),
    );
  }

  Widget curriculumWidget(
      HomeController controller, DashboardController dashboardController) {
    void _scrollToSelectedContent(GlobalKey myKey) {
      final keyContext = myKey.currentContext;

      if (keyContext != null) {
        Future.delayed(Duration(milliseconds: 200)).then((value) {
          Scrollable.ensureVisible(keyContext,
              duration: Duration(milliseconds: 200));
        });
      }
    }

    return ExtendedVisibilityDetector(
        uniqueKey: const Key('Tab2'),
        child: Scaffold(
          body: ListView.separated(
            itemCount: controller.courseDetails.value.chapters?.length ?? 0,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 4,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              var lessons = controller.courseDetails.value.lessons
                  ?.where((element) =>
                      int.parse(element.chapterId.toString()) ==
                      int.parse(controller.courseDetails.value.chapters![index].id.toString()))
                  .toList();
              var total = 0;
              lessons?.forEach((element) {
                if (element.duration != null && element.duration != "") {
                  if (!element.duration!.contains("H")) {
                    total += double.parse(element.duration ?? '').toInt();
                  }
                }
              });
              final GlobalKey expansionTileKey = GlobalKey();
              return CustomExpansionTileCard(
                key: expansionTileKey,
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                onExpansionChanged: (isExpanded) {
                  if (isExpanded) _scrollToSelectedContent(expansionTileKey);
                },
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      (index + 1).toString() + ". ",
                    ),
                    SizedBox(
                      width: 0,
                    ),
                    Expanded(
                      child: Text(
                        controller.courseDetails.value.chapters?[index].name ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    total > 0
                        ? Text(
                            getTimeString(total).toString() +
                                " ${stctrl.lang["Hour(s)"]}",
                          )
                        : SizedBox.shrink()
                  ],
                ),
                children: <Widget>[
                  ListView.builder(
                      itemCount: lessons?.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      itemBuilder: (BuildContext context, int index) {
                        if (lessons?[index].isLock == 1) {
                          return InkWell(
                            onTap: () {
                              CustomSnackBar().snackBarWarning(
                                "${stctrl.lang["This lesson is locked. Purchase this course to get full access"]}",
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        child: Icon(
                                          Icons.lock,
                                          color: Get.theme.primaryColor,
                                          size: 18,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: lessons?[index].isQuiz == 1
                                            ? Text(
                                                lessons?[index].quiz?[0].title?[
                                                        '${stctrl.code.value}'] ??
                                                    "",
                                                style: Get.textTheme.titleSmall,
                                              )
                                            : Text(
                                                lessons?[index].name ?? "",
                                                style: Get.textTheme.titleSmall,
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          );
                        } else {
                          return InkWell(
                            onTap: () async {
                              if (lessons?[index].isQuiz != 1) {
                                context.loaderOverlay.show();
                                final isVisible = context.loaderOverlay.visible;
                                print(isVisible);

                                controller.selectedLessonID.value =
                                    lessons?[index].id;

                                if (lessons?[index].host == "Vimeo") {
                                  var vimeoID = lessons?[index]
                                      .videoUrl
                                      ?.replaceAll("/videos/", "");

                                  Get.bottomSheet(
                                    VimeoPlayerPage(
                                      lesson: lessons?[index] ?? Lesson(),
                                      videoTitle: "${lessons?[index].name}",
                                      videoId: '$rootUrl/vimeo/video/$vimeoID',
                                    ),
                                    backgroundColor: Colors.black,
                                    isScrollControlled: true,
                                  );
                                  context.loaderOverlay.hide();
                                } else if (lessons?[index].host == "Youtube") {
                                  Get.bottomSheet(
                                    VideoPlayerPage(
                                      "Youtube",
                                      lesson: lessons?[index] ?? Lesson(),
                                      videoID: lessons?[index].videoUrl ?? '',

                                    ),
                                    backgroundColor: Colors.black,
                                    isScrollControlled: true,
                                  );
                                  context.loaderOverlay.hide();
                                } else if (lessons?[index].host == "SCORM") {
                                  var videoUrl;
                                  videoUrl = rootUrl + (lessons?[index].videoUrl ?? '');

                                  final LessonController lessonController =
                                      Get.put(LessonController());

                                  await lessonController
                                      .updateLessonProgress(lessons?[index].id,
                                          lessons?[index].courseId, 1)
                                      .then((value) async {
                                    Get.bottomSheet(
                                      VimeoPlayerPage(
                                        lesson: lessons?[index] ?? Lesson(),
                                        videoTitle: lessons?[index].name ?? '',
                                        videoId: '$videoUrl',
                                      ),
                                      backgroundColor: Colors.black,
                                      isScrollControlled: true,
                                    );
                                    context.loaderOverlay.hide();
                                  });
                                } else if (lessons?[index].host == "VdoCipher") {
                                  await generateVdoCipherOtp(
                                          lessons?[index].videoUrl)
                                      .then((value) {
                                    if (value['otp'] != null) {
                                      final EmbedInfo embedInfo =
                                          EmbedInfo.streaming(
                                        otp: value['otp'],
                                        playbackInfo: value['playbackInfo'],
                                        embedInfoOptions: EmbedInfoOptions(
                                          autoplay: true,
                                        ),
                                      );

                                      Get.bottomSheet(
                                        VdoCipherPage(
                                          embedInfo: embedInfo,
                                        ),
                                        backgroundColor: Colors.black,
                                        isScrollControlled: true,
                                      );
                                      context.loaderOverlay.hide();
                                    } else {
                                      context.loaderOverlay.hide();
                                      CustomSnackBar()
                                          .snackBarWarning(value['message']);
                                    }
                                  });
                                } else {
                                  var videoUrl;
                                  if (lessons?[index].host == "Self") {
                                    videoUrl =
                                        rootUrl + "/" + (lessons?[index].videoUrl ?? '');
                                    Get.bottomSheet(
                                      VideoPlayerPage(
                                        "network",
                                        lesson: lessons?[index] ?? Lesson(),
                                        videoID: videoUrl,
                                      ),
                                      backgroundColor: Colors.black,
                                      isScrollControlled: true,
                                    );
                                    context.loaderOverlay.hide();
                                  } else if (lessons?[index].host == "URL" ||
                                      lessons?[index].host == "Iframe") {
                                    videoUrl = lessons?[index].videoUrl;
                                    Get.bottomSheet(
                                      VideoPlayerPage(
                                        "network",
                                        lesson: lessons?[index] ?? Lesson(),
                                        videoID: videoUrl,
                                      ),
                                      backgroundColor: Colors.black,
                                      isScrollControlled: true,
                                    );
                                    context.loaderOverlay.hide();
                                  } else if (lessons?[index].host == "PDF") {
                                    videoUrl =
                                        rootUrl + "/" + (lessons?[index].videoUrl ?? '');
                                    Get.to(() => PDFViewPage(
                                          pdfLink: videoUrl,
                                        ));
                                    context.loaderOverlay.hide();
                                  } else {
                                    videoUrl = lessons?[index].videoUrl;

                                    String filePath;

                                    final extension = p.extension(videoUrl);

                                    Directory applicationSupportDir =
                                        await getApplicationSupportDirectory();
                                    String appSupportPath =
                                        applicationSupportDir.path;

                                    filePath =
                                        "$appSupportPath/${companyName}_${lessons?[index].name}$extension";

                                    final isCheck =
                                        await OpenDocument.checkDocument(
                                            filePath: filePath);

                                    debugPrint("Exist: $isCheck");

                                    if (isCheck) {
                                      context.loaderOverlay.hide();
                                      await OpenDocument.openDocument(
                                        filePath: filePath,
                                      );
                                    } else {
                                      final LessonController lessonController =
                                          Get.put(LessonController());

                                      // ignore: deprecated_member_use
                                      if (await canLaunch(
                                          rootUrl + '/' + videoUrl)) {
                                        await lessonController
                                            .updateLessonProgress(
                                                lessons?[index].id,
                                                lessons?[index].courseId,
                                                1)
                                            .then((value) async {
                                          context.loaderOverlay.hide();
                                          final DownloadController
                                              downloadController =
                                              Get.put(DownloadController());
                                          Get.dialog(showDownloadAlertDialog(
                                            context,
                                            lessons?[index].name ?? "",
                                            videoUrl,
                                            downloadController,
                                          ));
                                        });
                                      } else {
                                        context.loaderOverlay.hide();
                                        CustomSnackBar().snackBarError(
                                            "${stctrl.lang["Unable to open"]}" +
                                                " ${lessons?[index].name}");
                                        // throw 'Unable to open url : ${rootUrl + '/' + videoUrl}';
                                      }
                                    }
                                  }
                                }
                              } else {
                                CustomSnackBar().snackBarWarning(
                                  "${stctrl.lang["This lesson is locked. Purchase this course to get full access"]}",
                                );
                              }
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      lessons?[index].isQuiz == 1
                                          ? Icon(
                                              FontAwesomeIcons.questionCircle,
                                              color: Get.theme.primaryColor,
                                              size: 16,
                                            )
                                          : !MediaUtils.isFile(
                                                  lessons?[index].host ?? '')
                                              ? Icon(
                                                  Icons.play_circle_outline,
                                                  color: Get.theme.primaryColor,
                                                  size: 16,
                                                )
                                              : Icon(
                                                  FontAwesomeIcons.file,
                                                  color: Get.theme.primaryColor,
                                                  size: 16,
                                                ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: lessons?[index].isQuiz == 1
                                              ? Text(
                                                  lessons?[index].quiz?[0].title.toString() ?? "",
                                                  style:
                                                      Get.textTheme.titleSmall,
                                                )
                                              : Text(
                                                  lessons?[index].name ?? "",
                                                  style:
                                                      Get.textTheme.titleSmall,
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          );
                        }
                      }),
                ],
              );
            },
          ),
        ));
  }

  showDownloadAlertDialog(BuildContext context, String title, String fileUrl,
      DownloadController downloadController) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("${stctrl.lang["No"]}"),
      onPressed: () {
        context.loaderOverlay.hide();
        Navigator.of(Get.overlayContext!).pop();
      },
    );
    Widget yesButton = TextButton(
      child: Text("${stctrl.lang["Download"]}"),
      onPressed: () async {
        context.loaderOverlay.hide();
        Navigator.of(Get.overlayContext!).pop();
        downloadController.downloadFile(fileUrl, title, context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "$title",
        style: Get.textTheme.titleMedium,
      ),
      content: Text("${stctrl.lang["Would you like to download this file?"]}"),
      actions: [
        cancelButton,
        yesButton,
      ],
    );

    // show the dialog
    return alert;
  }

  Widget reviewWidget(
      HomeController controller, DashboardController dashboardController) {
    return ExtendedVisibilityDetector(
        uniqueKey: const Key('Tab4'),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            SizedBox(height: 10),
            GestureDetector(
              child: Container(
                width: percentageWidth * 100,
                height: percentageHeight * 6,
                padding: EdgeInsets.fromLTRB(20, 0, 30, 0),
                margin: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Get.theme.cardColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(23),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    cartTotal("${stctrl.lang["Rate the course"]}"),
                    Icon(
                      Icons.add,
                      color: Get.theme.primaryColor,
                      size: 15,
                    )
                  ],
                ),
              ),
              onTap: () {
                var myRating = 5.0;
                controller.reviewText.clear();
                userToken.read(tokenKey) != null
                    ? Get.bottomSheet(SingleChildScrollView(
                        child: Container(
                          width: percentageWidth * 100,
                          height: percentageHeight * 54.68,
                          child: Container(
                              padding: EdgeInsets.fromLTRB(20, 15, 20, 20),
                              decoration: BoxDecoration(
                                color: Get.theme.cardColor,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(30),
                                    topRight: const Radius.circular(30)),
                              ),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    GestureDetector(
                                      child: Container(
                                        width: percentageWidth * 18.66,
                                        height: percentageHeight * 1,
                                        decoration: BoxDecoration(
                                            color: Color(0xffE5E5E5),
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(4.5)),
                                        // color: Color(0xffE5E5E5),
                                      ),
                                      onTap: () {
                                        Get.back();
                                      },
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Center(
                                      child: Text(
                                        "${stctrl.lang["Rate the course"]}",
                                        style: Get.textTheme.titleMedium
                                            ?.copyWith(fontSize: 20),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Center(
                                      child: Text(
                                        "${stctrl.lang["Your rating"]}",
                                        style: Get.textTheme.titleSmall,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      child: RatingBar.builder(
                                        itemSize: 30,
                                        initialRating: myRating,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(
                                            horizontal: 1.0),
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          myRating = rating;
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: percentageWidth * 100,
                                      height: percentageHeight * 12.19,
                                      decoration: BoxDecoration(
                                        color: Get.theme.cardColor,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Container(
                                              height: percentageHeight * 6.19,
                                              width: percentageWidth * 12,
                                              child: ClipOval(
                                                child: OctoImage(
                                                  fit: BoxFit.cover,
                                                  height: 40,
                                                  width: 40,
                                                  image: dashboardController
                                                          .profileData.image
                                                          !.contains('public/')
                                                      ? NetworkImage(
                                                          "$rootUrl/${dashboardController.profileData.image ?? ""}")
                                                      : NetworkImage(
                                                          dashboardController
                                                                  .profileData
                                                                  .image ??
                                                              ""),
                                                  placeholderBuilder:
                                                      OctoPlaceholder.blurHash(
                                                    'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: percentageWidth * 2,
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: percentageHeight * 12.19,
                                              width: percentageWidth * 75.22,
                                              decoration: BoxDecoration(
                                                color: Color(0xffF2F6FF),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: TextField(
                                                maxLines: 6,
                                                controller:
                                                    controller.reviewText,
                                                decoration: InputDecoration(
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                    left: 10,
                                                    top: 10,
                                                  ),
                                                  filled: true,
                                                  fillColor:
                                                      Get.theme.canvasColor,
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    borderSide: BorderSide(
                                                        color: Color.fromRGBO(
                                                            142, 153, 183, 0.4),
                                                        width: 1.0),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    borderSide: BorderSide(
                                                        color: Color.fromRGBO(
                                                            142, 153, 183, 0.4),
                                                        width: 1.0),
                                                  ),
                                                  hintText:
                                                      "${stctrl.lang["Your Review"]}",
                                                  hintStyle:
                                                      Get.textTheme.titleSmall,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        controller.submitCourseReview(
                                            controller.courseDetails.value.id,
                                            controller.reviewText.value.text,
                                            myRating);
                                      },
                                      child: Container(
                                        width: percentageWidth * 50,
                                        height: percentageHeight * 5,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Get.theme.primaryColor,
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          "${stctrl.lang["Submit Review"]}",
                                          style:
                                              Get.textTheme.titleSmall?.copyWith(
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ])),
                        ),
                      ))
                    : showLoginAlertDialog(
                        "${stctrl.lang["Login"]}",
                        "${stctrl.lang["You are not Logged In"]}",
                        "${stctrl.lang["Login"]}");
                Container();
              },
            ),
            controller.courseDetails.value.reviews?.length == 0
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Text(
                      "${stctrl.lang["No Review Found"]}",
                      style: Get.textTheme.titleSmall,
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.courseDetails.value.reviews?.length,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: percentageWidth * 100,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: Get.theme.cardColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                controller.courseDetails.value.reviews![index]
                                        .userImage
                                        !.contains('public/')
                                    ? CircleAvatar(
                                        radius: 20.0,
                                        backgroundColor: Color(0xFFD7598F),
                                        backgroundImage: NetworkImage(
                                            "$rootUrl/${controller.courseDetails.value.reviews?[index].userImage}"))
                                    : CircleAvatar(
                                        radius: 20.0,
                                        backgroundColor: Color(0xFFD7598F),
                                        backgroundImage: NetworkImage(
                                          controller.courseDetails.value
                                              .reviews?[index].userImage ?? '',
                                        )),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            cartTotal(controller.courseDetails
                                                .value.reviews?[index].userName ?? ''),
                                            Expanded(
                                              child: Container(),
                                            ),
                                            StarCounterWidget(
                                              value: controller.courseDetails
                                                  .value.reviews![index].star
                                                  !.toDouble(),
                                              color: Color(0xffFFCF23),
                                              size: 10,
                                            ),
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 0),
                                          child: courseStructure(controller
                                              .courseDetails
                                              .value
                                              .reviews?[index]
                                              .comment ?? ''),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    })
          ],
        ));
  }

  Future generateVdoCipherOtp(url) async {
    Uri apiUrl = Uri.parse('https://dev.vdocipher.com/api/videos/$url/otp');

    var response = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Apisecret $vdoCipherApiKey'
      },
    );
    var decoded = jsonDecode(response.body);
    return decoded;
  }
}
