// Flutter imports:
import 'package:flutter/cupertino.dart';
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
import 'package:lms_flutter_app/utils/widgets/FilterDrawer.dart';
import 'package:lms_flutter_app/utils/widgets/SingleCardItemWidget.dart';
import 'package:loader_overlay/loader_overlay.dart';

class AllCourseView extends StatefulWidget {
  const AllCourseView({Key? key}) : super(key: key);

  @override
  _AllCourseViewState createState() => _AllCourseViewState();
}

class _AllCourseViewState extends State<AllCourseView> {
  double? width;
  double? percentageWidth;
  double? height;
  double? percentageHeight;

  var allCourseSearch = [].obs;

  final HomeController _homeController = Get.put(HomeController());

  onSearchTextChanged(String text) async {
    allCourseSearch.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _homeController.allCourse.forEach((course) {
      if (course.title?["${stctrl.code.value}"] != null) {
        if (course.title?["${stctrl.code.value}"].toUpperCase().contains(
                text.toUpperCase()) || // search  with course title name
            course.user!.name
                !.toUpperCase()
                .contains(text.toUpperCase())) // search  with teacher name
        {
          allCourseSearch.add(course);
        }
      }
    });
    setState(() {});
  }

  Future<void> refresh() async {
    _homeController.allCourse.value = [];
    _homeController.allCourseText.value = "${stctrl.lang["All Courses"]}";
    _homeController.courseFiltered.value = false;
    _homeController.fetchAllCourse();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    percentageWidth = (width ?? 0) / 100;
    height = MediaQuery.of(context).size.height;
    percentageHeight = (height ?? 0) / 100;
    _homeController.allCourseText.value = "${stctrl.lang["All Courses"]}";
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: defaultLoadingWidget,
      child: SafeArea(
        child: Scaffold(
          key: _homeController.filterDrawer,
          appBar: AppBarWidget(
            showSearch: true,
            goToSearch: false,
            searching: onSearchTextChanged,
            showBack: true,
            showFilterBtn: true,
          ),
          endDrawer: Container(
              width: (percentageWidth ?? 0) * 90,
              child: Drawer(child: FilterDrawer())),
          body: Container(
            child: RefreshIndicator(
              onRefresh: refresh,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                        left: 20,
                        bottom: 14.72,
                        right: 20,
                      ),
                      child: Obx(() {
                        if (_homeController.courseFiltered.value) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Texth1(_homeController.allCourseText.value),
                              GestureDetector(
                                onTap: refresh,
                                child: Text("${stctrl.lang["Reset"]}",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff303B58),
                                        fontFamily: 'AvenirNext',
                                        letterSpacing: 1)),
                              ),
                            ],
                          );
                        } else {
                          return Texth1(_homeController.allCourseText.value);
                        }
                      })),
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
                            child: CupertinoActivityIndicator(),
                          );
                        else {
                          return allCourseSearch.length == 0
                              ? Container(
                                  child: GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 10.0,
                                        mainAxisSpacing: 10.0,
                                        mainAxisExtent: 220,
                                      ),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount:
                                          _homeController.allCourse.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return SingleItemCardWidget(
                                          showPricing: true,
                                          image:
                                              "$rootUrl/${_homeController.allCourse[index].image}",
                                          title: _homeController
                                                      .allCourse[index].title?[
                                                  '${stctrl.code.value}'] ??
                                              "${_homeController.allCourse[index].title?['en']}",
                                          subTitle: _homeController
                                              .allCourse[index].user?.name ?? '',
                                          price: _homeController
                                              .allCourse[index].price,
                                          discountPrice: _homeController
                                              .allCourse[index].discountPrice,
                                          onTap: () async {
                                            context.loaderOverlay.show();

                                            _homeController.courseID.value =
                                                _homeController
                                                    .allCourse[index].id;
                                            await _homeController
                                                .getCourseDetails();

                                            if (_homeController
                                                .isCourseBought.value) {
                                              final MyCourseController
                                                  myCoursesController =
                                                  Get.put(MyCourseController());

                                              myCoursesController
                                                      .courseID.value =
                                                  _homeController
                                                      .allCourse[index].id;
                                              myCoursesController
                                                  .selectedLessonID.value = 0;
                                              myCoursesController
                                                  .myCourseDetailsTabController
                                                  .controller
                                                  ?.index = 0;

                                              await myCoursesController
                                                  .getCourseDetails();
                                              Get.to(
                                                  () => MyCourseDetailsView());
                                              context.loaderOverlay.hide();
                                            } else {
                                              Get.to(() => CourseDetailsPage());
                                              context.loaderOverlay.hide();
                                            }
                                          },
                                        );
                                      }),
                                )
                              : Container(
                                  child: GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 10.0,
                                        mainAxisSpacing: 10.0,
                                        mainAxisExtent: 220,
                                      ),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: allCourseSearch.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return SingleItemCardWidget(
                                          showPricing: true,
                                          image:
                                              "$rootUrl/${allCourseSearch[index].image}",
                                          title: allCourseSearch[index].title[
                                                  '${stctrl.code.value}'] ??
                                              "${allCourseSearch[index].title['en']}",
                                          subTitle:
                                              allCourseSearch[index].user.name,
                                          price: allCourseSearch[index].price,
                                          discountPrice: allCourseSearch[index]
                                              .discountPrice,
                                          onTap: () async {
                                            context.loaderOverlay.show();

                                            _homeController.courseID.value =
                                                allCourseSearch[index].id;
                                            await _homeController
                                                .getCourseDetails();

                                            if (_homeController
                                                .isCourseBought.value) {
                                              final MyCourseController
                                                  myCoursesController =
                                                  Get.put(MyCourseController());

                                              myCoursesController
                                                      .courseID.value =
                                                  allCourseSearch[index].id;
                                              myCoursesController
                                                  .selectedLessonID.value = 0;
                                              myCoursesController
                                                  .myCourseDetailsTabController
                                                  .controller
                                                  ?.index = 0;

                                              await myCoursesController
                                                  .getCourseDetails();
                                              Get.to(
                                                  () => MyCourseDetailsView());
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
                      })),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
