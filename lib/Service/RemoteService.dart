// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:lms_flutter_app/Model/Quiz/MyQuizResultsModel.dart';
import 'package:lms_flutter_app/Model/Course/CourseMain.dart';
import 'package:lms_flutter_app/Model/User/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Model/Cart/ModelCartList.dart';
import 'package:lms_flutter_app/Model/ModelTopCategory.dart';
import 'package:lms_flutter_app/Model/Cart/PaymentListModel.dart';
import 'package:lms_flutter_app/Model/Quiz/QuestionResultModel.dart';
import 'package:lms_flutter_app/Model/Quiz/QuizStartModel.dart';

class RemoteServices {
  // static var client = http.Client();

  static GetStorage userToken = GetStorage();

// save user token to memory
  String tokenKey = "token";

  Future<void> saveToken(String msg) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(tokenKey, msg);
  }

  static String getJoinMeetingUrlApp({mid}) {
    return 'zoomus://zoom.us/join?confno=$mid'; // android
  }

  static String getJoinMeetingUrlWeb({mid}) {
    return 'https://zoom.us/wc/$mid/join?prefer=1';
  }

// network call for Top category
  static Future<List<TopCategory>?> fetchTopCat() async {
    Uri topCatUrl = Uri.parse(baseUrl + '/top-categories');
    var response = await http.get(topCatUrl, headers: header());
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var courseData = jsonEncode(jsonString['data']);
      return topCategoryFromJson(courseData);
    } else {
      //show error message
      return null;
    }
  }

// network call for Popular course list
  static Future<List<CourseMain>?> fetchpopularCat() async {
    Uri topCatUrl = Uri.parse(baseUrl + '/get-popular-courses');
    var response = await http.get(topCatUrl, headers: header());

    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var courseData = jsonEncode(jsonString['data']);
      return List<CourseMain>.from(
              json.decode(courseData).map((x) => CourseMain.fromJson(x)))
          .where((element) => element.status == 1 || element.status == "1")
          .toList();
    } else {
      //show error message
      return null;
    }
  }

  // network call for All course list
  static Future<List<CourseMain>?> fetchallCourse() async {
    Uri topCatUrl = Uri.parse(baseUrl + '/get-all-courses');
    var response = await http.get(topCatUrl, headers: header());
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var courseData = jsonEncode(jsonString['data']);
      return List<CourseMain>.from(
              json.decode(courseData).map((x) => CourseMain.fromJson(x)))
          .where((element) => element.status == 1 || element.status == "1")
          .toList();
    } else {
      //show error message
      return null;
    }
  }

  static Future<List<CourseMain>?> filterCourse(
      category, level, language, price) async {
    Uri topCatUrl = Uri.parse(baseUrl +
        '/filter-course?category=$category&level=$level&language=$language&price=$price');
    var response = await http.get(topCatUrl, headers: header());
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var courseData = jsonEncode(jsonString['data']);
      return List<CourseMain>.from(
              json.decode(courseData).map((x) => CourseMain.fromJson(x)))
          .where((element) => element.status == 1 || element.status == "1")
          .toList();
    } else {
      //show error message
      return null;
    }
  }

  // network call for All course list
  static Future<List<CourseMain>?> fetchMyCourse(String token) async {
    Uri myCourseUrl = Uri.parse(baseUrl + '/my-courses');

    var response = await http.get(
      myCourseUrl,
      headers: header(token: token),
    );
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var courseData = jsonEncode(jsonString['data']);
      if (json.decode(courseData) != null) {
        return List<CourseMain>.from(
            json.decode(courseData).map((x) => CourseMain.fromJson(x)));
      } else {
        return null;
      }
    } else {
      //show error message
      return null;
    }
  }

// user login
  static Future login(email, password) async {
    Uri loginUrl = Uri.parse(baseUrl + '/login');
    Map data = {"email": email.toString(), "password": password.toString()};
    //encode Map to JSON
    var body = json.encode(data);

    var response = await http.post(loginUrl, headers: header(), body: body);
    var jsonString = jsonDecode(response.body);
    print("data of login :${jsonString['data']}");
    SharedPreferences preferences = await SharedPreferences.getInstance();

      await preferences.setString("loda", jsonString['data']['lodid']);

    if (response.statusCode == 200 && jsonString['success'] == true) {

      return jsonString;
    } else {
      Get.snackbar(
        jsonString['message'],
        "",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        borderRadius: 5,
      );
    }
  }
  static Future register(name, email, phone, password, confirmPassword) async {
    Uri signUpUrl = Uri.parse(baseUrl + '/signup');
    Map data = {
      "name": name.toString(),
      "email": email.toString(),
      "phone": phone.toString(),
      "password": password.toString(),
      "password_confirmation": confirmPassword.toString(),
    };
    //encode Map to JSON
    var body = json.encode(data);
    var response = await http.post(signUpUrl, headers: header(), body: body);
    var jsonString = jsonDecode(response.body);
    if (jsonString['success'] == true) {
      return jsonString;
    } else {
      Get.snackbar(
        jsonString.toString(),
        jsonString['errors'] ?? "",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        borderRadius: 5,
      );
    }
  }

  //get single course data

  static Future<CourseMain?> getCourseDetails(int id) async {
    Uri topCatUrl = Uri.parse(baseUrl + '/get-course-details/$id');
    var response = await http.get(topCatUrl, headers: header());
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var courseData = jsonEncode(jsonString['data']);
      return CourseMain.fromJson(json.decode(courseData));
    } else {
      //show error message
      return null;
    }
  }

  //get My course details

  static Future<CourseMain?> getMyCourseDetails(int id) async {
    Uri topCatUrl = Uri.parse(baseUrl + '/get-course-details/$id');
    var response = await http.get(topCatUrl, headers: header());
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var courseData = jsonEncode(jsonString['data']);
      return CourseMain.fromJson(json.decode(courseData));
    } else {
      //show error message
      return null;
    }
  }

