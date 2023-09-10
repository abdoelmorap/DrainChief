// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

// Package imports:

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/edit_profile_controller.dart';
import 'package:lms_flutter_app/utils/widgets/AppBarWidget.dart';

import '../../Model/Settings/Country.dart';
import '../../utils/custom_input_field.dart';

// ignore: must_be_immutable
class EditProfile extends StatefulWidget {
  static GetStorage userToken = GetStorage();

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  // ignore: non_constant_identifier_names
  double icon_size = 16.0;

  // ignore: non_constant_identifier_names
  double hint_font_size = 14.0;

  String tokenKey = "token";

  EditProfileController controller = EditProfileController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Get.delete<EditProfileController>();
    controller = Get.put(EditProfileController());
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<EditProfileController>();
    print('dispose ProfileController');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBarWidget(
          showSearch: false,
          goToSearch: false,
          showFilterBtn: false,
          showBack: true,
        ),
        body: Container(
          child: GetX<EditProfileController>(builder: (_) {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator.adaptive());
            } else {
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: formKey,
                  child: ListView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: controller.selectedImagePath.value == ""
                            ? ClipRRect(
                                clipBehavior: Clip.antiAlias,
                                borderRadius: BorderRadius.circular(100),
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey,
                                  child: FancyShimmerImage(
                                    imageUrl: controller.userImage.value
                                            .contains('public/')
                                        ? "$rootUrl/${controller.userImage.value}"
                                        : "${controller.userImage.value}",
                                    boxFit: BoxFit.cover,
                                    errorWidget: Image.asset(
                                      'assets/images/profile.png',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.black, width: 0.5),
                                  image: DecorationImage(
                                    image: FileImage(File(
                                        controller.selectedImagePath.value)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: GestureDetector(
                            child: Container(
                              alignment: Alignment.center,
                              height: 32,
                              decoration: BoxDecoration(
                                  color: Color(0xff303B58),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                "${stctrl.lang["Choose Image"]}",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                            ),
                            onTap: () {
                              controller.getImage();
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "${stctrl.lang["Basic Information"]}",
                        style: Get.textTheme.titleMedium,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        hintText: "${stctrl.lang["Full Name"]}",
                        obscrureText: false,
                        suffixWidget: Icon(
                          Icons.person,
                          size: icon_size,
                          color: Color.fromRGBO(142, 153, 183, 0.498),
                        ),
                        textEditingController:
                            controller.ctFirstName,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                        hintText: "${stctrl.lang["Email"]}",
                        obscrureText: false,
                        suffixWidget: Icon(
                          Icons.email,
                          size: icon_size,
                          color: Color.fromRGBO(142, 153, 183, 0.498),
                        ),
                        textEditingController:
                            controller.ctEmail,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                        hintText: "${stctrl.lang["Phone Number"]}",
                        obscrureText: false,
                        suffixWidget: Icon(
                          Icons.phone,
                          size: icon_size,
                          color: Color.fromRGBO(142, 153, 183, 0.498),
                        ),
                        textEditingController:
                            controller.ctPhone,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                        hintText: "${stctrl.lang["About"]}",
                        maxLines: 3,
                        obscrureText: false,
                        suffixWidget: Icon(
                          Icons.info,
                          size: icon_size,
                          color: Color.fromRGBO(142, 153, 183, 0.498),
                        ),
                        textEditingController:
                            controller.ctAbout,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "${stctrl.lang["Address Information"]}",
                        style: Get.textTheme.titleMedium,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        maxLines: 2,
                        hintText: "${stctrl.lang["Address"]}",
                        obscrureText: false,
                        suffixWidget: Icon(
                          Icons.location_city,
                          size: icon_size,
                          color: Color.fromRGBO(142, 153, 183, 0.498),
                        ),
                        textEditingController:
                            controller.ctAddress,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "${stctrl.lang["Country"]}",
                        style: Get.textTheme.titleMedium,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Get.textTheme.titleMedium?.color ??
                                  Color(0xFFFFFF),
                              width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        child: DropdownButton(
                          elevation: 1,
                          isExpanded: true,
                          underline: Container(),
                          items: controller.countryList.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(item.name ?? '')),
                            );
                          }).toList(),
                          onChanged: (value) async {
                            controller.selectedCountry.value =
                                (value as AllCountry?)!;

                            await controller
                                .getStates(controller.selectedCountry.value.id)
                                .then((stValue) async {
                              controller.selectedState.value = stValue!.first;

                              await controller
                                  .getCities(controller.selectedState.value.id)
                                  .then((ctValue) {
                                if (ctValue!.isNotEmpty) {
                                  controller.selectedCity.value = ctValue[0];
                                }
                              });
                            });
                          },
                          value: controller.selectedCountry.value,
                        ),
                      ),

                      if (controller.stateList.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "${stctrl.lang["State"]}",
                            style: Get.textTheme.titleMedium,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Get.textTheme.titleMedium?.color ??
                                      Color(0xFFFFFFFF),
                                  width: 1),
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            padding:
                                EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                            child: DropdownButton(
                              elevation: 1,
                              isExpanded: true,
                              underline: Container(),
                              items: controller.stateList.map((item) {
                                return DropdownMenuItem(
                                  value: item,
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(item.name ?? '')),
                                );
                              }).toList(),
                              onChanged: (value) async {

                                AllCountry v=(value as AllCountry);

                                await controller
                                    .getCities(v.id)
                                    .then((ctValue) {
                                  controller.selectedCity.value = ctValue!.first;
                                });
                              },
                              hint: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "Select A State",
                                    style: TextStyle(color: Colors.black),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                              value: controller.selectedState.value,
                            ),
                          ),
                        ],
                      ),
                      controller.cityList.length == 0
                          ? SizedBox.shrink()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "${stctrl.lang["City"]}",
                                  style: Get.textTheme.titleMedium,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                              ],
                            ),
                      controller.cityList.length == 0
                          ? SizedBox.shrink()
                          : Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Get.textTheme.titleMedium?.color ??
                                        Color(0xFFFFFFFF),
                                    width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: DropdownButton(
                                elevation: 1,
                                isExpanded: true,
                                underline: Container(),
                                items: controller.cityList.map((item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(item.name ?? '')),
                                  );
                                }).toList(),
                                onChanged: (value) async {
                                  // controller.selectedCountry.value =
                                  //     (value as AllCountry?)!;

                                },
                                value: controller.selectedCity.value,
                              ),
                            ),
                      SizedBox(
                        height: 20,
                      ),
                      CustomTextField(
                        hintText: "${stctrl.lang["Zip Code"]}",
                        obscrureText: false,
                        suffixWidget: Icon(
                          Icons.location_city,
                          size: icon_size,
                          color: Color.fromRGBO(142, 153, 183, 0.498),
                        ),
                        textEditingController:
                            controller.ctZipCode,
                      ),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top: 30, bottom: 20),
                                height: 46,
                                width: 185,
                                decoration: BoxDecoration(
                                  color: Color(0xff303B58),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  "${stctrl.lang['Update Information']}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                              onTap: () {
                                controller.updateProfile(context);
                              },
                            ),
                            GestureDetector(
                              child: Container(
                                margin: EdgeInsets.only(bottom: 40),
                                child: Text(
                                  "${stctrl.lang['Cancel']}",
                                  style: TextStyle(color: Color(0xff8E99B7)),
                                ),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
        ),
      ),
    );
  }
}
