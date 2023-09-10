// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// Package imports:

import 'package:get/get.dart';

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/class_controller.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';
import 'package:lms_flutter_app/utils/widgets/AppBarWidget.dart';
import 'package:lms_flutter_app/utils/widgets/FilterDrawer.dart';
import 'package:octo_image/octo_image.dart';

import 'class_details_page.dart';

class AllClassView extends StatefulWidget {
  const AllClassView({Key? key}) : super(key: key);

  @override
  _AllClassViewState createState() => _AllClassViewState();
}

class _AllClassViewState extends State<AllClassView> {
  double? width;
  double? percentageWidth;
  double? height;
  double? percentageHeight;

  var allClassSearch = [].obs;

  final ClassController allCourseController = Get.put(ClassController());

  onSearchTextChanged(String text) async {
    allClassSearch.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    allCourseController.allClass.forEach((course) {
      if (course.title?["${stctrl.code.value}"] != null) {
        if (course.title?["${stctrl.code.value}"].toUpperCase().contains(
                text.toUpperCase()) || // search  with course title name
            course.user!.name!
                .toUpperCase()
                .contains(text.toUpperCase())) // search  with teacher name
        {
          allClassSearch.add(course);
        }
      }
    });
    setState(() {});
  }

  Future<void> refresh() async {
    allCourseController.allClass.value = [];
    allCourseController.allClassText.value = "${stctrl.lang["All Class"]}";
    allCourseController.courseFiltered.value = false;
    allCourseController.fetchAllClass();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    percentageWidth = (width ?? 0) / 100;
    height = MediaQuery.of(context).size.height;
    percentageHeight = (height ?? 0) / 100;
    allCourseController.allClassText.value = "${stctrl.lang["All Class"]}";
    return SafeArea(
      child: Scaffold(
        appBar: AppBarWidget(
          showSearch: true,
          goToSearch: false,
          searching: onSearchTextChanged,
          showBack: true,
          showFilterBtn: false,
        ),
        endDrawer: Container(
            width: (percentageWidth ?? 0) * 90,
            child: Drawer(child: FilterDrawer())),
        body: RefreshIndicator(
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
                child: Texth1(allCourseController.allClassText.value),
              ),
              Container(
                  margin: EdgeInsets.only(
                    left: 20,
                    bottom: 50.72,
                    right: 20,
                    top: 10,
                  ),
                  child: Obx(() {
                    if (allCourseController.isLoading.value)
                      return Center(
                        child: CupertinoActivityIndicator(),
                      );
                    else {
                      return allClassSearch.length == 0
                          ? Container(
                              child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10.0,
                                    mainAxisSpacing: 10.0,
                                    mainAxisExtent: 185,
                                  ),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount:
                                      allCourseController.allClass.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Get.theme.cardColor,
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                blurRadius: 10,
                                                offset: Offset(2, 3),
                                              ),
                                            ]),
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
                                            Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  child: Container(
                                                      width: 174,
                                                      height: 90,
                                                      child: OctoImage(
                                                        image: NetworkImage(
                                                            "$rootUrl/${allCourseController.allClass[index].image}"),
                                                        placeholderBuilder:
                                                            OctoPlaceholder
                                                                .blurHash(
                                                          'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                                        ),
                                                        fit: BoxFit.fitWidth,
                                                        errorBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Object
                                                                    exception,
                                                                StackTrace?
                                                                    stackTrace) {
                                                          return Image.asset(
                                                              'images/fcimg.png');
                                                        },
                                                      )),
                                                ),
                                                Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(5),
                                                      ),
                                                      child: Container(
                                                        color:
                                                            Color(0xFFD7598F),
                                                        width: 40,
                                                        height: 20,
                                                        alignment:
                                                            Alignment.center,
                                                        child: (double.tryParse(allCourseController
                                                                        .allClass[
                                                                            index]
                                                                        .price
                                                                        .toString()) ??
                                                                    0) >
                                                                0
                                                            ? Text(
                                                                appCurrency +
                                                                    ' ' +
                                                                    allCourseController
                                                                        .allClass[
                                                                            index]
                                                                        .price
                                                                        .toString(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12),
                                                              )
                                                            : Text(
                                                                "${stctrl.lang["Free"]}",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                      ),
                                                    )),
                                              ],
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
                                                    courseTitle(allCourseController
                                                                .allClass[index]
                                                                .title?[
                                                            '${stctrl.code.value}'] ??
                                                        "${allCourseController.allClass[index].title?['en']}"),
                                                    courseTPublisher(
                                                        allCourseController
                                                                .allClass[index]
                                                                .user
                                                                ?.name ??
                                                            ''),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        allCourseController.courseID.value =
                                            allCourseController
                                                .allClass[index].id;
                                        allCourseController.getClassDetails();
                                        Get.to(() => ClassDetailsPage());
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
                                    mainAxisExtent: 185,
                                  ),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: allClassSearch.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return GestureDetector(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Get.theme.cardColor,
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                blurRadius: 10,
                                                offset: Offset(2, 3),
                                              ),
                                            ]),
                                        margin: EdgeInsets.only(
                                          bottom: 14.72,
                                        ),
                                        height: 120,
                                        width: 160,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(5)),
                                                  child: Container(
                                                      width: 174,
                                                      height: 90,
                                                      child: OctoImage(
                                                        image: NetworkImage(
                                                            '$rootUrl/${allClassSearch[index].image}'),
                                                        placeholderBuilder:
                                                            OctoPlaceholder
                                                                .blurHash(
                                                          'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                                        ),
                                                        fit: BoxFit.fitWidth,
                                                        errorBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Object
                                                                    exception,
                                                                StackTrace?
                                                                    stackTrace) {
                                                          return Image.asset(
                                                              'images/fcimg.png');
                                                        },
                                                      )),
                                                ),
                                                Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(5),
                                                      ),
                                                      child: Container(
                                                        color:
                                                            Color(0xFFD7598F),
                                                        width: 40,
                                                        height: 20,
                                                        alignment:
                                                            Alignment.center,
                                                        child: allClassSearch[
                                                                        index]
                                                                    .price >
                                                                0
                                                            ? Text(
                                                                appCurrency +
                                                                    ' ' +
                                                                    allClassSearch[
                                                                            index]
                                                                        .price
                                                                        .toString(),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12),
                                                              )
                                                            : Text(
                                                                "${stctrl.lang["Free"]}",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                      ),
                                                    )),
                                              ],
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
                                                    courseTitle(allClassSearch[
                                                                    index]
                                                                .title[
                                                            '${stctrl.code.value}'] ??
                                                        "${allClassSearch[index].title['en']}"),
                                                    courseTPublisher(
                                                        allCourseController
                                                                .allClass[index]
                                                                .user
                                                                ?.name ??
                                                            ''),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        allCourseController.courseID.value =
                                            allClassSearch[index].id;
                                        allCourseController.getClassDetails();
                                        Get.to(() => ClassDetailsPage());
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
    );
  }
}
