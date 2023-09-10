// Dart imports:
// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Model/Course/CourseMain.dart';
import 'package:lms_flutter_app/Model/Quiz/MyQuizResultsModel.dart';
import 'package:lms_flutter_app/Model/Quiz/QuizStartModel.dart';
import 'package:lms_flutter_app/Service/RemoteService.dart';
import 'package:lms_flutter_app/utils/CustomSnackBar.dart';

import '../utils/CustomAlertBox.dart';
import 'cart_controller.dart';
import 'dashboard_controller.dart';

class QuizController extends GetxController {
  final CartController cartController = Get.put(CartController());

  final DashboardController dashboardController =
      Get.put(DashboardController());

  final TextEditingController commentController = TextEditingController();

  var isLoading = false.obs;

  var isQuizLoading = false.obs;

  var cartAdded = false.obs;

  var isQuizBought = false.obs;

  var allClass = <CourseMain>[].obs;

  var allMyQuiz = <CourseMain>[].obs;

  var allClassText = "${stctrl.lang["All Quiz"]}".obs;

  var courseFiltered = false.obs;

  GetStorage userToken = GetStorage();

  var tokenKey = "token";

  var courseID = 1.obs;

  var quizDetails = CourseMain().obs;

  var myQuizDetails = CourseMain().obs;

  var myQuizResult = MyQuizResultsModel().obs;

  var quizStart = QuizStartModel().obs;

  var isQuizStarting = false.obs;

  final TextEditingController reviewText = TextEditingController();

  var lessonQuizId = 1.obs;

  RxBool isPurchasingIAP = false.obs;

  void fetchAllClass() async {
    try {
      isLoading(true);
      var courses = await RemoteServices.fetchAllQuizzes();
      if (courses != null) {
        allClass.value = courses;
      }
    } finally {
      isLoading(false);
    }
  }

  Future getQuizDetails() async {
    String token = userToken.read(tokenKey)??'';
    try {
      isQuizLoading(true);
      await RemoteServices.getQuizDetails(courseID.value).then((value) async {
        if (value != null) {
          if (token != null) {
            cartAdded(false);
            await cartController.getCartList().then((value) {
              if (value != null) {
                value.forEach((element) {
                  if (element.courseId.toString() ==
                      courseID.value.toString()) {
                    cartAdded(true);
                  }
                });
              }
            });
            if (value.enrolls != null) {
              isQuizBought(false);
              value.enrolls?.forEach((element) {
                if (element.userId == dashboardController.profileData.id) {
                  isQuizBought(true);
                }
              });
            }
          }
        }
        quizDetails.value = value ?? CourseMain();
      });
      return quizDetails.value;
    } finally {
      isQuizLoading(false);
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
      courseID.value = quizDetails.value.id;
      getQuizDetails();
      Get.back();
      return message;
    } else {
      //show error message
      return "Somthing Wrong";
    }
  }

