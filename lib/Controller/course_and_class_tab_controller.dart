// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:lms_flutter_app/Config/app_config.dart';

// Project imports:
import 'package:lms_flutter_app/Controller/class_controller.dart';
import 'package:lms_flutter_app/Controller/myCourse_controller.dart';
import 'package:lms_flutter_app/Controller/quiz_controller.dart';

class CourseClassQuizTabController extends GetxController
    with GetTickerProviderStateMixin {
  final MyCourseController myCoursesController = Get.put(MyCourseController());

  final ClassController myClassController = Get.put(ClassController());

  final QuizController myQuizController = Get.put(QuizController());

  final List<Tab> myTabs = <Tab>[
    Tab(text: "${stctrl.lang["Courses"]}"),
    Tab(text: "${stctrl.lang["Classes"]}"),
    Tab(text: "${stctrl.lang["Quiz"]}"),
  ];

  TabController? tabController;

  Rx<String> searchText = "${stctrl.lang["courses"]}".obs;

  var isCourse = false.obs;
  var isClass = false.obs;
  var isQuiz = false.obs;

  var myCoursesSearch = [].obs;

  var allMyClassSearch = [].obs;

  var allMyQuizSearch = [].obs;

  var courseSearchStarted = false.obs;

  var classSearchStarted = false.obs;

  var quizSearchStarted = false.obs;

  onCourseSearchTextChanged(String text) async {
    if (tabController?.index == 0) {
      courseSearchStarted.value = true;
      myCoursesSearch.clear();
      if (text.isEmpty) {
        courseSearchStarted.value = false;
        return;
      }

      myCoursesController.myCourses.forEach((value) {
        if (value.title?["${stctrl.code.value}"] != null) {
          if (value.title?["${stctrl.code.value}"]
              .toUpperCase()
              .contains(text.toUpperCase())) {
            myCoursesSearch.add(value);
          }
        } else {
          if (value.title?["en"].toUpperCase().contains(text.toUpperCase())) {
            myCoursesSearch.add(value);
          }
        }
      });
      // searchStarted.value = false;
    } else if (tabController?.index == 1) {
      classSearchStarted.value = true;
      allMyClassSearch.clear();
      if (text.isEmpty) {
        classSearchStarted.value = false;
        return;
      }

      myClassController.allMyClass.forEach((value) {
        if (value.title?["${stctrl.code.value}"] != null) {
          if (value.title?["${stctrl.code.value}"].toUpperCase().contains(
                  text.toUpperCase()) || // search  with course title name
              value.user!.name!.toUpperCase().contains(text.toUpperCase())) {
            allMyClassSearch.add(value);
          }
        } else {
          if (value.title?["en"].toUpperCase().contains(
                  text.toUpperCase()) || // search  with course title name
              value.user!.name!.toUpperCase().contains(text.toUpperCase())) {
            allMyClassSearch.add(value);
          }
        }
      });
    } else if (tabController?.index == 2) {
      quizSearchStarted.value = true;
      allMyQuizSearch.clear();
      if (text.isEmpty) {
        quizSearchStarted.value = false;
        return;
      }

      myQuizController.allMyQuiz.forEach((value) {
        if (value.title?["${stctrl.code.value}"] != null) {
          if (value.title?["${stctrl.code.value}"].toUpperCase().contains(
                  text.toUpperCase()) || // search  with course title name
              value.user!.name!.toUpperCase().contains(text.toUpperCase())) {
            allMyQuizSearch.add(value);
          }
        } else {
          if (value.title?["en"].toUpperCase().contains(
                  text.toUpperCase()) || // search  with course title name
              value.user!.name!.toUpperCase().contains(text.toUpperCase())) {
            allMyQuizSearch.add(value);
          }
        }
      });
    }
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: myTabs.length);
    tabController?.addListener(() async {
      if (tabController!.indexIsChanging && tabController?.index == 0) {
        searchText.value = "${stctrl.lang["courses"]}";
        await myCoursesController.fetchMyCourse();
      } else if (tabController!.indexIsChanging && tabController?.index == 1) {
        searchText.value = "${stctrl.lang["classes"]}";
        await myClassController.fetchAllMyClass();
      } else if (tabController!.indexIsChanging && tabController?.index == 2) {
        searchText.value = "${stctrl.lang["quiz"]}";
        await myQuizController.fetchAllMyQuiz();
      }
    });
  }

  @override
  void onClose() {
    tabController?.dispose();
    super.onClose();
  }
}
