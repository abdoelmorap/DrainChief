// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:

import 'package:get/get.dart';

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/home_controller.dart';
import 'package:lms_flutter_app/Controller/myCourse_controller.dart';
import 'package:lms_flutter_app/Views/Home/Course/course_details_page.dart';
import 'package:lms_flutter_app/Views/MyCourseClassQuiz/MyCourses/my_course_details_view.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';
import 'package:lms_flutter_app/utils/DefaultLoadingWidget.dart';
import 'package:lms_flutter_app/utils/widgets/AppBarWidget.dart';
import 'package:lms_flutter_app/utils/widgets/SingleCardItemWidget.dart';
import 'package:loader_overlay/loader_overlay.dart';

// ignore: must_be_immutable
class CourseCategoryPage extends StatelessWidget {
  String title;
  int catIndex;

  CourseCategoryPage(this.title, this.catIndex);

  double? width;
  double? percentageWidth;
  double? height;
  double? percentageHeight;

  @override
  Widget build(BuildContext context) {
    final HomeController _homeController = Get.put(HomeController());
    width = MediaQuery.of(context).size.width;
    percentageWidth = (width ?? 0) / 100;
    height = MediaQuery.of(context).size.height;
    percentageHeight = (height ?? 0) / 100;
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: defaultLoadingWidget,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBarWidget(
            showSearch: true,
            goToSearch: true,
            showBack: true,
            showFilterBtn: true,
          ),
          body: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                  margin: EdgeInsets.only(
                    left: 20,
                    bottom: 14.72,
                    right: 20,
                  ),
                  child: Texth1(title + " " + "${stctrl.lang["courses"]}")),
              Container(
                  margin: EdgeInsets.only(
                    left: 20,
                    bottom: 50.72,
                    right: 20,
                    top: 10,
                  ),
                  child: Obx(() {
                    if (_homeController.isLoading.value)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    else {
                      return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            mainAxisExtent: 210,
                          ),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _homeController
                              .topCatList[catIndex].courses?.length,
                          itemBuilder: (BuildContext context, int courseIndex) {
                            return SingleItemCardWidget(
                              showPricing: true,
                              image:
                                  "$rootUrl/${_homeController.topCatList[catIndex].courses?[courseIndex].image}",
                              title: _homeController
                                      .topCatList[catIndex]
                                      .courses?[courseIndex]
                                      .title?['${stctrl.code.value}'] ??
                                  "${_homeController.topCatList[catIndex].courses?[courseIndex].title?['en']}",
                              subTitle: "",
                              price: _homeController.topCatList[catIndex]
                                  .courses?[courseIndex].price,
                              discountPrice: _homeController
                                  .topCatList[catIndex]
                                  .courses?[courseIndex]
                                  .discountPrice,
                              onTap: () async {
                                context.loaderOverlay.show();

                                _homeController.courseID.value = _homeController
                                    .topCatList[catIndex]
                                    .courses?[courseIndex]
                                    .id;
                                await _homeController.getCourseDetails();

                                if (_homeController.isCourseBought.value) {
                                  final MyCourseController myCoursesController =
                                      Get.put(MyCourseController());

                                  myCoursesController.courseID.value =
                                      _homeController.topCatList[catIndex]
                                          .courses?[courseIndex].id;
                                  myCoursesController.selectedLessonID.value =
                                      0;
                                  myCoursesController
                                      .myCourseDetailsTabController
                                      .controller
                                      ?.index = 0;

                                  await myCoursesController.getCourseDetails();
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
                  })),
              SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
