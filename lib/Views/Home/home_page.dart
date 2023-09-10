// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:

import 'package:get/get.dart';
// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/class_controller.dart';
import 'package:lms_flutter_app/Controller/home_controller.dart';
import 'package:lms_flutter_app/Controller/myCourse_controller.dart';
import 'package:lms_flutter_app/Controller/quiz_controller.dart';
import 'package:lms_flutter_app/Views/Home/Class/all_class_view.dart';
import 'package:lms_flutter_app/Views/Home/Class/class_details_page.dart';
import 'package:lms_flutter_app/Views/Home/Course/all_course_view.dart';
import 'package:lms_flutter_app/Views/Home/Course/course_category_page.dart';
import 'package:lms_flutter_app/Views/Home/Course/course_details_page.dart';
import 'package:lms_flutter_app/Views/Home/Quiz/AllQuizzesView.dart';
import 'package:lms_flutter_app/Views/Home/Quiz/quiz_details_page_view.dart';
import 'package:lms_flutter_app/Views/MyCourseClassQuiz/MyCourses/my_course_details_view.dart';
import 'package:lms_flutter_app/Views/MyCourseClassQuiz/MyQuiz/my_quiz_details_view.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';
import 'package:lms_flutter_app/utils/DefaultLoadingWidget.dart';
import 'package:lms_flutter_app/utils/widgets/AppBarWidget.dart';
import 'package:lms_flutter_app/utils/widgets/LoadingSkeletonItemWidget.dart';
import 'package:lms_flutter_app/utils/widgets/SingleCardItemWidget.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_skeleton_niu/loading_skeleton.dart';
// import 'package:loading_skeleton/loading_skeleton.dart';
import 'package:octo_image/octo_image.dart';

class HomePage extends GetView<HomeController> {
  Color selectColor(int position) {
    Color c = Color(0xff569AFF);
    if (position % 4 == 0) c = Color(0xff569AFF);
    if (position % 4 == 1) c = Color(0xff6D55FF);
    if (position % 4 == 2) c = Color(0xffD764FF);
    if (position % 4 == 3) c = Color(0xffFF9800);
    return c;
  }

  Future<void> refresh() async {
    controller.onInit();
  }

