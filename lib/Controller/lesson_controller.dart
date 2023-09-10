import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/myCourse_controller.dart';

class LessonController extends GetxController {
  final MyCourseController myCoursesController = Get.put(MyCourseController());

  var tokenKey = "token";
  GetStorage userToken = GetStorage();

  Future updateLessonProgress(lessonId, courseId, status) async {
    String token = await userToken.read(tokenKey);

    final url = Uri.parse('$baseUrl/lesson-complete');
    Map body = {
      'lesson_id': lessonId,
      'course_id': courseId,
      'status': status,
    };
    http.Response response = await http.post(url,
        headers: header(token: token),
        body: jsonEncode(body));
    if (response.statusCode == 200) {
      myCoursesController.myCourses.value = [];
      await myCoursesController.fetchMyCourse();
      return true;
    } else {
      return false;
    }
  }
}
