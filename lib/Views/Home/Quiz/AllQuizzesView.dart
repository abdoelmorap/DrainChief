// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// Package imports:

import 'package:get/get.dart';
// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/quiz_controller.dart';
import 'package:lms_flutter_app/Views/Home/Quiz/quiz_details_page_view.dart';
import 'package:lms_flutter_app/Views/MyCourseClassQuiz/MyQuiz/my_quiz_details_view.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';
import 'package:lms_flutter_app/utils/DefaultLoadingWidget.dart';
import 'package:lms_flutter_app/utils/widgets/AppBarWidget.dart';
import 'package:lms_flutter_app/utils/widgets/FilterDrawer.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:octo_image/octo_image.dart';

class AllQuizView extends StatefulWidget {
  const AllQuizView({Key? key}) : super(key: key);

  @override
  _AllQuizViewState createState() => _AllQuizViewState();
}

class _AllQuizViewState extends State<AllQuizView> {
  double width = 0;
  double percentageWidth = 0;
  double height = 0;
  double percentageHeight = 0;

  var allQuizSearch = [].obs;

  final QuizController allQuizzesController = Get.put(QuizController());

  onSearchTextChanged(String text) async {
    allQuizSearch.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    allQuizzesController.allClass.forEach((userDetail) {
      if (userDetail.title
              .toString()
              .contains(text.toUpperCase()) || // search  with course title name
          userDetail.user!.name
              !.toUpperCase()
              .contains(text.toUpperCase())) // search  with teacher name
        allQuizSearch.add(userDetail);
    });
    setState(() {});
  }

  Future<void> refresh() async {
    allQuizzesController.allClass.value = [];
    allQuizzesController.allClassText.value = "${stctrl.lang["All Quiz"]}";
    allQuizzesController.courseFiltered.value = false;
    allQuizzesController.fetchAllClass();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    percentageWidth = width / 100;
    height = MediaQuery.of(context).size.height;
    percentageHeight = height / 100;
    allQuizzesController.allClassText.value = "${stctrl.lang["All Quiz"]}";
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: defaultLoadingWidget,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBarWidget(
            showSearch: true,
            goToSearch: false,
            searching: onSearchTextChanged,
            showBack: true,
            showFilterBtn: false,
          ),
          endDrawer: Container(
              width: percentageWidth * 90,
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
                  child: Texth1(allQuizzesController.allClassText.value),
                ),
                Container(
                    margin: EdgeInsets.only(
                      left: 20,
                      bottom: 50.72,
                      right: 20,
                      top: 10,
                    ),
                    child: Obx(() {
                      if (allQuizzesController.isLoading.value)
                        return Center(
                          child: CupertinoActivityIndicator(),
                        );
                      else {
                        return allQuizSearch.length == 0
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
                                        allQuizzesController.allClass.length,
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
                                                              "$rootUrl/${allQuizzesController.allClass[index].image}"),
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
                                                              Radius.circular(
                                                                  5),
                                                        ),
                                                        child: Container(
                                                          color:
                                                              Color(0xFFD7598F),
                                                          width: 40,
                                                          height: 20,
                                                          alignment:
                                                              Alignment.center,
                                                          child: double.parse(allQuizzesController
                                                                      .allClass[
                                                                          index]
                                                                      .price
                                                                      .toString()) >
                                                                  0
                                                              ? Text(
                                                                  appCurrency +
                                                                      ' ' +
                                                                      allQuizzesController
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      courseTitle(allQuizzesController
                                                                  .allClass[index]
                                                                  .title?[
                                                              '${stctrl.code.value}'] ??
                                                          "${allQuizzesController.allClass[index].title?['en']}"),
                                                      courseTPublisher(
                                                          allQuizzesController
                                                              .allClass[index]
                                                              .user
                                                              !.name ?? ''),
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        ),
                                        onTap: () async {
                                          context.loaderOverlay.show();
                                          allQuizzesController.courseID.value =
                                              allQuizzesController
                                                  .allClass[index].id;

                                          await allQuizzesController
                                              .getQuizDetails();

                                          if (allQuizzesController
                                              .isQuizBought.value) {
                                            await allQuizzesController
                                                .getMyQuizDetails();
                                            Get.to(
                                                () => MyQuizDetailsPageView());
                                            context.loaderOverlay.hide();
                                          } else {
                                            Get.to(() => QuizDetailsPageView());
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
                                      mainAxisExtent: 185,
                                    ),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: allQuizSearch.length,
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
                                                              "$rootUrl/${allQuizSearch[index].image}"),
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
                                                              Radius.circular(
                                                                  5),
                                                        ),
                                                        child: Container(
                                                          color:
                                                              Color(0xFFD7598F),
                                                          width: 40,
                                                          height: 20,
                                                          alignment:
                                                              Alignment.center,
                                                          child: allQuizSearch[
                                                                          index]
                                                                      .price >
                                                                  0
                                                              ? Text(
                                                                  appCurrency +
                                                                      ' ' +
                                                                      allQuizSearch[
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      courseTitle(allQuizSearch[
                                                                      index]
                                                                  .title[
                                                              '${stctrl.code.value}'] ??
                                                          "${allQuizSearch[index].title['en']}"),
                                                      courseTPublisher(
                                                          allQuizzesController
                                                              .allClass[index]
                                                              .user
                                                              !.name ?? ''),
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        ),
                                        onTap: () async {
                                          context.loaderOverlay.show();
                                          allQuizzesController.courseID.value =
                                              allQuizSearch[index].id;

                                          await allQuizzesController
                                              .getQuizDetails();

                                          if (allQuizzesController
                                              .isQuizBought.value) {
                                            await allQuizzesController
                                                .getMyQuizDetails();
                                            Get.to(
                                                () => MyQuizDetailsPageView());
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
                    })),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