//add to card
  static Future<CourseMain?> addToCard(String token, String courseID) async {
    Uri cartList = Uri.parse(baseUrl + '/add-to-cart/' + courseID);
    var response = await http.get(cartList, headers: header(token: token));
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var courseData = jsonEncode(jsonString['data']);
      return CourseMain.fromJson(json.decode(courseData));
    } else {
      //show error message
      return null;
    }
  }

  //remove to card
  static Future<CourseMain?> removeFromCard(
      String token, String courseID) async {
    Uri cartList = Uri.parse(baseUrl + '/remove-to-cart/' + courseID);
    var response = await http.get(cartList, headers: header(token: token));
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var courseData = jsonEncode(jsonString['data']);
      return CourseMain.fromJson(json.decode(courseData));
    } else {
      //show error message
      return null;
    }
  }

  // view card list

  static Future<List<CartList>?> getCartList(String token) async {
    Uri cartList = Uri.parse(baseUrl + '/cart-list');
    var response = await http.get(
      cartList,
      headers: header(token: token),
    );
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var courseData = jsonEncode(jsonString['data']);
      if (json.decode(courseData) != null) {
        return cartListFromJson(courseData);
      } else {
        return null;
      }
    } else {
      //show error message
      return null;
    }
  }

  //my Course List
  static Future<CartList?> getMyCourseList(String token) async {
    Uri cartList = Uri.parse(baseUrl + '/my-courses');
    var response = await http.get(cartList, headers: header(token: token));
    if (response.statusCode == 200) {
      return null;
    } else {
      //show error message
      return null;
    }
  }

  //payment methode list
  static Future<List<PaymentListModel>?> getPaymentList() async {
    Uri cartList = Uri.parse(baseUrl + '/payment-gateways');
    var response = await http.get(cartList, headers: header());
    print(response.body);
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var courseData = jsonEncode(jsonString['data']);
      return paymentListModelFromJson(courseData);
    } else {
      //show error message
      return null;
    }
  }

  // user profile data
  static Future<User?> getProfile(String token) async {
    Uri userData = Uri.parse(baseUrl + '/user');
    var response = await http.get(
      userData,
      headers: header(token: token),
    );

    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var courseData = jsonEncode(jsonString['data']);
      return userFromJson(courseData);
    } else {
      //show error message
      return null;
    }
  }

  // remove from cart
  static Future<String?> remoteCartRemove(String token, int id) async {
    Uri userData = Uri.parse(baseUrl + '/remove-to-cart/' + id.toString());

    var response = await http.get(
      userData,
      headers: header(token: token),
    );
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var message = jsonEncode(jsonString['message']);
      return message;
    } else {
      //show error message
      return null;
    }
  }

  static Future<dynamic> couponApply(
      {String? token, String? code, dynamic totalAmount}) async {
    Map<String, dynamic> bodyData = {
      'code': code.toString(),
      'total': totalAmount.toString(),
    };
    Uri userData = Uri.parse(baseUrl + '/apply-coupon');
    var body = json.encode(bodyData);
    var response = await http.post(
      userData,
      headers: header(token: token),
      body: body,
    );
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      return jsonString;
    } else {
      //show error message
      return null;
    }
  }

  static Future<List<CourseMain>?> fetchAllClass() async {
    Uri allCourseUrl = Uri.parse(baseUrl + '/get-all-classes');
    var response = await http.get(allCourseUrl, headers: header());
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var courseData = jsonEncode(jsonString['data']);
      return List<CourseMain>.from(
              json.decode(courseData).map((x) => CourseMain.fromJson(x)))
          .where((element) => element.status == 1 || element.status == "1")
          .toList();
    } else {
      //show error message
      return null;
    }
  }

  static Future<List<CourseMain>?> fetchPopularClasses() async {
    Uri allCourseUrl = Uri.parse(baseUrl + '/get-popular-classes');
    var response = await http.get(allCourseUrl, headers: header());
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var courseData = jsonEncode(jsonString['data']);
      return List<CourseMain>.from(
              json.decode(courseData).map((x) => CourseMain.fromJson(x)))
          .where((element) => element.status == 1 || element.status == "1")
          .toList();
    } else {
      //show error message
      return null;
    }
  }

  static Future<CourseMain?> getClassDetails(int id) async {
    Uri topCatUrl = Uri.parse(baseUrl + '/get-class-details/$id');
    var response = await http.get(topCatUrl, headers: header());
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var courseData = jsonEncode(jsonString['data']);
      return CourseMain.fromJson(json.decode(courseData));
    } else {
      //show error message
      return null;
    }
  }

  static Future<List<CourseMain>?> fetchAllMyClass(String token) async {
    Uri allCourseUrl = Uri.parse(baseUrl + '/my-classes');
    var response = await http.get(
      allCourseUrl,
      headers: header(token: token),
    );
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var courseData = jsonEncode(jsonString['data']);
      return List<CourseMain>.from(
              json.decode(courseData).map((x) => CourseMain.fromJson(x)))
          .where((element) => element.status == 1 || element.status == "1")
          .toList();
    } else {
      //show error message
      return null;
    }
  }

  static Future<List<CourseMain>?> fetchAllQuizzes() async {
    Uri url = Uri.parse(baseUrl + '/get-all-quizzes');
    var response = await http.get(url, headers: header());
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var courseData = jsonEncode(jsonString['data']);
      return List<CourseMain>.from(
              json.decode(courseData).map((x) => CourseMain.fromJson(x)))
          .where((element) => element.status == 1 || element.status == "1")
          .toList();
    } else {
      //show error message
      return null;
    }
  }

  static Future<List<CourseMain>?> fetchAllMyQuizzes(String token) async {
    Uri url = Uri.parse(baseUrl + '/my-quizzes');
    var response = await http.get(
      url,
      headers: header(token: token),
    );
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var courseData = jsonEncode(jsonString['data']);
      return List<CourseMain>.from(
              json.decode(courseData).map((x) => CourseMain.fromJson(x)))
          .where((element) => element.status == 1 || element.status == "1")
          .toList();
    } else {
      //show error message
      return null;
    }
  }

  static Future<CourseMain?> getQuizDetails(int id) async {
    Uri url = Uri.parse(baseUrl + '/get-quiz-details/$id');
    var response = await http.get(url, headers: header());
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var courseData = jsonEncode(jsonString['data']);
      return CourseMain.fromJson(json.decode(courseData));
    } else {
      //show error message
      return null;
    }
  }

  static Future<CourseMain?> getLessonQuizDetails(int id) async {
    Uri url = Uri.parse(baseUrl + '/get-lesson-quiz-details/$id');
    var response = await http.get(url, headers: header());
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var courseData = jsonEncode(jsonString['data']);
      return CourseMain.fromJson(json.decode(courseData));
    } else {
      //show error message
      return null;
    }
  }

  static Future<MyQuizResultsModel?> getQuizResult(
      dynamic id, dynamic quizId, String token) async {
    Uri url = Uri.parse(baseUrl + '/quiz-result/$id/$quizId');
    var response = await http.post(
      url,
      headers: header(token: token),
    );
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var courseData = jsonEncode(jsonString);
      return myQuizResultsModelFromJson(courseData);
    } else {
      //show error message
      return null;
    }
  }

  static Future<QuizStartModel?> startQuiz(
      {String? token, dynamic courseId, dynamic quizId}) async {
    Uri url = Uri.parse(baseUrl + '/quiz-start/$courseId/$quizId');
    var response = await http.post(
      url,
      headers: header(token: token),
    );
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var encodedString = jsonEncode(jsonString);
      return quizStartModelFromJson(encodedString);
    } else {
      //show error message
      return null;
    }
  }

  static Future<bool> singleAnswerSubmit({String? token, Map? data}) async {
    Uri url = Uri.parse(baseUrl + '/quiz-single-submit');
    var body = json.encode(data);
    var response = await http.post(
      url,
      headers: header(token: token),
      body: body,
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<QuizResultModel?> questionResult(
      {String? token, int? quizResultId}) async {
    Uri url = Uri.parse(baseUrl + '/quiz-result-preview/$quizResultId');
    var response = await http.post(
      url,
      headers: header(token: token),
    );
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var encodedString = jsonEncode(jsonString);
      return quizResultModelFromJson(encodedString);
    } else {
      return null;
    }
  }

  static Future<bool?> finalQuizSubmit(
      {String? token, int? quizStartId, Map? data}) async {
    Uri url = Uri.parse(baseUrl + '/quiz-final-submit');
    var body = json.encode(data);
    var response = await http.post(
      url,
      headers: header(token: token),
      body: body,
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return null;
    }
  }
}
