// Dart imports:
import 'dart:math' as math;

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// Package imports:

import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';
import 'package:lms_flutter_app/Controller/my_quiz_details_tab_controller.dart';
import 'package:lms_flutter_app/Controller/question_controller.dart';
import 'package:lms_flutter_app/Controller/quiz_controller.dart';
import 'package:lms_flutter_app/Model/Quiz/MyQuizResultsModel.dart';
import 'package:lms_flutter_app/Views/MyCourseClassQuiz/MyQuiz/quiz_result_screen.dart';
import 'package:lms_flutter_app/utils/CustomDate.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';
import 'package:lms_flutter_app/utils/SliverAppBarTitleWidget.dart';
import 'package:lms_flutter_app/utils/styles.dart';
import 'package:octo_image/octo_image.dart';

import '../../../utils/widgets/course_details_flexible_space_bar.dart';
import 'start_quiz_page.dart';

// ignore: must_be_immutable
class MyQuizDetailsPageView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final QuizController controller = Get.put(QuizController());

    final DashboardController dashboardController =
        Get.put(DashboardController());

    final MyQuizDetailsTabController _tabx =
        Get.put(MyQuizDetailsTabController());

    final double statusBarHeight = MediaQuery.of(context).padding.top;
    // ignore: unused_local_variable
    var pinnedHeaderHeight = statusBarHeight + kToolbarHeight;

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
                          controller.myQuizDetails.value
                                  .title?['${stctrl.code.value}'] ??
                              controller.myQuizDetails.value.title?['en'],
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
                        controller.myQuizDetails.value)),
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
                    quizDetailsWidget(controller, dashboardController, context),
                    resultsWidget(controller, dashboardController),
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

  Widget quizDetailsWidget(QuizController controller,
      DashboardController dashboardController, BuildContext context) {
    return ExtendedVisibilityDetector(
      uniqueKey: const Key('Tab1'),
      child: Scaffold(
        body: ListView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            Text(
              "${stctrl.lang["Instruction"]}",
              style: Get.textTheme.titleMedium,
            ),
            Container(
              width: percentageWidth * 100,
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: HtmlWidget(
                '''
                ${controller.myQuizDetails.value.quiz?.instruction?['${stctrl.code.value}'] ?? "${controller.myQuizDetails.value.quiz?.instruction?['en']}"}
                ''',
                textStyle: Get.textTheme.titleSmall,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "${stctrl.lang["Quiz Time"]}",
              style: Get.textTheme.titleMedium,
            ),
            SizedBox(
              height: 10,
            ),
            controller.myQuizDetails.value.quiz?.questionTimeType == 0
                ? Text(
                    "${controller.myQuizDetails.value.quiz?.questionTime} " +
                        "${stctrl.lang["minute(s) per question"]}",
                    style: Get.textTheme.titleSmall,
                  )
                : Text(
                    "${controller.myQuizDetails.value.quiz?.questionTime} " +
                        "${stctrl.lang["minute(s)"]}",
                    style: Get.textTheme.titleSmall,
                  ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: controller
                    .myQuizDetails.value.quiz?.multipleAttend ==
                1
            ? ElevatedButton(
                child: Text(
                  "${stctrl.lang["Start Quiz"]}",
                  style: Get.textTheme.titleSmall?.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            "${stctrl.lang["Start Quiz"]}",
                            style: context.theme.textTheme.titleMedium,
                          ),
                          backgroundColor: Get.theme.cardColor,
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              courseStructure(
                                "${stctrl.lang["Do you want to start the quiz?"]}",
                              ),
                              controller.myQuizDetails.value.quiz
                                          ?.questionTimeType ==
                                      0
                                  ? courseStructure(
                                      "${stctrl.lang["Quiz Time"]}" + ": " + '${controller.myQuizDetails.value.quiz?.questionTime.toString()}' + " " + "${stctrl.lang["minute(s) per question"]}",
                                    )
                                  : courseStructure(
                                      "${stctrl.lang["Quiz Time"]}" +
                                          ": " +
                                          '${controller.myQuizDetails.value.quiz?.questionTime.toString()}' +
                                          " " +
                                          "${stctrl.lang["minute(s)"]}",
                                    ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      width: 100,
                                      height: percentageHeight * 5,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.transparent,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        "${stctrl.lang["Cancel"]}",
                                        style: Get.textTheme.titleMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  Obx(() {
                                    return controller.isQuizStarting.value
                                        ? Container(
                                            width: 100,
                                            height: percentageHeight * 5,
                                            alignment: Alignment.center,
                                            child: CupertinoActivityIndicator())
                                        : ElevatedButton(
                                            onPressed: () async {
                                              await controller
                                                  .startQuiz()
                                                  .then((value) {
                                                if (value) {
                                                  Navigator.of(context).pop();
                                                  Get.to(() => StartQuizPage(
                                                      getQuizDetails: controller
                                                          .myQuizDetails
                                                          .value));
                                                } else {
                                                  Get.snackbar(
                                                    "${stctrl.lang["Error"]}",
                                                    "${stctrl.lang["Error Starting Quiz"]}",
                                                    snackPosition:
                                                        SnackPosition.BOTTOM,
                                                    backgroundColor: Colors.red,
                                                    colorText: Colors.black,
                                                    borderRadius: 5,
                                                    duration:
                                                        Duration(seconds: 3),
                                                  );
                                                }
                                              });
                                            },
                                            child: Text(
                                              "${stctrl.lang["Start"]}",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: Color(0xffffffff),
                                                  height: 1.3,
                                                  fontFamily: 'AvenirNext'),
                                              textAlign: TextAlign.center,
                                            ),
                                          );
                                  })
                                ],
                              ),
                            ],
                          ),
                        );
                      });
                },
              )
            : Container(),
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
                itemCount: controller.myQuizDetails.value.comments?.length,
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
                                image: NetworkImage(
                                    '$rootUrl/${controller.myQuizDetails.value.comments?[index].user?.image}'),
                                placeholderBuilder: OctoPlaceholder.blurHash(
                                  'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                ),
                                errorBuilder: (context, obj, stact) {
                                  return Image.asset(
                                    'images/fcimg.png',
                                    fit: BoxFit.cover,
                                  );
                                },
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
                                          controller.myQuizDetails.value
                                              .comments?[index].user?.name
                                              .toString() ?? '',
                                          style: Get.textTheme.titleMedium,
                                        ),
                                        Expanded(child: Container()),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4.0),
                                          child: Text(
                                            controller.myQuizDetails.value
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
                                      controller.myQuizDetails.value
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
              height: 100,
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          decoration: BoxDecoration(
            color: Get.theme.cardColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: 40,
                child: ClipOval(
                  child: OctoImage(
                    fit: BoxFit.cover,
                    height: 40,
                    width: 40,
                    image: NetworkImage(
                        '$rootUrl/${controller.dashboardController.profileData.image ?? ""}'),
                    placeholderBuilder: OctoPlaceholder.blurHash(
                      'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  width: percentageWidth * 50,
                  constraints: BoxConstraints(maxHeight: percentageWidth * 15),
                  decoration: BoxDecoration(
                    color: Color(0xffF2F6FF),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.zero,
                  child: TextField(
                    controller: controller.commentController,
                    maxLines: 10,
                    minLines: 1,
                    autofocus: false,
                    showCursor: true,
                    scrollPhysics: AlwaysScrollableScrollPhysics(),
                    decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        filled: true,
                        fillColor: Get.theme.canvasColor,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(142, 153, 183, 0.4),
                              width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(142, 153, 183, 0.4),
                              width: 1.0),
                        ),
                        hintText: "${stctrl.lang["Add Comment"]}",
                        hintStyle: Get.textTheme.titleMedium),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              InkWell(
                onTap: () {
                  controller.submitComment(controller.myQuizDetails.value.id,
                      controller.commentController.value.text);
                },
                child: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                      color: Get.theme.primaryColor, shape: BoxShape.circle),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 2.0),
                    child: Transform.rotate(
                      angle: math.pi / 4,
                      child: Icon(
                        FontAwesomeIcons.locationArrow,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget resultsWidget(
      QuizController controller, DashboardController dashboardController) {
    // return Container();
    return ExtendedVisibilityDetector(
      uniqueKey: const Key('Tab3'),
      child: Container(
        child: controller.myQuizResult.value.data?.length == 0
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Texth1("${stctrl.lang["No resutls found"]}"),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            "${stctrl.lang["Date"]}",
                            style: Get.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "${stctrl.lang["Mark"]}",
                            style: Get.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "%",
                            style: Get.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "${stctrl.lang["Rating"]}",
                            style: Get.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 15,
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: controller.myQuizResult.value.data?.length ?? 0,
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(vertical: 4),
                        separatorBuilder: (context, index) {
                          return Divider(
                            height: 16,
                          );
                        },
                        itemBuilder: (BuildContext context, int index) {
                          final MyQuizResultsData data =
                              controller.myQuizResult.value.data?[index] ?? MyQuizResultsData();
                          var obtainedMarks = 0;
                          var totalScore = 0;
                          var status = "";
                          var percentage = "";
                          data.result?.forEach((element) {
                            if (element.quizTestId == data.id) {
                              obtainedMarks = element.score;
                              totalScore = element.totalScore;
                              if (element.publish == 1) {
                                status = element.status ?? '';
                              } else {
                                status = "Pending";
                              }
                              percentage = double.parse(
                                      ((element.score / element.totalScore) *
                                              100)
                                          .toString())
                                  .toStringAsFixed(2);
                            }
                          });
                          return InkWell(
                            onTap: () async {
                              final QuestionController questionController =
                                  Get.put(QuestionController());

                              await questionController
                                  .getQuizResultPreview(data.id);
                              Get.to(() => QuizResultScreen());
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "${CustomDate().formattedDate(data.startAt)}",
                                    textAlign: TextAlign.start,
                                    style: context.textTheme.titleMedium,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "$obtainedMarks/$totalScore",
                                    style: context.textTheme.titleSmall,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "$percentage %",
                                    style: context.textTheme.titleSmall,
                                  ),
                                ),
                                status == "Pending"
                                    ? Container(
                                        decoration: BoxDecoration(
                                            color: Color(0xfff4f6fe),
                                            borderRadius:
                                                BorderRadius.circular(3)),
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          "$status".toUpperCase(),
                                          style: context.textTheme.titleSmall
                                              ?.copyWith(
                                            color: Colors.black54,
                                          ),
                                        ),
                                      )
                                    : status == "Failed"
                                        ? Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xffFF1414),
                                                borderRadius:
                                                    BorderRadius.circular(3)),
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                              "$status",
                                              style: context.textTheme.titleSmall
                                                  ?.copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                                color: Get.theme.primaryColor,
                                                borderRadius:
                                                    BorderRadius.circular(3)),
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.all(5),
                                            child: Text(
                                              "$status",
                                              style: context.textTheme.titleSmall
                                                  ?.copyWith(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
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
      ),
    );
  }
}
