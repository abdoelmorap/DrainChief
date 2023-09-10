// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';
import 'package:lms_flutter_app/Model/User/User.dart';
import 'package:lms_flutter_app/Service/RemoteService.dart';

import '../Model/Settings/Country.dart';
import '../utils/CustomSnackBar.dart';

class EditProfileController extends GetxController {
  final DashboardController dashboardController =
  Get.put(DashboardController());

  var tokenKey = "token";
  GetStorage userToken = GetStorage();

  var profileData = User();

  // var image = File("").obs;
  var isLoading = false.obs;

  var selectedImagePath = "".obs;

  var userImage = "".obs;

  RxList<AllCountry> countryList = <AllCountry>[].obs;
  RxList<AllCountry> cityList = <AllCountry>[].obs;
  RxList<AllCountry> stateList = <AllCountry>[].obs;

  Rx<AllCountry> selectedCountry = AllCountry().obs;
  Rx<AllCountry> selectedCity = AllCountry().obs;
  Rx<AllCountry> selectedState = AllCountry().obs;

  TextEditingController ctFirstName = TextEditingController();
  TextEditingController ctEmail = TextEditingController();
  TextEditingController ctPhone = TextEditingController();
  TextEditingController ctAddress = TextEditingController();
  TextEditingController ctCountry = TextEditingController();
  TextEditingController ctCity = TextEditingController();
  TextEditingController ctState = TextEditingController();
  TextEditingController ctZipCode = TextEditingController();
  TextEditingController ctAbout = TextEditingController();

  TextEditingController oldPasswordCtrl = TextEditingController();

  @override
  void onInit() {
    getProfileData();
    super.onInit();
  }

  Future<User> getProfileData() async {
    String? token = userToken.read(tokenKey) ?? '';
    try {
      isLoading(true);
      var user = await RemoteServices.getProfile(token);
      if (user != null) {
        profileData = user;
        await getCountries().then((value) async {
          value?.forEach((element) {
            if (element.id.toString() == profileData.country.toString()) {
              selectedCountry.value = element;
            }
            // return;
          });
          ctCountry.text = selectedCountry.value.name ?? '';

          if (profileData.state != 0 && profileData.state != null) {
            await getStates(selectedCountry.value.id).then((value) async {
              value?.forEach((element) {
                if (element.id.toString() == profileData.state.toString()) {
                  selectedState.value = element;
                }
                return;
              });
              ctState.text = selectedState.value.name ?? '';

              await getCities(selectedState.value.id).then((value) {
                value?.forEach((element) {
                  if (element.id.toString() == profileData.city.toString()) {
                    selectedCity.value = element;
                  }
                  return;
                });

                ctCity.text = selectedCity.value.name ?? '';
              });
            });
          }
        });

        ctFirstName.text = profileData.name ?? '';
        ctEmail.text = profileData.email ?? '';
        ctPhone.text = profileData.phone ?? '';
        ctAddress.text = profileData.address ?? '';
        ctAbout.text = profileData.about ?? '';
        ctZipCode.text = profileData.zip ?? '';
        userImage.value = profileData.image ?? '';
      }
      isLoading(false);
      return profileData;
    } finally {
      isLoading(false);
    }
  }

