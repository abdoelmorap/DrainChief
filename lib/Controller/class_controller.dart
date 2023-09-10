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
import 'package:lms_flutter_app/Model/Course/CourseMain.dart';
import 'package:lms_flutter_app/Service/RemoteService.dart';
import 'package:lms_flutter_app/utils/CustomSnackBar.dart';
import '../utils/CustomAlertBox.dart';
import 'cart_controller.dart';
import 'dashboard_controller.dart';

class ClassController extends GetxController {
  final CartController cartController = Get.put(CartController());

  final DashboardController dashboardController =
      Get.put(DashboardController());

  var isLoading = false.obs;

  var isClassLoading = false.obs;

  var cartAdded = false.obs;

  var isClassBought = false.obs;

  var allClass = <CourseMain>[].obs;

  var allMyClass = <CourseMain>[].obs;

  var allClassText = "${stctrl.lang["All Class"]}".obs;

  var courseFiltered = false.obs;

  GetStorage userToken = GetStorage();

  var tokenKey = "token";

  var courseID = 1.obs;

  var classDetails = CourseMain().obs;

  final TextEditingController reviewText = TextEditingController();

  RxBool isPurchasingIAP = false.obs;

  void fetchAllClass() async {
    try {
      isLoading(true);
      var courses = await RemoteServices.fetchAllClass();
      if (courses != null) {
        allClass.value = courses;
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
      courseID.value = classDetails.value.id;
      getClassDetails();
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
      var jsonString = jsonDecode(response.body);
      var message = jsonEncode(jsonString['message']);
      print(message);
      allMyClass.value = [];
      allClassText.value = "${stctrl.lang["My Class"]}";
      courseFiltered.value = false;
      await fetchAllMyClass();

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

      allMyClass.value = [];
      await fetchAllMyClass();

      return true;
    } else {
      return false;
    }
  }

  Future getClassDetails() async {
    try {
      isClassLoading(true);
      await RemoteServices.getClassDetails(courseID.value).then((value) async {
        cartAdded(false);
        await cartController.getCartList().then((value) {
          value?.forEach((element) {
            if (element.courseId.toString() ==
                courseID.value.toString()) {
              cartAdded(true);
            }
          });
        });
        if (value?.enrolls != null) {
          isClassBought(false);
          value?.enrolls?.forEach((element) {
            if (element.userId == dashboardController.profileData.id) {
              isClassBought(true);
            }
          });
        }
        classDetails.value = value ?? CourseMain();
      });
      return classDetails.value;
    } finally {
      isClassLoading(false);
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
              getClassDetails();
              reviewText.text = "";
            }
            return response.body;
          });
        })
        .catchError((err, t){
          print(err);
          print(t);
    })
        .whenComplete(() {});
  }

  Future fetchAllMyClass() async {
    String token = await userToken.read(tokenKey);
    try {
      isLoading(true);
      var courses = await RemoteServices.fetchAllMyClass(token);
      allMyClass.value = courses ?? [];
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    fetchAllClass();
    fetchAllMyClass();
    super.onInit();
  }
}
