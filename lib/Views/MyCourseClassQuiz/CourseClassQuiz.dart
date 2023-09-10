// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:

import 'package:get/get.dart';

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/course_and_class_tab_controller.dart';
import 'package:lms_flutter_app/utils/DefaultLoadingWidget.dart';
import 'package:lms_flutter_app/utils/SliverAppBarTitleWidget.dart';
import 'package:lms_flutter_app/utils/styles.dart';

import 'package:loader_overlay/loader_overlay.dart';

import 'MyClass/my_class_view.dart';
import 'MyCourses/myCourse_page.dart';
import 'MyQuiz/my_quiz_view.dart';

class CourseAndClass extends StatefulWidget {
  @override
  _CourseAndClassState createState() => _CourseAndClassState();
}

class _CourseAndClassState extends State<CourseAndClass> {
  final CourseClassQuizTabController _tabx =
      Get.put(CourseClassQuizTabController());

  double width = 0;

  double percentageWidth = 0;

  double height = 0;

  double percentageHeight = 0;

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: defaultLoadingWidget,
      child: SafeArea(
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                    expandedHeight: 160,
                    automaticallyImplyLeading: false,
                    titleSpacing: 0,
                    centerTitle: false,
                    floating: false,
                    title: SliverAppBarTitleWidget(
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        alignment: Alignment.centerLeft,
                        width: 80,
                        height: 30,
                        child: Image.asset(
                          'images/$appLogo',
                        ),
                      ),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      background: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 20),
                                    alignment: Alignment.centerLeft,
                                    width: 80,
                                    height: 30,
                                    child: Image.asset(
                                      'images/$appLogo',
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                                margin: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 0),
                                child: Obx(() {
                                  return TextField(
                                    enabled: true,
                                    onChanged: _tabx.onCourseSearchTextChanged,
                                    autofocus: false,
                                    autocorrect: false,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Get.theme.canvasColor,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                48, 59, 88, 0.07),
                                            width: 1.0),
                                      ),
                                      hintText: "${stctrl.lang["Search in"]}" +
                                          " ${_tabx.searchText}",
                                      hintStyle: Get.textTheme.labelLarge,
                                      prefixIcon: Icon(
                                        Icons.search,
                                        size: 28,
                                        color: Get.theme.iconTheme.color,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )),
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
                  controller: _tabx.tabController,
                  indicator: Get.theme.tabBarTheme.indicator,
                  automaticIndicatorColorAdjustment: true,
                  isScrollable: false,
                  labelStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'AvenirNext'),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'AvenirNext',
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabx.tabController,
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      MyCoursePage(),
                      MyClassView(),
                      MyQuizView(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