  Future<bool> buyNow(String courseId) async {
    Uri addToCartUrl = Uri.parse(baseUrl + '/buy-now');
    var token = userToken.read(tokenKey);
    var response = await http.post(
      addToCartUrl,
      body: jsonEncode({'id': courseId}),
      headers: header(token: token),
    );
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var message = jsonEncode(jsonString['message']);

      CustomSnackBar().snackBarSuccess(message);

      final QuizController myQuizController = Get.put(QuizController());

      myQuizController.allMyQuiz.value = [];
      myQuizController.allClassText.value = "${stctrl.lang["My Quiz"]}";
      myQuizController.courseFiltered.value = false;
      await myQuizController.fetchAllMyQuiz();

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

      allMyQuiz.value = [];
      await fetchAllMyQuiz();

      return true;
    } else {
      return false;
    }
  }

  Future getMyQuizDetails() async {
    try {
      isQuizLoading(true);
      await RemoteServices.getQuizDetails(courseID.value).then((value) async {
        myQuizDetails.value = value ?? CourseMain();
        await getMyQuizResults();
      });
      return myQuizDetails.value;
    } finally {
      isQuizLoading(false);
    }
  }

  Future getMyQuizResults() async {
    String token = await userToken.read(tokenKey);
    try {
      isQuizLoading(true);
      await RemoteServices.getQuizResult(
              myQuizDetails.value.id, myQuizDetails.value.quizId, token)
          .then((value) async {
        myQuizResult.value = value ?? MyQuizResultsModel();
      });
      return myQuizResult.value;
    } finally {
      isQuizLoading(false);
    }
  }

  void submitCourseReview(courseId, review, rating) async {
    String token = await userToken.read(tokenKey);

    var postUri = Uri.parse(baseUrl + '/submit-review');
    var request = new http.MultipartRequest("POST", postUri);
    request.headers['Content-Type'] = 'application/json';
    request.headers['Accept'] = 'application/json';
    request.headers['Authorization'] = ' $token';
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
              getQuizDetails();
              reviewText.text = "";
            }
            return response.body;
          });
        })
        .catchError((err) {
      print('error : ' + err.toString());
    } )
        .whenComplete(() {});
  }

  Future fetchAllMyQuiz() async {
    String token = userToken.read(tokenKey) ?? '';
    try {
      isLoading(true);
      var courses = await RemoteServices.fetchAllMyQuizzes(token);
      if (courses != null) {
        allMyQuiz.value = courses;
      }
    } finally {
      isLoading(false);
    }
  }

  Future<bool> startQuiz() async {
    try {
      var returnValue = false;
      String token = await userToken.read(tokenKey);
      isQuizStarting(true);
      await RemoteServices.startQuiz(
              token: token,
              courseId: myQuizDetails.value.id,
              quizId: myQuizDetails.value.quizId)
          .then((value) async {
        if (value?.result == true) {
          isQuizStarting(false);
          quizStart.value = value ?? QuizStartModel();
          returnValue = true;
          return returnValue;
        } else {
          isQuizStarting(false);
          returnValue = false;
          return returnValue;
        }
      });
      return returnValue;
    } finally {
      isQuizStarting(false);
    }
  }

  Future<bool> startQuizFromLesson() async {
    try {
      var returnValue = false;
      String token = await userToken.read(tokenKey);
      isQuizStarting(true);
      await RemoteServices.startQuiz(
        token: token,
        courseId: courseID.value,
        quizId: lessonQuizId.value,
      ).then((value) async {
        if (value?.result == true) {
          isQuizStarting(false);
          quizStart.value = value ?? QuizStartModel();
          returnValue = true;
          return returnValue;
        } else {
          isQuizStarting(false);
          returnValue = false;
          return returnValue;
        }
      });
      return returnValue;
    } finally {
      isQuizStarting(false);
    }
  }

  Future getLessonQuizDetails() async {
    try {
      isQuizLoading(true);
      await RemoteServices.getLessonQuizDetails(lessonQuizId.value)
          .then((value) async {
        myQuizDetails.value = value ?? CourseMain();
      });
      return myQuizDetails.value;
    } finally {
      isQuizLoading(false);
    }
  }

  void submitComment(courseId, comment) async {
    String token = await userToken.read(tokenKey);

    var postUri = Uri.parse(baseUrl + '/comment');
    var request = new http.MultipartRequest("POST", postUri);
    request.headers['Content-Type'] = 'application/json';
    request.headers['Accept'] = 'application/json';
    request.headers['$authHeader'] = '$isBearer' + '$token';
    request.headers['ApiKey'] = '$apiKey';

    request.fields['course_id'] = courseId.toString();
    request.fields['comment'] = comment;
    request
        .send()
        .then((result) async {
          http.Response.fromStream(result).then((response) {
            var jsonString = jsonDecode(response.body);
            if (jsonString['success'] == false) {
              CustomSnackBar().snackBarError(jsonString['message']);
            } else {
              CustomSnackBar().snackBarSuccess(jsonString['message']);
              getMyQuizDetails();
              commentController.text = "";
            }
            return response.body;
          });
        })
        .catchError((err) {
      print('error : ' + err.toString());
    } )
        .whenComplete(() {});
  }

  @override
  void onInit() {
    fetchAllClass();
    fetchAllMyQuiz();
    super.onInit();
  }
}
