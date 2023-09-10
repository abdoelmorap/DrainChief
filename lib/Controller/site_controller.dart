import 'dart:convert';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';
import 'package:http/http.dart' as http;
import 'package:lms_flutter_app/Model/Settings/Languages.dart';

import '../Model/Settings/LanguageData.dart';

class SiteController extends GetxController {
  GetStorage userToken = GetStorage();

  String tokenKey = "token";

  final DashboardController dashboardController =
      Get.put(DashboardController());

  RxString code = "".obs;

  RxBool isLanguageLoading = false.obs;

  final lang = RxMap();

  final rtl = RxBool(false);

  Rx<Language> selectedLanguage = Language().obs;

  RxList<Language> languages = <Language>[].obs;

  Future getLanguage({String? langCode}) async {
    dashboardController.isLoading(true);

    var token = userToken.read(tokenKey);

    String url = langCode == null
        ? "$baseUrl/get-lang"
        : "$baseUrl/get-lang?code=$langCode";
    print(url);
    var response = await http.get(
      Uri.parse(url),
      headers: header(token: token),
    );

    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var courseData = jsonEncode(jsonString['data']);
      final data = LanguageData.fromJson(json.decode(courseData));

      code.value = data.code ?? '';
      lang.value = data.lang ?? Map();

      if (data.rtl == "1") {
        rtl.value = true;
      } else {
        rtl.value = false;
      }

      Get.updateLocale(Locale('${code.value}'));

      dashboardController.isLoading(false);
    } else {
      dashboardController.isLoading(false);
      code.value = "";
    }
  }

  Future<LanguageList?> getAllLanugages() async {
    try {
      var token = userToken.read(tokenKey);
      Uri myAddressUrl = Uri.parse(baseUrl + '/languages');
      var response = await http.get(
        myAddressUrl,
        headers: header(token: token),
      );
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return LanguageList.fromJson(jsonString['data']);
      } else {
        return null;
      }
    } finally {}
  }

  Future setLanguage({String? langCode}) async {
    dashboardController.isLoading(true);

    var token = userToken.read(tokenKey);
    var response = await http.post(Uri.parse(baseUrl + '/set-lang'),
        body: jsonEncode({
          'lang': langCode,
        }),
        headers: header(token: token));

    if (response.statusCode == 200) {
      await getLanguage();

      Get.updateLocale(Locale('${code.value}'));

      dashboardController.isLoading(false);
    } else {
      dashboardController.isLoading(false);
      code.value = "";
    }
  }

  @override
  void onInit() {
    getLanguage();
    getAllLanugages();
    super.onInit();
  }
}
