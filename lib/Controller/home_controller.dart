// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/cart_controller.dart';
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';
import 'package:lms_flutter_app/Controller/myCourse_controller.dart';
import 'package:lms_flutter_app/Model/Course/CourseMain.dart';
import 'package:lms_flutter_app/Model/Course/Lesson.dart';
import 'package:lms_flutter_app/Model/ModelTopCategory.dart';
import 'package:lms_flutter_app/Service/RemoteService.dart';
import 'package:lms_flutter_app/utils/CustomSnackBar.dart';

import '../utils/CustomAlertBox.dart';

class HomeController extends GetxController {
  var selectedLessonID = 0.obs;

  var isLoading = false.obs;

  var isCourseLoading = false.obs;

  var cartAdded = false.obs;

  var isCourseBought = false.obs;

  RxList<TopCategory> topCatList = <TopCategory>[].obs;

  var popularCourseList = [].obs;

  var allClassesList = [].obs;

  var allQuizzesList = [].obs;

  var allCourse = <CourseMain>[].obs;

  var courseDetails = CourseMain().obs;

  GetStorage userToken = GetStorage();

  var filterDrawer = GlobalKey<ScaffoldState>();

  final CartController cartController = Get.put(CartController());

  final DashboardController dashboardController =
      Get.put(DashboardController());

  var tokenKey = "token";

  final TextEditingController reviewText = TextEditingController();

  var allCourseText = "${stctrl.lang["All Courses"]}".obs;

  var courseFiltered = false.obs;

  var courseID = 1.obs;

  var freeCourse = false.obs;

  RxBool isPurchasingIAP = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTopCat();
    fetchPopularCourse();
    fetchAllClass();
    fetchAllCourse();
    fetchAllQuizzes();
  }

  // call api for top category
  void fetchTopCat() async {
    try {
      isLoading(true);
      var products = await RemoteServices.fetchTopCat();
      if (products != null) {
        topCatList.value = products;
      }
    } finally {
      isLoading(false);
    }
  }