  @override
  Widget build(BuildContext context) {
    // double width;
    // double percentageWidth;
    double height;
    double percentageHeight;

    // width = MediaQuery.of(context).size.width;
    // percentageWidth = width / 100;
    height = MediaQuery.of(context).size.height;
    percentageHeight = height / 100;

    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: defaultLoadingWidget,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBarWidget(
            showSearch: true,
            goToSearch: true,
            showBack: false,
            showFilterBtn: true,
          ),
          body: Container(
            child: RefreshIndicator(
              onRefresh: refresh,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  SizedBox(
                    height: 15,
                  ),

                  /// TOP CATEGORIES
                  Container(
                      margin: EdgeInsets.only(
                        left: 20,
                        bottom: 14.72,
                        right: 20,
                      ),
                      child: Texth1("${stctrl.lang['Top Categories'] ?? ''}")),
                  Container(
                      margin: EdgeInsets.fromLTRB(
                        Get.locale == Locale('ar') ? 0 : 20,
                        0,
                        Get.locale == Locale('ar') ? 20 : 0,
                        0,
                      ),
                      child: Obx(() {
                        if (controller.isLoading.value)
                          return Container(
                            height: 80,
                            child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: 4,
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    width: 12,
                                  );
                                },
                                itemBuilder:
                                    (BuildContext context, int indexCat) {
                                  return LoadingSkeleton(
                                    height: 80,
                                    width: 140,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 8,
                                          ),
                                          LoadingSkeleton(
                                            height: percentageHeight * 1,
                                            width: 140,
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          LoadingSkeleton(
                                            height: percentageHeight * 0.5,
                                            width: 60,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          );
                        else {
                          return Container(
                            height: 80,
                            child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.topCatList.length,
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    width: 12,
                                  );
                                },
                                itemBuilder:
                                    (BuildContext context, int indexCat) {
                                  return GestureDetector(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: selectColor(indexCat),
                                          borderRadius:
                                              BorderRadius.circular(5.0)),
                                      height: 200,
                                      width: 140,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 15, top: 18, right: 15),
                                            child: CatTitle(controller
                                                        .topCatList[indexCat]
                                                        .name?[
                                                    '${stctrl.code.value}'] ??
                                                "${controller.topCatList[indexCat].name?['en']}"),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                left: 15, top: 5.3, right: 15),
                                            child: CatSubTitle(controller
                                                    .topCatList[indexCat]
                                                    .courseCount
                                                    .toString() +
                                                ' ' +
                                                "${stctrl.lang["Courses"]}"),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Get.to(() => CourseCategoryPage(
                                          controller.topCatList[indexCat].name?[
                                                  '${stctrl.code.value}'] ??
                                              "${controller.topCatList[indexCat].name?['en']}",
                                          indexCat));
                                    },
                                  );
                                }),
                          );
                        }
                      })),

                  /// FEATURED COURSES
                  Container(
                      margin: EdgeInsets.only(
                        left: Get.locale == Locale('ar') ? 12 : 20,
                        bottom: 14.72,
                        top: 30,
                        right: Get.locale == Locale('ar') ? 20 : 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Texth1("${stctrl.lang["Featured Courses"] ?? ''}"),
                          Expanded(
                            child: Container(),
                          ),
                          GestureDetector(
                            child: sellAllText(),
                            onTap: () {
                              Get.to(() => AllCourseView());
                            },
                          )
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        Get.locale == Locale('ar') ? 0 : 15,
                        0,
                        Get.locale == Locale('ar') ? 15 : 0,
                        0),
                    child: Obx(() {
                      if (controller.isLoading.value)
                        return LoadingSkeletonItemWidget();
                      else {
                        return Container(
                          height: 200,
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.popularCourseList.length,
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  width: 18,
                                );
                              },
                              padding: EdgeInsets.fromLTRB(
                                  Get.locale == Locale('ar') ? 0 : 5,
                                  0,
                                  Get.locale == Locale('ar') ? 5 : 0,
                                  0),
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return SingleItemCardWidget(
                                  showPricing: true,
                                  image:
                                      "$rootUrl/${controller.popularCourseList[index].image}",
                                  title: controller.popularCourseList[index]
                                          .title['${stctrl.code.value}'] ??
                                      "${controller.popularCourseList[index].title['en']}",
                                  subTitle: controller
                                      .popularCourseList[index].user.name,
                                  price:
                                      controller.popularCourseList[index].price,
                                  discountPrice: controller
                                      .popularCourseList[index].discountPrice,
                                  onTap: () async {
                                    context.loaderOverlay.show();
                                    controller.selectedLessonID.value = 0;
                                    controller.courseID.value =
                                        controller.popularCourseList[index].id;
                                    await controller.getCourseDetails();

                                    if (controller.isCourseBought.value) {
                                      final MyCourseController
                                          myCoursesController =
                                          Get.put(MyCourseController());

                                      myCoursesController.courseID.value =
                                          controller
                                              .popularCourseList[index].id;
                                      myCoursesController
                                          .selectedLessonID.value = 0;
                                      myCoursesController
                                          .myCourseDetailsTabController
                                          .controller
                                          ?.index = 0;

                                      await myCoursesController
                                          .getCourseDetails();
                                      Get.to(() => MyCourseDetailsView());
                                      context.loaderOverlay.hide();
                                    } else {
                                      Get.to(() => CourseDetailsPage());
                                      context.loaderOverlay.hide();
                                    }
                                  },
                                );
                              }),
                        );
                      }
                    }),
                  ),

                  /// FEATURED CLASSES
                  Container(
                    margin: EdgeInsets.only(
                      left: Get.locale == Locale('ar') ? 12 : 20,
                      bottom: 14.72,
                      right: Get.locale == Locale('ar') ? 20 : 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Texth1("${stctrl.lang["Featured Class"] ?? ''}"),
                        Expanded(
                          child: Container(),
                        ),
                        GestureDetector(
                          child: sellAllText(),
                          onTap: () {
                            Get.to(() => AllClassView());
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        Get.locale == Locale('ar') ? 0 : 15,
                        0,
                        Get.locale == Locale('ar') ? 15 : 0,
                        0),
                    child: Obx(() {
                      if (controller.isLoading.value)
                        return LoadingSkeletonItemWidget();
                      else {
                        return Container(
                          height: 200,
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.allClassesList.length,
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  width: 18,
                                );
                              },
                              padding: EdgeInsets.fromLTRB(
                                  Get.locale == Locale('ar') ? 0 : 5,
                                  0,
                                  Get.locale == Locale('ar') ? 5 : 0,
                                  0),
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return SingleItemCardWidget(
                                  showPricing: true,
                                  image:
                                      "$rootUrl/${controller.allClassesList[index].image}",
                                  title: controller.allClassesList[index]
                                          .title['${stctrl.code.value}'] ??
                                      "${controller.allClassesList[index].title['en']}",
                                  subTitle: controller
                                      .allClassesList[index].user.name,
                                  price: controller.allClassesList[index].price,
                                  discountPrice: controller
                                      .allClassesList[index].discountPrice,
                                  onTap: () async {
                                    final ClassController allCourseController =
                                        Get.put(ClassController());
                                    allCourseController.courseID.value =
                                        controller.allClassesList[index].id;
                                    allCourseController.getClassDetails();
                                    Get.to(() => ClassDetailsPage());
                                  },
                                );
                              }),
                        );
                      }
                    }),
                  ),

                  /// FEATURED QUIZZES
                  Container(
                    margin: EdgeInsets.only(
                      left: Get.locale == Locale('ar') ? 12 : 20,
                      bottom: 14.72,
                      right: Get.locale == Locale('ar') ? 20 : 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Texth1("${stctrl.lang["Featured Quizzes"] ?? ''}"),
                        Expanded(
                          child: Container(),
                        ),
                        GestureDetector(
                          child: sellAllText(),
                          onTap: () {
                            Get.to(() => AllQuizView());
                          },
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        Get.locale == Locale('ar') ? 0 : 15,
                        0,
                        Get.locale == Locale('ar') ? 15 : 0,
                        0),
                    child: Obx(() {
                      if (controller.isLoading.value)
                        return LoadingSkeletonItemWidget();
                      else {
                        return Container(
                          height: 200,
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.allQuizzesList.length,
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  width: 18,
                                );
                              },
                              padding: EdgeInsets.fromLTRB(
                                  Get.locale == Locale('ar') ? 0 : 5,
                                  0,
                                  Get.locale == Locale('ar') ? 5 : 0,
                                  0),
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return SingleItemCardWidget(
                                  showPricing: true,
                                  image:
                                      "$rootUrl/${controller.allQuizzesList[index].image}",
                                  title: controller.allQuizzesList[index]
                                          .title['${stctrl.code.value}'] ??
                                      "${controller.allQuizzesList[index].title['en']}",
                                  subTitle: controller
                                      .allQuizzesList[index].user.name,
                                  price: controller.allQuizzesList[index].price,
                                  discountPrice: controller
                                      .allQuizzesList[index].discountPrice,
                                  onTap: () async {
                                    context.loaderOverlay.show();
                                    final QuizController allQuizController =
                                        Get.put(QuizController());
                                    allQuizController.courseID.value =
                                        controller.allQuizzesList[index].id;

                                    await allQuizController.getQuizDetails();

                                    if (allQuizController.isQuizBought.value) {
                                      await allQuizController
                                          .getMyQuizDetails();
                                      Get.to(() => MyQuizDetailsPageView());
                                      context.loaderOverlay.hide();
                                    } else {
                                      Get.to(() => QuizDetailsPageView());
                                      context.loaderOverlay.hide();
                                    }
                                  },
                                );
                              }),
                        );
                      }
                    }),
                  ),

                  //**  POPULAR COURSES
                  Container(
                      margin: EdgeInsets.only(
                        left: Get.locale == Locale('ar') ? 12 : 20,
                        bottom: 14.72,
                        top: 27,
                        right: Get.locale == Locale('ar') ? 20 : 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Texth1("${stctrl.lang["Popular Courses"] ?? ''}"),
                          GestureDetector(
                            child: Container(
                              child: sellAllText(),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AllCourseView(),
                                  ));
                            },
                          )
                        ],
                      )),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Obx(() {
                      if (controller.isLoading.value)
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: 4,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
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
                                margin: EdgeInsets.fromLTRB(0, 5.8, 0, 5.8),
                                height: 78,
                                width: Get.width,
                                child: Row(
                                  children: [
                                    Container(
                                      child: LoadingSkeleton(
                                        width: 88,
                                        height: 78,
                                      ),
                                    ),
                                    Flexible(
                                      child: Container(
                                        width: 220,
                                        margin: EdgeInsets.only(
                                            left: 16, right: 16),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            LoadingSkeleton(
                                              height: 10,
                                              width: double.maxFinite,
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            LoadingSkeleton(
                                              height: 10,
                                              width: double.maxFinite,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      else {
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.popularCourseList.length,
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
                                  margin: EdgeInsets.fromLTRB(0, 5.8, 0, 5.8),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: OctoImage(
                                            image: NetworkImage(
                                                "$rootUrl/${controller.popularCourseList[index].image}"),
                                            placeholderBuilder:
                                                OctoPlaceholder.blurHash(
                                              'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                            ),
                                            errorBuilder: (BuildContext context,
                                                Object exception,
                                                StackTrace? stackTrace) {
                                              return Image.asset(
                                                'images/fcimg.png',
                                                fit: BoxFit.cover,
                                                width: 88,
                                                height: 78,
                                              );
                                            },
                                            fit: BoxFit.cover,
                                            width: 88,
                                            height: 78,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Container(
                                          width: 220,
                                          margin: EdgeInsets.only(
                                              left: 16, right: 16),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              PopularPostTitle(controller
                                                          .popularCourseList[index]
                                                          .title[
                                                      '${stctrl.code.value}'] ??
                                                  "${controller.popularCourseList[index].title['en']}"),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              courseTPublisher(controller
                                                  .popularCourseList[index]
                                                  .user
                                                  .name)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                onTap: () async {
                                  context.loaderOverlay.show();
                                  controller.courseID.value =
                                      controller.popularCourseList[index].id;
                                  await controller.getCourseDetails();

                                  if (controller.isCourseBought.value) {
                                    final MyCourseController
                                        myCoursesController =
                                        Get.put(MyCourseController());

                                    myCoursesController.courseID.value =
                                        controller.popularCourseList[index].id;
                                    myCoursesController.selectedLessonID.value =
                                        0;
                                    myCoursesController
                                        .myCourseDetailsTabController
                                        .controller
                                        ?.index = 0;

                                    await myCoursesController
                                        .getCourseDetails();
                                    Get.to(() => MyCourseDetailsView());
                                    context.loaderOverlay.hide();
                                  } else {
                                    Get.to(() => CourseDetailsPage());
                                    context.loaderOverlay.hide();
                                  }
                                },
                              );
                            });
                      }
                    }),
                  ),
                  SizedBox(
                    height: 80,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