  Future getImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowCompression: true,
      onFileLoading: (FilePickerStatus status) {},
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      // image.value = File(pickedFile.path);
      selectedImagePath.value = result.files.first.path ?? '';
    } else {
      CustomSnackBar().snackBarError("${stctrl.lang["No Image selected"]}");
    }
  }

  Future updateProfile(BuildContext context) async {
    var token = await userToken.read(tokenKey);
    var postUri = Uri.parse(baseUrl + '/update-profile');
    var request = new http.MultipartRequest("POST", postUri);
    request.fields['name'] = ctFirstName.text;
    request.fields['email'] = ctEmail.text;
    request.fields['phone'] = ctPhone.text;
    request.fields['address'] = ctAddress.text;
    request.fields['city'] = selectedCity.value.id.toString();
    request.fields['country'] = selectedCountry.value.id.toString();
    request.fields['state'] = selectedState.value.id.toString();
    request.fields['zip'] = ctZipCode.text;
    request.fields['about'] = ctAbout.text;
    request.headers['Content-Type'] = 'application/json';
    request.headers['Accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer ' + '$token';
    request.headers['ApiKey'] = '$apiKey';
    if (selectedImagePath.value != "") {
      http.MultipartFile multipartFile =
      await http.MultipartFile.fromPath('image', selectedImagePath.value);
      request.files.add(multipartFile);
    } else {}
    print(request.fields);

    request
        .send()
        .then((result) async {
      http.Response.fromStream(result).then((response) async {
        var jsonString = jsonDecode(response.body);
        if (response.statusCode == 200) {
          await getProfileData().then((value) {
            dashboardController.profileData = value;
          });
          CustomSnackBar()
              .snackBarSuccess(jsonString['message'].toString());
        } else {
          CustomSnackBar().snackBarError(jsonString['message'].toString());
        }
        return response.body;
      });
    })
        .catchError((err) {
      print('error : ' + err.toString());
    })
        .whenComplete(() {});
  }

  Future<List<AllCountry>?> getCountries() async {
    var token = await userToken.read(tokenKey);
    try {
      Uri myAddressUrl = Uri.parse(baseUrl + '/countries');
      var response = await http.get(
        myAddressUrl,
        headers: header(token: token),
      );
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final country = List<AllCountry>.from(
            jsonString['data'].map((x) => AllCountry.fromJson(x)));

        countryList.value = country;
        return countryList;
      } else {
        CustomSnackBar().snackBarError(jsonString['message'].toString());

        return null;
      }
    } catch (e, t) {
      print(e);
      print(t);
    } finally {}
    return null;
  }

  Future<List<AllCountry>?> getStates(countryId) async {
    var token = await userToken.read(tokenKey);
    try {
      Uri myAddressUrl = Uri.parse(baseUrl + '/states/$countryId');
      var response = await http.get(
        myAddressUrl,
        headers: header(token: token),
      );
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final country = List<AllCountry>.from(
            jsonString['data'].map((x) => AllCountry.fromJson(x)));

        stateList.value = country;

        return stateList;
      } else {
        CustomSnackBar().snackBarError(jsonString['message'].toString());
        return null;
      }
    } finally {}
  }

  Future<List<AllCountry>?> getCities(stateId) async {
    var token = await userToken.read(tokenKey);
    try {
      Uri myAddressUrl = Uri.parse(baseUrl + '/cities/$stateId');
      var response = await http.get(
        myAddressUrl,
        headers: header(token: token),
      );
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final country = List<AllCountry>.from(
            jsonString['data'].map((x) => AllCountry.fromJson(x)));

        cityList.value = country;

        return cityList;
      } else {
        CustomSnackBar().snackBarError(jsonString['message'].toString());
        return null;
      }
    } finally {}
  }

  Future<bool> deleteAccount() async {
    final token = userToken.read('token');
    try {
      var postUri = Uri.parse(baseUrl + '/account-delete');
      var request = new http.MultipartRequest("POST", postUri);
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';
      request.headers['$authHeader'] = '$isBearer' + '$token';
      request.headers['ApiKey'] = '$apiKey';

      request.fields['old_password'] = oldPasswordCtrl.text;

      request.send().then((result) async {
        http.Response.fromStream(result).then((response) {
          var jsonString = jsonDecode(response.body);

          if (jsonString['success'] == false) {
            CustomSnackBar().snackBarError(jsonString['message']);
            return false;
          } else {
            CustomSnackBar().snackBarSuccess(jsonString['message']);
            return true;
          }
        });
      }).catchError((err) {
        print('error : ' + err.toString());
      });
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }
}
