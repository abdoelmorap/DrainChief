// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:

import 'package:get/get.dart';

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/class_controller.dart';
import 'package:lms_flutter_app/Controller/course_and_class_tab_controller.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';
import 'package:lms_flutter_app/utils/widgets/SingleCardItemWidget.dart';
import 'my_class_details_page.dart';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';

class MyClassView extends StatefulWidget {
  const MyClassView({Key? key}) : super(key: key);

  @override
  _MyClassViewState createState() => _MyClassViewState();
}

class _MyClassViewState extends State<MyClassView> {
  double width = 0;
  double percentageWidth = 0;
  double height = 0;
  double percentageHeight = 0;

  final ClassController myClassController = Get.put(ClassController());

  final CourseClassQuizTabController courseAndClassTabController =
      Get.put(CourseClassQuizTabController());

  Future<void> refresh() async {
    myClassController.allMyClass.value = [];
    myClassController.allClassText.value = "${stctrl.lang["My Class"]}";
    myClassController.courseFiltered.value = false;
    myClassController.fetchAllMyClass();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    percentageWidth = width / 100;
    height = MediaQuery.of(context).size.height;
    percentageHeight = height / 100;
    myClassController.allClassText.value = "${stctrl.lang["My Class"]}";
    return ExtendedVisibilityDetector(
        uniqueKey: const Key('MyClassKey'),
        child: SafeArea(
          child: Scaffold(
            body: RefreshIndicator(
              onRefresh: refresh,
              child: ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(
                      left: 20,
                      bottom: 14.72,
                      right: 20,
                    ),
                    child: Texth1(myClassController.allClassText.value),
                  ),
                  Container(
                      margin: EdgeInsets.only(
                        left: 20,
                        bottom: 50.72,
                        right: 20,
                        top: 10,
                      ),
                      child: Obx(() {
                        if (myClassController.isLoading.value)
                          return Center(
                            child: CupertinoActivityIndicator(),
                          );
                        else {
                          if (myClassController.allMyClass.length == 0) {
                            return Container(
                              child: Texth1("${stctrl.lang["No Class found"]}"),
                            );
                          }
                          if (!courseAndClassTabController
                              .classSearchStarted.value) {
                            return GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                  mainAxisExtent: 200,
                                ),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                itemCount: myClassController.allMyClass.length,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return SingleItemCardWidget(
                                    showPricing: false,
                                    image:
                                        '$rootUrl/${myClassController.allMyClass[index].image}',
                                    title: myClassController.allMyClass[index]
                                            .title?['${stctrl.code.value}'] ??
                                        "${myClassController.allMyClass[index].title?['en']}",
                                    subTitle: myClassController
                                        .allMyClass[index].user?.name ?? '',
                                    price: myClassController
                                        .allMyClass[index].price,
                                    discountPrice: myClassController
                                        .allMyClass[index].discountPrice,
                                    onTap: () async {
                                      myClassController.courseID.value =
                                          myClassController
                                              .allMyClass[index].id;
                                      myClassController.getClassDetails();
                                      Get.to(() => MyClassDetailsPage());
                                    },
                                  );
                                });
                          }
                          return courseAndClassTabController
                                      .allMyClassSearch.length ==
                                  0
                              ? Text(
                                  "${stctrl.lang["No Class found"]}",
                                  style: Get.textTheme.titleMedium,
                                )
                              : GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10.0,
                                    mainAxisSpacing: 10.0,
                                    mainAxisExtent: 200,
                                  ),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  itemCount: courseAndClassTabController
                                      .allMyClassSearch.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return SingleItemCardWidget(
                                      showPricing: false,
                                      image:
                                          "$rootUrl/${courseAndClassTabController.allMyClassSearch[index].image}",
                                      title: courseAndClassTabController
                                              .allMyClassSearch[index]
                                              .title['${stctrl.code.value}'] ??
                                          "${courseAndClassTabController.allMyClassSearch[index].title['en']}",
                                      subTitle: courseAndClassTabController
                                          .allMyClassSearch[index].user.name,
                                      price: courseAndClassTabController
                                          .allMyClassSearch[index].price,
                                      discountPrice: courseAndClassTabController
                                          .allMyClassSearch[index]
                                          .discountPrice,
                                      onTap: () async {
                                        myClassController.courseID.value =
                                            courseAndClassTabController
                                                .allMyClassSearch[index].id;
                                        myClassController.getClassDetails();
                                        Get.to(() => MyClassDetailsPage());
                                      },
                                    );
                                  });
                        }
                      })),
                ],
              ),
            ),
          ),
        ));
  }
}
