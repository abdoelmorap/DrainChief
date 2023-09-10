// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// Package imports:

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/edit_profile_controller.dart';
import 'package:lms_flutter_app/utils/widgets/AppBarWidget.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Model/Settings/Languages.dart';

// ignore: must_be_immutable
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final EditProfileController editProfileController =
      Get.put(EditProfileController());

  bool active = true;

  final box = GetStorage();

  @override
  void didChangeDependencies() async {
    stctrl.getAllLanugages().then((value) {
      stctrl.languages.value = value?.languages ?? [];
      stctrl.selectedLanguage.value =
          stctrl.languages.where((p0) => p0.code == stctrl.code.value).first;
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
  }

  void _deleteAccountDialog(BuildContext context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (ctx) {
          return Container(
            child: CupertinoAlertDialog(
              title: Text(
                "${stctrl.lang['Deleting your account is permanent']}",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.red, fontWeight: FontWeight.bold),
              ),
              content: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${stctrl.lang["Are you sure you want to delete your account"]}?",
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "${stctrl.lang['Enter your password']}",
                    ),
                    Material(
                      color: Colors.transparent,
                      child: TextField(
                        obscureText: true,
                        controller: editProfileController.oldPasswordCtrl,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    "${stctrl.lang['Cancel']}",
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (editProfileController.oldPasswordCtrl.text.isEmpty) {
                      return;
                    } else {
                      await editProfileController.deleteAccount().then((value) {
                        if (value) {
                          Navigator.of(ctx).pop();
                          box.erase();
                          Get.back();
                        }
                      });
                    }
                  },
                  child: Text(
                    "${stctrl.lang['Submit']}",
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        appBar: AppBarWidget(
          showSearch: false,
          goToSearch: false,
          showFilterBtn: false,
          showBack: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              editProfileController.dashboardController.loggedIn.value
                  ? ListTile(
                      onTap: () async {
                        Get.bottomSheet(Obx(() {
                          return Material(
                            child: Container(
                              height: Get.height * 0.4,
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "${stctrl.lang["Change Language"]}",
                                        style: Get.textTheme.titleSmall,
                                        textAlign: TextAlign.center,
                                      )),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: Colors.grey.withOpacity(0.2),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: ButtonTheme(
                                        alignedDropdown: true,
                                        child: DropdownButton(
                                          elevation: 1,
                                          isExpanded: true,
                                          underline: Container(),
                                          items: stctrl.languages.map((item) {
                                            return DropdownMenuItem<Language>(
                                              value: item,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Text(
                                                    item.native.toString()),
                                              ),
                                            );
                                          }).toList(),
                                          onChanged: (Language? value) {
                                            stctrl.selectedLanguage.value =
                                                value ?? Language();
                                          },
                                          value: stctrl.selectedLanguage.value,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await stctrl.setLanguage(
                                          langCode: stctrl
                                              .selectedLanguage.value.code);
                                    },
                                    child: Text(
                                      "${stctrl.lang["Confirm"]}",
                                      style: Get.textTheme.titleSmall
                                          ?.copyWith(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }));
                      },
                      leading: Icon(Icons.language),
                      title: Text("${stctrl.lang["Language"]}"),
                    )
                  : SizedBox.shrink(),
              ListTile(
                onTap: () async {
                  final _url = privacyPolicyLink;
                  // ignore: deprecated_member_use
                  await canLaunch(_url)
                      // ignore: deprecated_member_use
                      ? await launch(_url)
                      : throw 'Could not launch $_url';
                },
                leading: Icon(Icons.vpn_key_outlined),
                title: Text("${stctrl.lang["Privacy Policy"]}"),
              ),
              ListTile(
                onTap: () async {
                  final _url =
                      Platform.isIOS ? rateAppLinkiOS : rateAppLinkAndroid;
                  // ignore: deprecated_member_use
                  await canLaunch(_url)
                      // ignore: deprecated_member_use
                      ? await launch(_url)
                      : throw 'Could not launch $_url';
                },
                leading: Icon(Icons.star),
                title: Text("${stctrl.lang["Rate our App"]}"),
              ),
              ListTile(
                onTap: () async {
                  final _url = contactUsLink;
                  // ignore: deprecated_member_use
                  await canLaunch(_url)
                      // ignore: deprecated_member_use
                      ? await launch(_url)
                      : throw 'Could not launch $_url';
                },
                leading: Icon(Icons.mail),
                title: Text("${stctrl.lang['Contact Us']}"),
              ),
              ListTile(
                onTap: () async {
                  _deleteAccountDialog(context);
                },
                leading: Icon(Icons.warning_amber),
                title: Text("${stctrl.lang["Delete account"]}"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
