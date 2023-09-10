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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/class_controller.dart';
import 'package:lms_flutter_app/Controller/class_details_tab_controller.dart';
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';
import 'package:lms_flutter_app/Model/Class/BbbMeeting.dart';
import 'package:lms_flutter_app/Model/Class/JitsiMeeting.dart';
import 'package:lms_flutter_app/Model/Class/ZoomMeeting.dart';
import 'package:lms_flutter_app/utils/CustomAlertBox.dart';
import 'package:lms_flutter_app/utils/CustomDate.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';
import 'package:lms_flutter_app/utils/SliverAppBarTitleWidget.dart';
import 'package:lms_flutter_app/utils/styles.dart';
import 'package:lms_flutter_app/utils/widgets/StarCounterWidget.dart';
import 'package:octo_image/octo_image.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../Service/iap_service.dart';
import '../../../utils/CustomSnackBar.dart';
import '../../../utils/widgets/course_details_flexible_space_bar.dart';

// ignore: must_be_immutable
class ClassDetailsPage extends StatefulWidget {
  @override
  State<ClassDetailsPage> createState() => _ClassDetailsPageState();
}

class _ClassDetailsPageState extends State<ClassDetailsPage> {
  final ClassController controller = Get.put(ClassController());

  GetStorage userToken = GetStorage();

  String tokenKey = "token";

  double? width;

  double? percentageWidth;

  double? height;

  double? percentageHeight;

  bool isReview = false;

  bool isSignIn = true;

  bool playing = false;

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

    final ClassDetailsTabController _tabx =
        Get.put(ClassDetailsTabController());


    width = MediaQuery.of(context).size.width;
    percentageWidth = (width ?? 0) / 100;
    height = MediaQuery.of(context).size.height;
    percentageHeight = (height ?? 0) / 100;