// call api for popular course
  void fetchPopularCourse() async {
    try {
      isLoading(true);
      var products = await RemoteServices.fetchpopularCat();
      if (products != null) {
        popularCourseList.value = products;
      }
    } finally {
      isLoading(false);
    }
  }

  // call api for All course
  void fetchAllCourse() async {
    try {
      isLoading(true);
      var products = await RemoteServices.fetchallCourse();
      if (products != null) {
        allCourse.value = products;
      }
    } finally {
      isLoading(false);
    }
  }

  void fetchAllClass() async {
    try {
      isLoading(true);
      var products = await RemoteServices.fetchPopularClasses();
      if (products != null) {
        allClassesList.value = products;
      }
    } finally {
      isLoading(false);
    }
  }

  void fetchAllQuizzes() async {
    try {
      isLoading(true);
      var products = await RemoteServices.fetchAllQuizzes();
      if (products != null) {
        allQuizzesList.value = products;
      }
    } finally {
      isLoading(false);
    }
  }

  Future<String> addToCart(String courseId) async {
    final CartController cartController = Get.put(CartController());

    Uri addToCartUrl = Uri.parse(baseUrl + '/add-to-cart/$courseID');
    var token = userToken.read(tokenKey);
    var response = await http.get(
      addToCartUrl,
      headers: header(token: token),
    );
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var message = jsonEncode(jsonString['message']);
      showCustomAlertDialog(
          "${stctrl.lang["Status"]}", message, "${stctrl.lang["View Cart"]}");
      cartController.getCartList();
      courseID.value = courseDetails.value.id;
      getCourseDetails();
      Get.back();
      return message;
    } else {
      //show error message
      return "Somthing Wrong";
    }
  }

  Future<bool> buyNow(int courseId) async {
    Uri addToCartUrl = Uri.parse(baseUrl + '/buy-now');
    var token = userToken.read(tokenKey);
    var response = await http.post(
      addToCartUrl,
      body: jsonEncode({'id': courseId}),
      headers: header(token: token),
    );
    if (response.statusCode == 200) {
      print(response.body);
      var jsonString = jsonDecode(response.body);
      var message = jsonEncode(jsonString['message']);

      CustomSnackBar().snackBarSuccess(message);

      final MyCourseController myCoursesController =
          Get.put(MyCourseController());

      myCoursesController.myCourses.value = [];
      await myCoursesController.fetchMyCourse();

      return true;
    } else {
      return false;
    }
  }

  Future<bool> enrollIAP(int courseId) async {
    Uri addToCartUrl = Uri.parse(baseUrl + '/enroll-iap');
    var token = userToken.read(tokenKey);
    var response = await http.post(
      addToCartUrl,
      body: jsonEncode({'id': courseId}),
      headers: header(token: token),
    );
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var message = jsonEncode(jsonString['message']);
      print(message);

      // CustomSnackBar().snackBarSuccess(message);

      final MyCourseController myCoursesController =
          Get.put(MyCourseController());

      myCoursesController.myCourses.value = [];
      await myCoursesController.fetchMyCourse();

      return true;
    } else {
      return false;
    }
  }

  // get course details
  Future getCourseDetails() async {
    try {
      isCourseLoading(true);
      await RemoteServices.getCourseDetails(courseID.value).then((value) async {
        cartAdded(false);
        await cartController.getCartList().then((value2) {
          value2?.forEach((element) {
            if (element.courseId.toString() ==
                courseID.value.toString()) {
              cartAdded(true);
            }
          });
        });
        if (value?.enrolls != null) {
          isCourseBought(false);
          value?.enrolls?.forEach((element) {
            if (element.userId == dashboardController.profileData.id) {
              isCourseBought(true);
            }
          });
        }
        courseDetails.value = value ?? CourseMain();
      });
      return courseDetails.value;
    } catch(e, t){
      print(e);
      print(t);
    } finally {
      isCourseLoading(false);
    }
  }

  void submitCourseReview(courseId, review, rating) async {
    String token = await userToken.read(tokenKey);

    var postUri = Uri.parse(baseUrl + '/submit-review');
    var request = new http.MultipartRequest("POST", postUri);
    request.headers['Content-Type'] = 'application/json';
    request.headers['Accept'] = 'application/json';
    request.headers['$authHeader'] = '$isBearer' + '$token';
    request.headers['ApiKey'] = '$apiKey';

    request.fields['course_id'] = courseId.toString();
    request.fields['review'] = review;
    request.fields['rating'] = rating.toString();

    request
        .send()
        .then((result) async {
          http.Response.fromStream(result).then((response) {
            var jsonString = jsonDecode(response.body);
            if (jsonString['success'] == false) {
              CustomSnackBar().snackBarError(jsonString['message']);
            } else {
              CustomSnackBar().snackBarError(jsonString['message']);

              Get.back();
              getCourseDetails();
              reviewText.text = "";
            }
            return response.body;
          });
        })
        .catchError((err) {
      print('error : ' + err.toString());
    })
        .whenComplete(() {});
  }

  Future<List<Lesson>?> getLessons(int courseId, int chapterId) async {
    var client = http.Client();

    try {
      Uri topCatUrl =
          Uri.parse(baseUrl + '/get-course-details/' + courseId.toString());
      var response = await client.get(topCatUrl);
      if (response.statusCode == 200) {
        var jsonString = jsonDecode(response.body);
        var courseData = jsonEncode(jsonString['data']['lessons']);

        return List<Lesson>.from(
                json.decode(courseData).map((x) => Lesson.fromJson(x)))
            .where((element) => element.chapterId == chapterId)
            .toList();
      } else {
        //show error message
        return null;
      }
    } finally {}
  }

  void filterCourse(category, level, language, price) async {
    try {
      isLoading(true);
      allCourse.value = <CourseMain>[].obs;
      var products =
          await RemoteServices.filterCourse(category, level, language, price);
      if (products != null) {
        courseFiltered(true);
        allCourseText.value =
            products.length.toString() + " " + "${stctrl.lang["Course found"]}";
        allCourse.value = products;
      }
    } finally {
      isLoading(false);
    }
  }
}
