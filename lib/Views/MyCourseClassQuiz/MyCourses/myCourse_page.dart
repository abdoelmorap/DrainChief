// Flutter imports:
// Package imports:
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/course_and_class_tab_controller.dart';
import 'package:lms_flutter_app/Controller/home_controller.dart';
import 'package:lms_flutter_app/Controller/myCourse_controller.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';
import 'package:lms_flutter_app/utils/styles.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:octo_image/octo_image.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'my_course_details_view.dart';

class MyCoursePage extends StatefulWidget {
  @override
  _MyCoursePageState createState() => _MyCoursePageState();
}

class _MyCoursePageState extends State<MyCoursePage> {
  double width = 0;

  double percentageWidth = 0;

  double height = 0;

  double percentageHeight = 0;

  final MyCourseController myCoursesController = Get.put(MyCourseController());

  final HomeController homeController = Get.put(HomeController());

  final CourseClassQuizTabController courseAndClassTabController =
      Get.put(CourseClassQuizTabController());

  Future<void> refresh() async {
    myCoursesController.myCourses.value = [];
    myCoursesController.fetchMyCourse();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    percentageWidth = width / 100;
    height = MediaQuery.of(context).size.height;
    percentageHeight = height / 100;
    return ExtendedVisibilityDetector(
        uniqueKey: const Key('MyCourseKey'),
        child: Scaffold(
          body: RefreshIndicator(
            onRefresh: refresh,
            child: ListView(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                    margin: EdgeInsets.only(
                      left: 20,
                      bottom: 14.72,
                      right: 20,
                    ),
                    child: Texth1("${stctrl.lang["My Courses"]}")),
                Container(
                    margin: EdgeInsets.only(
                      left: 20,
                      bottom: 50.72,
                      right: 20,
                      top: 10,
                    ),
                    child: Obx(() {
                      if (myCoursesController.isLoading.value)
                        return Center(
                          child: CupertinoActivityIndicator(),
                        );
                      else {
                        if (myCoursesController.myCourses.length == 0) {
                          return Container(
                            child: Texth1("${stctrl.lang["No Course found"]}"),
                          );
                        }
                        if (!courseAndClassTabController
                            .courseSearchStarted.value) {
                          return GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10.0,
                                mainAxisSpacing: 10.0,
                                mainAxisExtent: 220,
                              ),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: myCoursesController.myCourses.length,
                              physics: NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Get.theme.cardColor,
                                      borderRadius: BorderRadius.circular(5.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Get.theme.shadowColor,
                                          blurRadius: 10.0,
                                          offset: Offset(2, 3),
                                        ),
                                      ],
                                    ),
                                    width: 160,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            child: Container(
                                              width: Get.width,
                                              height: 100,
                                              child: OctoImage(
                                                image: NetworkImage(
                                                    "$rootUrl/${myCoursesController.myCourses[index].image}"),
                                                placeholderBuilder:
                                                    OctoPlaceholder.blurHash(
                                                  'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                                ),
                                                fit: BoxFit.cover,
                                                errorBuilder:
                                                    (BuildContext context,
                                                        Object exception,
                                                        StackTrace? stackTrace) {
                                                  return Image.asset(
                                                      'images/fcimg.png');
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 12, right: 30, top: 10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              courseTitle(myCoursesController
                                                          .myCourses[index]
                                                          .title?[
                                                      '${stctrl.code.value}'] ??
                                                  "${myCoursesController.myCourses[index].title?['en']}"),
                                              courseTPublisher(
                                                  myCoursesController
                                                      .myCourses[index]
                                                      .user
                                                      ?.name ?? ''),
                                            ],
                                          ),
                                        ),
                                        myCoursesController.myCourses[index]
                                                    .totalCompletePercentage ==
                                                null
                                            ? Container()
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  myCoursesController
                                                              .myCourses[index]
                                                              .totalCompletePercentage ==
                                                          null
                                                      ? Container()
                                                      : Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          child:
                                                              LinearPercentIndicator(
                                                            lineHeight: 10.0,
                                                            percent: myCoursesController
                                                                    .myCourses[
                                                                        index]
                                                                    .totalCompletePercentage /
                                                                100,
                                                            backgroundColor:
                                                                Color(
                                                                    0xffF2F6FF),
                                                            progressColor: Get
                                                                .theme
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                  Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 6),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "${myCoursesController.myCourses[index].totalCompletePercentage}% " +
                                                          "${stctrl.lang["Complete"]}",
                                                      style: Get.theme.textTheme
                                                          .titleSmall,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                ],
                                              ),
                                      ],
                                    ),
                                  ),
                                  onTap: () async {
                                    context.loaderOverlay.show();
                                    myCoursesController.courseID.value =
                                        myCoursesController.myCourses[index].id;
                                    myCoursesController.selectedLessonID.value =
                                        0;
                                    myCoursesController
                                        .myCourseDetailsTabController
                                        .controller
                                        ?.index = 0;
                                    myCoursesController
                                            .totalCourseProgress.value =
                                        myCoursesController.myCourses[index]
                                            .totalCompletePercentage;
                                    await myCoursesController
                                        .getCourseDetails();
                                    Get.to(() => MyCourseDetailsView());
                                    context.loaderOverlay.hide();
                                  },
                                );
                              });
                        }
                        return courseAndClassTabController
                                    .myCoursesSearch.length ==
                                0
                            ? Text(
                                "${stctrl.lang["No Course found"]}",
                                style: Get.textTheme.titleMedium,
                              )
                            : GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                  mainAxisExtent:
                                      MediaQuery.of(context).size.height * 0.3,
                                ),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                itemCount: courseAndClassTabController
                                    .myCoursesSearch.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Get.theme.cardColor,
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Get.theme.shadowColor,
                                            blurRadius: 10.0,
                                            offset: Offset(2, 3),
                                          ),
                                        ],
                                      ),
                                      height: 120,
                                      width: 160,
                                      margin: EdgeInsets.only(
                                        bottom: 14.72,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            child: Container(
                                                width: 174,
                                                height: 90,
                                                child: OctoImage(
                                                  image: NetworkImage(
                                                      "$rootUrl/${courseAndClassTabController.myCoursesSearch[index].image}"),
                                                  placeholderBuilder:
                                                      OctoPlaceholder.blurHash(
                                                    'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                                  ),
                                                  fit: BoxFit.fitWidth,
                                                  errorBuilder: (BuildContext
                                                          context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                    return Image.asset(
                                                        'images/fcimg.png');
                                                  },
                                                )),
                                          ),
                                          Container(
                                            padding: EdgeInsets.only(
                                              top: 12.35,
                                              left: 12,
                                              right: 30,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                courseTitle(
                                                    courseAndClassTabController
                                                                .myCoursesSearch[
                                                                    index]
                                                                .title[
                                                            '${stctrl.code.value}'] ??
                                                        "${courseAndClassTabController.myCoursesSearch[index].title['en']}"),
                                                courseTPublisher(
                                                    courseAndClassTabController
                                                        .myCoursesSearch[index]
                                                        .user
                                                        .name),
                                              ],
                                            ),
                                          ),
                                          courseAndClassTabController
                                                      .myCoursesSearch[index]
                                                      .totalCompletePercentage ==
                                                  null
                                              ? Container()
                                              : Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Divider(),
                                                    courseAndClassTabController
                                                                .myCoursesSearch[
                                                                    index]
                                                                .totalCompletePercentage ==
                                                            null
                                                        ? Container()
                                                        : Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            child:
                                                                LinearPercentIndicator(
                                                              lineHeight: 14.0,
                                                              percent: courseAndClassTabController
                                                                      .myCoursesSearch[
                                                                          index]
                                                                      .totalCompletePercentage /
                                                                  100,
                                                              backgroundColor:
                                                                  Color(
                                                                      0xffF2F6FF),
                                                              progressColor:
                                                                  AppStyles
                                                                      .appThemeColor,
                                                            ),
                                                          ),
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              vertical: 8),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "${courseAndClassTabController.myCoursesSearch[index].totalCompletePercentage}% " +
                                                            "${stctrl.lang["Complete"]}",
                                                        style: Get
                                                            .theme
                                                            .textTheme
                                                            .titleSmall,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () async {
                                      context.loaderOverlay.show();
                                      myCoursesController.courseID.value =
                                          courseAndClassTabController
                                              .myCoursesSearch[index].id;
                                      myCoursesController
                                          .myCourseDetailsTabController
                                          .controller
                                          ?.index = 0;
                                      myCoursesController
                                          .selectedLessonID.value = 0;
                                      myCoursesController
                                              .totalCourseProgress.value =
                                          myCoursesController.myCourses[index]
                                              .totalCompletePercentage;
                                      await myCoursesController
                                          .getCourseDetails();
                                      Get.to(() => MyCourseDetailsView());
                                      context.loaderOverlay.hide();
                                    },
                                  );
                                });
                      }
                    })),
              ],
            ),
          ),
        ));
  }
}