    return Scaffold(
      body: Obx(() {
        if (controller.isClassLoading.value)
          return Center(
            child: CupertinoActivityIndicator(),
          );
        return NestedScrollView(
          // floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 280.0,
                automaticallyImplyLeading: false,
                titleSpacing: 20,
                title: SliverAppBarTitleWidget(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          controller.classDetails.value
                                  .title?["${stctrl.code.value}"] ??
                              controller.classDetails.value.title?["en"],
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
                      controller.classDetails.value),
                ),
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
                    scheduleWidget(controller, dashboardController),
                    instructorWidget(controller, dashboardController),
                    reviewWidget(controller, dashboardController),
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  Widget scheduleWidget(
      ClassController controller, DashboardController dashboardController) {
    return ExtendedVisibilityDetector(
      uniqueKey: const Key('Tab1'),
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: controller.classDetails.value.dataClass != null
              ? controller.classDetails.value.dataClass?.host == 'Zoom'
                  ? ListView.separated(
                      itemCount: controller
                          .classDetails.value.dataClass?.zoomMeetings?.length ?? 0,
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 5,
                        );
                      },
                      itemBuilder: (context, zoomIndex) {
                        ZoomMeeting zoomMeeting = controller.classDetails.value
                            .dataClass?.zoomMeetings?[zoomIndex] ?? ZoomMeeting();
                        bool showPlayBtn = false;
                        bool showLiveBtn = false;
                        int now = DateTime.now().millisecondsSinceEpoch;
                        if (now >
                            (zoomMeeting.startTime?.millisecondsSinceEpoch ?? 0) && now < (zoomMeeting.endTime?.millisecondsSinceEpoch ?? 0)) {
                          showPlayBtn = true;
                          showLiveBtn = true;
                        } else if (now >
                            (zoomMeeting.endTime?.millisecondsSinceEpoch ?? 0)) {
                          showPlayBtn = false;
                          showLiveBtn = false;
                        } else if (now <
                            (zoomMeeting.startTime?.millisecondsSinceEpoch ?? 0)) {
                          showPlayBtn = true;
                          showLiveBtn = false;
                        }
                        return Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                              color: showPlayBtn
                                  ? showLiveBtn
                                      ? Colors.green.withOpacity(0.2)
                                      : Colors.blue.withOpacity(0.2)
                                  : Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  cartTotal("${stctrl.lang["Start Date"]}"),
                                  courseStructure(
                                    CustomDate().formattedDate(controller
                                        .classDetails
                                        .value
                                        .dataClass
                                        ?.zoomMeetings?[zoomIndex]
                                        .startTime),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  cartTotal(
                                      "${stctrl.lang["Time (Start-End)"]}"),
                                  courseStructure(
                                    '${CustomDate().formattedHourOnly(controller.classDetails.value.dataClass?.zoomMeetings?[zoomIndex].startTime)} - ${CustomDate().formattedHourOnly(controller.classDetails.value.dataClass?.zoomMeetings?[zoomIndex].endTime)}',
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  cartTotal("${stctrl.lang["Duration"]}"),
                                  courseStructure(
                                    CustomDate().durationToString(int.parse(
                                            controller
                                                .classDetails
                                                .value
                                                .dataClass
                                                ?.zoomMeetings?[zoomIndex]
                                                .meetingDuration ?? '')) +
                                        ' Hr(s)',
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              showPlayBtn
                                  ? showLiveBtn
                                      ? Icon(FontAwesomeIcons.solidPlayCircle)
                                      : Icon(FontAwesomeIcons.solidPauseCircle)
                                  : Icon(FontAwesomeIcons.solidStopCircle),
                            ],
                          ),
                        );
                      })
                  : controller.classDetails.value.dataClass?.host == 'Jitsi'
                      ? ListView.builder(
                          itemCount: controller.classDetails.value.dataClass
                              ?.jitsiMeetings?.length,
                          itemBuilder: (context, jitsiIndex) {
                            JitsiMeeting jitsiMeeting = controller.classDetails
                                .value.dataClass?.jitsiMeetings?[jitsiIndex] ?? JitsiMeeting();

                            bool showPlayBtn = false;
                            bool showLiveBtn = false;
                            DateTime startDate =
                                DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(jitsiMeeting.datetime ?? '') * 1000);
                            DateTime endDate =
                                DateTime.fromMillisecondsSinceEpoch(
                                    (int.parse(jitsiMeeting.datetime ?? '') +
                                            ((jitsiMeeting.duration ?? 0) * 60)) *
                                        1000);
                            int now = DateTime.now().millisecondsSinceEpoch;
                            if (now > startDate.millisecondsSinceEpoch &&
                                now < endDate.millisecondsSinceEpoch) {
                              showPlayBtn = true;
                              showLiveBtn = true;
                            } else if (now > endDate.millisecondsSinceEpoch) {
                              showPlayBtn = false;
                              showLiveBtn = false;
                            } else if (now < startDate.millisecondsSinceEpoch) {
                              showPlayBtn = true;
                              showLiveBtn = false;
                            }
                            return Container(
                              decoration: BoxDecoration(
                                  color: showPlayBtn
                                      ? showLiveBtn
                                          ? Colors.green.withOpacity(0.2)
                                          : Colors.blue.withOpacity(0.2)
                                      : Colors.red.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(5)),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      cartTotal("${stctrl.lang["Start Date"]}"),
                                      courseStructure(
                                        CustomDate().formattedDate(startDate),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      cartTotal(
                                          "${stctrl.lang["Time (Start-End)"]}"),
                                      courseStructure(
                                        '${CustomDate().formattedHourOnly(startDate)} - ${CustomDate().formattedHourOnly(endDate)}',
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      cartTotal("${stctrl.lang["Duration"]}"),
                                      courseStructure(
                                        CustomDate().durationToString(controller
                                                .classDetails
                                                .value
                                                .dataClass
                                                ?.jitsiMeetings?[jitsiIndex]
                                                .duration ?? 0) +
                                            ' Hr(s)',
                                      ),
                                    ],
                                  ),
                                  Expanded(child: Container()),
                                  showPlayBtn
                                      ? showLiveBtn
                                          ? Icon(
                                              FontAwesomeIcons.solidPlayCircle)
                                          : Icon(
                                              FontAwesomeIcons.solidPauseCircle)
                                      : Icon(FontAwesomeIcons.solidStopCircle),
                                ],
                              ),
                            );
                          })
                      : controller.classDetails.value.dataClass?.host == 'BBB'
                          ? ListView.builder(
                              itemCount: controller.classDetails.value.dataClass
                                  ?.bbbMeetings?.length,
                              itemBuilder: (context, bbbIndex) {
                                BbbMeeting bbbMeeting = controller.classDetails
                                    .value.dataClass?.bbbMeetings?[bbbIndex] ?? BbbMeeting();

                                bool showPlayBtn = false;
                                bool showLiveBtn = false;
                                DateTime startDate =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(bbbMeeting.datetime ?? '') * 1000);
                                DateTime endDate = DateTime.fromMillisecondsSinceEpoch((int.parse(bbbMeeting.datetime ?? '') + (bbbMeeting.duration * 60)).toInt() * 1000);
                                    // DateTime.fromMillisecondsSinceEpoch((int.parse(bbbMeeting.datetime) + (bbbMeeting.duration * 60)) * 1000);
                                int now = DateTime.now().millisecondsSinceEpoch;
                                if (now > startDate.millisecondsSinceEpoch &&
                                    now < endDate.millisecondsSinceEpoch) {
                                  showPlayBtn = true;
                                  showLiveBtn = true;
                                } else if (now >
                                    endDate.millisecondsSinceEpoch) {
                                  showPlayBtn = false;
                                  showLiveBtn = false;
                                } else if (now <
                                    startDate.millisecondsSinceEpoch) {
                                  showPlayBtn = true;
                                  showLiveBtn = false;
                                }

                                return Container(
                                  decoration: BoxDecoration(
                                      color: showPlayBtn
                                          ? showLiveBtn
                                              ? Colors.green.withOpacity(0.2)
                                              : Colors.blue.withOpacity(0.2)
                                          : Colors.red.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          cartTotal(
                                              "${stctrl.lang["Start Date"]}"),
                                          courseStructure(
                                            CustomDate()
                                                .formattedDate(startDate),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Container(),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          cartTotal(
                                              "${stctrl.lang["Time (Start-End)"]}"),
                                          courseStructure(
                                            '${CustomDate().formattedHourOnly(startDate)} - ${CustomDate().formattedHourOnly(endDate)}',
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Container(),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          cartTotal(
                                              "${stctrl.lang["Duration"]}"),
                                          courseStructure(
                                            CustomDate().durationToString(
                                                    controller
                                                        .classDetails
                                                        .value
                                                        .dataClass
                                                        ?.bbbMeetings?[bbbIndex]
                                                        .duration) +
                                                ' Hr(s)',
                                          ),
                                        ],
                                      ),
                                      Expanded(child: Container()),
                                      showPlayBtn
                                          ? showLiveBtn
                                              ? Icon(FontAwesomeIcons
                                                  .solidPlayCircle)
                                              : Icon(FontAwesomeIcons
                                                  .solidPauseCircle)
                                          : Icon(
                                              FontAwesomeIcons.solidStopCircle),
                                    ],
                                  ),
                                );
                              })
                          : Container()
              : Container(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: dashboardController.loggedIn.value
            ? controller.isClassBought.value
                ? Container()
                : controller.classDetails.value.price == 0
                    ? ElevatedButton(
                        child: Text(
                          "${stctrl.lang["Enroll the Class"]}",
                          style: Get.textTheme.titleSmall
                              ?.copyWith(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        style: Get.theme.elevatedButtonTheme.style,
                        onPressed: () async {
                          await controller
                              .buyNow(controller.classDetails.value.id)
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
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffffffff),
                                  height: 1.3,
                                  fontFamily: 'AvenirNext'),
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
                                          "${controller.classDetails.value.discountPrice == null || controller.classDetails.value.discountPrice == 0 ? controller.classDetails.value.price.toString() : controller.classDetails.value.discountPrice.toString()} $appCurrency",
                                          style: Get.textTheme.titleMedium
                                              ?.copyWith(color: Colors.white),
                                        ),
                                      ],
                                    ),
                            ),
                            onPressed: () async {
                              if (Platform.isIOS) {
                                try {
                                  print(
                                      "IAP Product ID -> ${controller.classDetails.value.iapProductId}");
                                  controller.isPurchasingIAP.value = true;
                                  CustomerInfo purchaserInfo =
                                      await Purchases.purchaseProduct(controller.classDetails.value.iapProductId ?? '');
                                  print(jsonEncode(purchaserInfo.toJson()));

                                  await controller
                                      .enrollIAP(
                                          controller.classDetails.value.id)
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
                                      PurchasesErrorCode.paymentPendingError) {
                                    CustomSnackBar()
                                        .snackBarWarning("Payment is pending");
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
                                    .classDetails.value.id
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
                child: Container(
                  width: (percentageWidth ?? 0) * 35,
                  height: (percentageHeight ?? 0) * 5,
                  alignment: Alignment.center,
                  child: Text(
                    "${stctrl.lang["Get Full Access"]}",
                    style:
                        Get.textTheme.titleSmall?.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
      ),
    );
  }

  Widget instructorWidget(
      ClassController controller, DashboardController dashboardController) {
    return ExtendedVisibilityDetector(
      uniqueKey: const Key('Tab1'),
      child: Scaffold(
        body: Container(
          width: (percentageWidth ?? 0) * 100,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(0),
          ),
          child: controller.classDetails.value.user != null
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Color(0xFFD7598F),
                      backgroundImage: controller.classDetails.value.user!.avatar!.contains('public/')
                          ? NetworkImage('$rootUrl/${controller.classDetails.value.user?.avatar}')
                          : NetworkImage(controller.classDetails.value.user?.avatar ?? ''),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          cartTotal(
                              '${controller.classDetails.value.user?.firstName} ${controller.classDetails.value.user?.lastName}'),
                          courseStructure(
                            controller.classDetails.value.user?.headline ?? "",
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          StarCounterWidget(
                            value: controller
                                .classDetails.value.user?.totalRating
                                ?.toDouble() ?? 0,
                            color: Color(0xffFFCF23),
                            size: 10,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          courseStructure(
                            controller.classDetails.value.user?.shortDetails ?? '',
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Container(),
        ),
      ),
    );
  }

  Widget reviewWidget(
      ClassController controller, DashboardController dashboardController) {
    return ExtendedVisibilityDetector(
        uniqueKey: const Key('Tab4'),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            SizedBox(height: 10),
            GestureDetector(
              child: Container(
                width: (percentageWidth ?? 0) * 100,
                height: (percentageHeight ?? 0) * 6,
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
                    cartTotal("${stctrl.lang["Rate the class"]}"),
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
                          width: (percentageWidth ?? 0) * 100,
                          height: (percentageHeight ?? 0) * 54.68,
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
                                        width: (percentageWidth ?? 0) * 18.66,
                                        height: (percentageHeight ?? 0) * 1,
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
                                        "${stctrl.lang["Rate the class"]}",
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
                                      width: (percentageWidth ?? 0) * 100,
                                      height: (percentageHeight ?? 0) * 12.19,
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
                                              height: (percentageHeight ?? 0) * 6.19,
                                              width: (percentageWidth ?? 0) * 12,
                                              child: ClipOval(
                                                child: OctoImage(
                                                  fit: BoxFit.cover,
                                                  height: 40,
                                                  width: 40,
                                                  image: dashboardController
                                                          .profileData.image
                                                          !.contains("public/")
                                                      ? NetworkImage(
                                                          '$rootUrl/${dashboardController.profileData.image ?? ""}')
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
                                            width: (percentageWidth ?? 0) * 2,
                                          ),
                                          Expanded(
                                            child: Container(
                                              height: (percentageHeight ?? 0) * 12.19,
                                              width: (percentageWidth ?? 0) * 75.22,
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
                                            controller.classDetails.value.id,
                                            controller.reviewText.value.text,
                                            myRating);
                                      },
                                      child: Container(
                                        width: (percentageWidth ?? 0) * 50,
                                        height: (percentageHeight ?? 0) * 5,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Get.theme.primaryColor,
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Text(
                                          "${stctrl.lang["Submit Review"]}",
                                          style: Get.textTheme.titleSmall,
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
            controller.classDetails.value.reviews == null ||
                    controller.classDetails.value.reviews?.length == 0
                ? Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Text(
                      "${stctrl.lang["No Review Found"]}",
                      style: Get.textTheme.titleSmall,
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.classDetails.value.reviews?.length,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: (percentageWidth ?? 0) * 100,
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
                                CircleAvatar(
                                  radius: 20.0,
                                  backgroundColor: Color(0xFFD7598F),
                                  backgroundImage: controller.classDetails.value
                                          .reviews![index].userImage
                                          !.contains("public/")
                                      ? NetworkImage(
                                          '$rootUrl/${controller.classDetails.value.reviews?[index].userImage}')
                                      : NetworkImage(
                                          controller.classDetails.value
                                              .reviews?[index].userImage ?? '',
                                        ),
                                ),
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
                                            cartTotal(controller.classDetails
                                                .value.reviews?[index].userName ?? ''),
                                            Expanded(
                                              child: Container(),
                                            ),
                                            StarCounterWidget(
                                              value: controller.classDetails
                                                  .value.reviews?[index].star
                                                  ?.toDouble() ?? 0,
                                              color: Color(0xffFFCF23),
                                              size: 10,
                                            ),
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 0),
                                          child: courseStructure(controller
                                              .classDetails
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
}
