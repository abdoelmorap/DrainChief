// Dart imports:
import 'dart:convert';
import 'dart:io';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// Package imports:

import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';
import 'package:lms_flutter_app/Controller/quiz_controller.dart';
import 'package:lms_flutter_app/Controller/quiz_details_tab_controller.dart';
import 'package:lms_flutter_app/utils/SliverAppBarTitleWidget.dart';
import 'package:lms_flutter_app/utils/styles.dart';
import 'package:octo_image/octo_image.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../../Service/iap_service.dart';
import '../../../utils/CustomSnackBar.dart';
import '../../../utils/widgets/course_details_flexible_space_bar.dart';

// ignore: must_be_immutable
class QuizDetailsPageView extends StatefulWidget {
  @override
  State<QuizDetailsPageView> createState() => _QuizDetailsPageViewState();
}

class _QuizDetailsPageViewState extends State<QuizDetailsPageView> {

  final QuizController controller = Get.put(QuizController());
  
  GetStorage userToken = GetStorage();

  String tokenKey = "token";

  double width = 0;

  double percentageWidth = 0;

  double height = 0;

  double percentageHeight = 0;

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

    final QuizDetailsTabController _tabx = Get.put(QuizDetailsTabController());

    // ignore: unused_local_variable
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    width = MediaQuery.of(context).size.width;
    percentageWidth = width / 100;
    height = MediaQuery.of(context).size.height;
    percentageHeight = height / 100;

    return Scaffold(
      body: Obx(() {
        if (controller.isQuizLoading.value)
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
                          controller.quizDetails.value
                                  .title?['${stctrl.code.value}'] ??
                              controller.quizDetails.value.title?['en'],
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
                        controller.quizDetails.value)),
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
                    quizDetailsWidget(controller, dashboardController),
                    questionAnswerWidget(controller, dashboardController),
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  Widget quizDetailsWidget(
      QuizController controller, DashboardController dashboardController) {
    return ExtendedVisibilityDetector(
      uniqueKey: const Key('Tab1'),
      child: Scaffold(
        body: ListView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            Text(
              "${stctrl.lang["Instruction"]}" + ": ",
              style: Get.textTheme.titleMedium,
            ),
            Container(
              width: percentageWidth * 100,
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: HtmlWidget(
                '''
                ${controller.quizDetails.value.quiz?.instruction?['${stctrl.code.value}'] ?? "${controller.quizDetails.value.quiz?.instruction?['en']}"}
                 ''',
                textStyle: Get.textTheme.titleSmall,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "${stctrl.lang["Quiz Time"]}" + ":",
              style: Get.textTheme.titleMedium,
            ),
            SizedBox(
              height: 10,
            ),
            controller.quizDetails.value.quiz?.questionTimeType == 0
                ? Text(
                    "${controller.quizDetails.value.quiz?.questionTime} " +
                        "${stctrl.lang["minute(s) per question"]}",
                    style: Get.textTheme.titleSmall,
                  )
                : Text(
                    "${controller.quizDetails.value.quiz?.questionTime} " +
                        "${stctrl.lang["minute(s)"]}",
                    style: Get.textTheme.titleSmall,
                  ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: dashboardController.loggedIn.value
            ? controller.isQuizBought.value
                ? Container()
                : controller.quizDetails.value.price == 0
                    ? ElevatedButton(
                        child: Text(
                          "${stctrl.lang["Enroll the Quiz"]}",
                          style: Get.textTheme.titleSmall
                              ?.copyWith(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        style: Get.theme.elevatedButtonTheme.style,
                        onPressed: () async {
                          await controller
                              .buyNow(
                                  controller.quizDetails.value.id.toString())
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
                                          "${controller.quizDetails.value.discountPrice == null || controller.quizDetails.value.discountPrice == 0 ? controller.quizDetails.value.price.toString() : controller.quizDetails.value.discountPrice.toString()} $appCurrency",
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
                                      "IAP Product ID -> ${controller.quizDetails.value.iapProductId}");
                                  controller.isPurchasingIAP.value = true;
                                  CustomerInfo purchaserInfo =
                                      await Purchases.purchaseProduct(controller
                                          .quizDetails.value.iapProductId ?? '');
                                  print(jsonEncode(purchaserInfo.toJson()));

                                  await controller
                                      .enrollIAP(
                                          controller.quizDetails.value.id)
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
                                await controller.addToCart(
                                    controller.quizDetails.value.id.toString());
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
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xffffffff),
                      height: 1.3,
                      fontFamily: 'AvenirNext'),
                  textAlign: TextAlign.center,
                ),
              ),
      ),
    );
  }

  Widget questionAnswerWidget(
      QuizController controller, DashboardController dashboardController) {
    return ExtendedVisibilityDetector(
      uniqueKey: const Key('Tab3'),
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: controller.quizDetails.value.comments?.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ClipOval(
                              child: OctoImage(
                                fit: BoxFit.cover,
                                height: 40,
                                width: 40,
                                image: controller.quizDetails.value
                                        .comments![index].user!.image
                                        !.contains('public/')
                                    ? NetworkImage(
                                        "$rootUrl/${controller.quizDetails.value.comments?[index].user?.image}")
                                    : NetworkImage(
                                        controller.quizDetails.value
                                            .comments?[index].user?.image ?? '',
                                      ),
                                placeholderBuilder: OctoPlaceholder.blurHash(
                                  'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          controller.quizDetails.value
                                              .comments?[index].user?.name
                                              .toString() ?? '',
                                          style: Get.textTheme.titleMedium,
                                        ),
                                        Expanded(child: Container()),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            controller.quizDetails.value
                                                .comments?[index].commentDate
                                                .toString() ?? '',
                                            style: Get.textTheme.titleSmall,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Text(
                                      controller.quizDetails.value
                                          .comments?[index].comment
                                          .toString() ?? '',
                                      style: Get.textTheme.titleSmall,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
