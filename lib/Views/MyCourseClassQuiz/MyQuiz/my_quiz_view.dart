// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:

import 'package:get/get.dart';

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/course_and_class_tab_controller.dart';
import 'package:lms_flutter_app/Controller/quiz_controller.dart';
import 'package:lms_flutter_app/utils/widgets/SingleCardItemWidget.dart';
import 'my_quiz_details_view.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';

class MyQuizView extends StatefulWidget {
  const MyQuizView({Key? key}) : super(key: key);

  @override
  _MyQuizViewState createState() => _MyQuizViewState();
}

class _MyQuizViewState extends State<MyQuizView> {
  double width = 0;
  double percentageWidth = 0;
  double height = 0;
  double percentageHeight = 0;

  final QuizController myQuizController = Get.put(QuizController());

  final CourseClassQuizTabController courseAndClassTabController =
      Get.put(CourseClassQuizTabController());

  Future<void> refresh() async {
    myQuizController.allMyQuiz.value = [];
    myQuizController.allClassText.value = "${stctrl.lang["My Quiz"]}";
    myQuizController.courseFiltered.value = false;
    myQuizController.fetchAllMyQuiz();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    percentageWidth = width / 100;
    height = MediaQuery.of(context).size.height;
    percentageHeight = height / 100;
    myQuizController.allClassText.value = "${stctrl.lang["My Quiz"]}";
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
                    child: Texth1(myQuizController.allClassText.value),
                  ),
                  Container(
                      margin: EdgeInsets.only(
                        left: 20,
                        bottom: 50.72,
                        right: 20,
                        top: 10,
                      ),
                      child: Obx(() {
                        if (myQuizController.isLoading.value)
                          return Center(
                            child: CupertinoActivityIndicator(),
                          );
                        else {
                          if (myQuizController.allMyQuiz.length == 0) {
                            return Container(
                              child: Texth1("${stctrl.lang["No Quiz found"]}"),
                            );
                          }
                          if (!courseAndClassTabController
                              .quizSearchStarted.value) {
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
                                itemCount: myQuizController.allMyQuiz.length,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return SingleItemCardWidget(
                                    showPricing: false,
                                    image:
                                        "$rootUrl/${myQuizController.allMyQuiz[index].image}",
                                    title: myQuizController.allMyQuiz[index]
                                            .title?['${stctrl.code.value}'] ??
                                        "${myQuizController.allMyQuiz[index].title?['en']}",
                                    subTitle: myQuizController
                                        .allMyQuiz[index].user?.name ?? '',
                                    price:
                                        myQuizController.allMyQuiz[index].price,
                                    discountPrice: myQuizController
                                        .allMyQuiz[index].discountPrice,
                                    onTap: () async {
                                      myQuizController.courseID.value =
                                          myQuizController.allMyQuiz[index].id;
                                      myQuizController.getMyQuizDetails();
                                      Get.to(() => MyQuizDetailsPageView());
                                    },
                                  );
                                });
                          }
                          return courseAndClassTabController
                                      .allMyQuizSearch.length ==
                                  0
                              ? Text(
                                  "${stctrl.lang["No Quiz found"]}",
                                  style: Get.textTheme.titleMedium,
                                )
                              : Container(
                                  child: GridView.builder(
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 10.0,
                                        mainAxisSpacing: 10.0,
                                        mainAxisExtent: 200,
                                      ),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      itemCount: courseAndClassTabController
                                          .allMyQuizSearch.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return SingleItemCardWidget(
                                          showPricing: false,
                                          image:
                                              "$rootUrl/${courseAndClassTabController.allMyQuizSearch[index].image}",
                                          title: courseAndClassTabController
                                                      .allMyQuizSearch[index]
                                                      .title[
                                                  '${stctrl.code.value}'] ??
                                              "${courseAndClassTabController.allMyQuizSearch[index].title['en']}",
                                          subTitle: courseAndClassTabController
                                              .allMyQuizSearch[index].user.name,
                                          price: courseAndClassTabController
                                              .allMyQuizSearch[index].price,
                                          discountPrice:
                                              courseAndClassTabController
                                                  .allMyQuizSearch[index]
                                                  .discountPrice,
                                          onTap: () async {
                                            myQuizController.courseID.value =
                                                courseAndClassTabController
                                                    .allMyQuizSearch[index].id;
                                            myQuizController.getMyQuizDetails();
                                            Get.to(
                                                () => MyQuizDetailsPageView());
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
        ));
  }
}
