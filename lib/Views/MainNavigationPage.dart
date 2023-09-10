// Flutter imports:
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// Package imports:

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';
import 'package:lms_flutter_app/Service/theme_service.dart';
import 'package:lms_flutter_app/Views/Account/change_password.dart';
import 'package:lms_flutter_app/Views/Account/edit_profile.dart';
import 'package:lms_flutter_app/Views/Account/sign_in_page.dart';
import 'package:lms_flutter_app/Views/Cart/cart_page.dart';
import 'package:lms_flutter_app/Views/Home/home_page.dart';
import 'package:lms_flutter_app/Views/MyCourseClassQuiz/CourseClassQuiz.dart';
import 'package:lms_flutter_app/Views/SettingsPage.dart';
import 'package:lms_flutter_app/utils/styles.dart';
import 'package:lms_flutter_app/utils/widgets/connectivity_checker_widget.dart';
// import 'package:lms_flutter_app/utils/widgets/persistant_bottom_custom/persistent-tab-view.dart';
import 'package:octo_image/octo_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'Downloads/DownloadsFolder.dart';

class MainNavigationPage extends StatefulWidget {
  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final DashboardController dashboardController =
      Get.put(DashboardController());

  List<PersistentBottomNavBarItem> items() {
    if (Platform.isIOS) {
      return [
        PersistentBottomNavBarItem(
          inactiveIcon: SvgPicture.asset(
            "images/icon_home_inactive.svg",
            color: AppStyles.bottomNavigationInActiveColor,
          ),
          icon: SvgPicture.asset(
            "images/icon_home_active.svg",
            color: AppStyles.bottomNavigationActiveColor,
          ),
          title: stctrl.lang['Home'],
          activeColorPrimary: AppStyles.bottomNavigationActiveColor,
          inactiveColorPrimary: AppStyles.bottomNavigationInActiveColor,
        ),
        PersistentBottomNavBarItem(
          inactiveIcon: SvgPicture.asset(
            "images/icon_course_inactive.svg",
            color: AppStyles.bottomNavigationInActiveColor,
          ),
          icon: SvgPicture.asset(
            "images/icon_course_active.svg",
            color: AppStyles.bottomNavigationActiveColor,
          ),
          title: stctrl.lang["Dashboard"],
          activeColorPrimary: AppStyles.bottomNavigationActiveColor,
          inactiveColorPrimary: AppStyles.bottomNavigationInActiveColor,
        ),
        PersistentBottomNavBarItem(
          inactiveIcon: SvgPicture.asset(
            "images/icon_account_inactive.svg",
            color: AppStyles.bottomNavigationInActiveColor,
          ),
          icon: SvgPicture.asset(
            "images/icon_account_active.svg",
            color: AppStyles.bottomNavigationActiveColor,
          ),
          title: stctrl.lang["Account"],
          activeColorPrimary: AppStyles.bottomNavigationActiveColor,
          inactiveColorPrimary: AppStyles.bottomNavigationInActiveColor,
        ),
      ];
    }
    return [
      PersistentBottomNavBarItem(
        inactiveIcon: SvgPicture.asset(
          "images/icon_home_inactive.svg",
          color: AppStyles.bottomNavigationInActiveColor,
        ),
        icon: SvgPicture.asset(
          "images/icon_home_active.svg",
          color: AppStyles.bottomNavigationActiveColor,
        ),
        title: stctrl.lang['Home'],
        activeColorPrimary: AppStyles.bottomNavigationActiveColor,
        inactiveColorPrimary: AppStyles.bottomNavigationInActiveColor,
      ),
      PersistentBottomNavBarItem(
        inactiveIcon: SvgPicture.asset(
          "images/icon_cart_inactive.svg",
          color: AppStyles.bottomNavigationInActiveColor,
        ),
        icon: SvgPicture.asset(
          "images/icon_cart_active.svg",
          color: AppStyles.bottomNavigationActiveColor,
        ),
        title: stctrl.lang["Cart"],
        activeColorPrimary: AppStyles.bottomNavigationActiveColor,
        inactiveColorPrimary: AppStyles.bottomNavigationInActiveColor,
      ),
      PersistentBottomNavBarItem(
        inactiveIcon: SvgPicture.asset(
          "images/icon_course_inactive.svg",
          color: AppStyles.bottomNavigationInActiveColor,
        ),
        icon: SvgPicture.asset(
          "images/icon_course_active.svg",
          color: AppStyles.bottomNavigationActiveColor,
        ),
        title: stctrl.lang["Dashboard"],
        activeColorPrimary: AppStyles.bottomNavigationActiveColor,
        inactiveColorPrimary: AppStyles.bottomNavigationInActiveColor,
      ),
      PersistentBottomNavBarItem(
        inactiveIcon: SvgPicture.asset(
          "images/icon_account_inactive.svg",
          color: AppStyles.bottomNavigationInActiveColor,
        ),
        icon: SvgPicture.asset(
          "images/icon_account_active.svg",
          color: AppStyles.bottomNavigationActiveColor,
        ),
        title: stctrl.lang["Account"],
        activeColorPrimary: AppStyles.bottomNavigationActiveColor,
        inactiveColorPrimary: AppStyles.bottomNavigationInActiveColor,
      ),
    ];
  }

  List<Widget> _screens(controller) {
    if (Platform.isIOS) {
      return [
        HomePage(),
        controller.loggedIn.value ? CourseAndClass() : SignInPage(),
        controller.loggedIn.value ? HomePage() : SignInPage(),
      ];
    }
    return [
      HomePage(),
      controller.loggedIn.value ? CartPage() : SignInPage(),
      controller.loggedIn.value ? CourseAndClass() : SignInPage(),
      controller.loggedIn.value ? HomePage() : SignInPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ConnectionCheckerWidget(
      child: Obx(() {
        if (dashboardController.isLoading.value) {
          return Scaffold(body: Center(child: CupertinoActivityIndicator()));
        } else {
          return SafeArea(
            child: Scaffold(
              key: stctrl.dashboardController.scaffoldKey,
              drawerScrimColor: Colors.black.withOpacity(0.7),
              onEndDrawerChanged: (isOpened) {
                if (!isOpened) {
                  if (!stctrl.dashboardController.loggedIn.value) {
                    stctrl.dashboardController.persistentTabController
                        .jumpToTab(2);
                  } else {
                    stctrl.dashboardController.persistentTabController
                        .jumpToTab(0);
                  }
                }
              },
              endDrawer: CustomDrawer(),
              body: GestureDetector(
                onTap: () {
                  Get.focusScope?.unfocus();
                },
                child: PersistentTabView(
                  context,
                  controller: dashboardController.persistentTabController,
                  screens: _screens(stctrl.dashboardController),
                  items: items(),
                  hideNavigationBar: false,
                  navBarHeight: 70,
                  margin: EdgeInsets.all(0),
                  padding: NavBarPadding.symmetric(horizontal: 5),
                  onItemSelected: stctrl.dashboardController.changeTabIndex,
                  confineInSafeArea: true,
                  backgroundColor: context.theme.scaffoldBackgroundColor,
                  handleAndroidBackButtonPress: true,
                  resizeToAvoidBottomInset: true,
                  stateManagement: true,
                  hideNavigationBarWhenKeyboardShows: true,
                  decoration: NavBarDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    colorBehindNavBar: context.theme.scaffoldBackgroundColor,
                  ),
                  popAllScreensOnTapOfSelectedTab: true,
                  popActionScreens: PopActionScreensType.all,
                  itemAnimationProperties: ItemAnimationProperties(
                    duration: Duration(milliseconds: 200),
                    curve: Curves.ease,
                  ),
                  screenTransitionAnimation: ScreenTransitionAnimation(
                    animateTabTransition: false,
                    curve: Curves.ease,
                    duration: Duration(milliseconds: 200),
                  ),
                  navBarStyle: NavBarStyle.style6,
                ),
              ),
            ),
          );
        }
      }),
    );
  }
}

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: stctrl.dashboardController.loggedIn.value
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.arrow_back_ios_new),
                    ),
                    Container(
                        child: Text(
                      "${stctrl.lang["Account"]}",
                      style: Get.textTheme.titleMedium,
                    )),
                  ],
                ),
                Row(
                  children: [
                    Obx(() {
                      if (stctrl.dashboardController.isLoading.value) {
                        return Container(
                          margin: EdgeInsets.only(
                              left: 20, top: 20, bottom: 30, right: 20),
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: ClipOval(
                            child: OctoImage(
                              fit: BoxFit.cover,
                              height: 40,
                              width: 40,
                              image: AssetImage('images/fcimg.png'),
                              placeholderBuilder: OctoPlaceholder.blurHash(
                                'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          margin: EdgeInsets.only(
                            left: 20,
                            top: 20,
                            bottom: 30,
                            right: 20,
                          ),
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: ClipOval(
                            child:
                                stctrl.dashboardController.profileData.image !=
                                        null
                                    ? OctoImage(
                                        fit: BoxFit.cover,
                                        height: 40,
                                        width: 40,
                                        image: stctrl.dashboardController
                                                .profileData.image
                                                !.contains('public/')
                                            ? NetworkImage(
                                                "$rootUrl/${stctrl.dashboardController.profileData.image}")
                                            : NetworkImage(
                                                "$rootUrl/${stctrl.dashboardController.profileData.image}"),
                                        placeholderBuilder:
                                            OctoPlaceholder.blurHash(
                                          'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                        ),
                                      )
                                    : Container(),
                          ),
                        );
                      }
                    }),
                    Obx(() {
                      if (stctrl.dashboardController.isLoading.value) {
                        return Container();
                      } else {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stctrl.dashboardController.profileData.name ??
                                    '',
                                style: Get.textTheme.titleSmall,
                              ),
                              Platform.isIOS
                                  ? SizedBox.shrink()
                                  : Text(
                                      appCurrency +
                                              ' ' +
                                              stctrl.dashboardController
                                                  .profileData.balance
                                                  .toString(),
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xff8E99B7)),
                                    ),
                            ],
                          ),
                        );
                      }
                    })
                  ],
                ),
                GestureDetector(
                  child: drawerListItem("images/icon_person.svg",
                      "${stctrl.lang["Edit Profile"]}"),
                  onTap: () {
                    stctrl.dashboardController.scaffoldKey.currentState
                        ?.openDrawer();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfile(),
                        ));
                  },
                ),
                GestureDetector(
                  child: drawerListItem("images/icon_key.svg",
                      "${stctrl.lang["Change Password"]}"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePassword(),
                        ));
                  },
                ),
                showDownloadsFolder
                    ? GestureDetector(
                        onTap: () async {
                          Directory applicationSupportDir =
                              await getApplicationSupportDirectory();
                          String path = applicationSupportDir.path;

                          Get.to(() => DownloadsFolder(
                              filePath: path,
                              title: "${stctrl.lang["My Downloads"]}"));
                        },
                        child: Container(
                          padding:
                              EdgeInsets.only(left: 20, top: 12.5, bottom: 10),
                          margin: EdgeInsets.only(
                              left: 20, right: 30, top: 5, bottom: 5),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Get.theme.cardColor,
                            boxShadow: [
                              BoxShadow(
                                color: Get.theme.shadowColor,
                                blurRadius: 10.0,
                                offset: Offset(2, 3),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 6,
                              ),
                              Icon(
                                Icons.downloading_rounded,
                                color: Get.theme.primaryColor,
                                size: 18,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "${stctrl.lang["Downloads"]}",
                                style: Get.textTheme.titleSmall,
                              ),
                              Expanded(child: Container()),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
                GestureDetector(
                  onTap: ThemeService().switchTheme,
                  child: Container(
                    padding: EdgeInsets.only(left: 20, top: 12.5, bottom: 10),
                    margin:
                        EdgeInsets.only(left: 20, right: 30, top: 5, bottom: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Get.theme.cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Get.theme.shadowColor,
                          blurRadius: 10.0,
                          offset: Offset(2, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 6,
                        ),
                        Icon(
                          Get.theme.brightness == Brightness.dark
                              ? Icons.dark_mode_outlined
                              : Icons.light_mode_outlined,
                          color: Get.theme.primaryColor,
                          size: 18,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          Get.theme.brightness == Brightness.dark
                              ? "${stctrl.lang["Light Theme"]}"
                              : "${stctrl.lang["Dark Theme"]}",
                          style: Get.textTheme.titleSmall,
                        ),
                        Expanded(child: Container()),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    Get.to(() => SettingsPage());
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 20, top: 12.5, bottom: 10),
                    margin:
                        EdgeInsets.only(left: 20, right: 30, top: 5, bottom: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Get.theme.cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Get.theme.shadowColor,
                          blurRadius: 10.0,
                          offset: Offset(2, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 6,
                        ),
                        Icon(
                          Icons.settings,
                          color: Get.theme.primaryColor,
                          size: 18,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${stctrl.lang["Settings"]}",
                          style: Get.textTheme.titleSmall,
                        ),
                        Expanded(child: Container()),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  child: drawerListItem(
                    "images/icon_signout.svg",
                    "${stctrl.lang["Sign Out"]}",
                  ),
                  onTap: () async {
                    await stctrl.dashboardController.removeToken('token');
                  },
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.arrow_back_ios_new),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    "${stctrl.lang["Account"]}",
                    style: Get.textTheme.titleMedium,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          left: 20, top: 20, bottom: 30, right: 20),
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: ClipOval(
                        child: OctoImage(
                          fit: BoxFit.cover,
                          height: 40,
                          width: 40,
                          image: AssetImage('images/fcimg.png'),
                          placeholderBuilder: OctoPlaceholder.blurHash(
                            'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    "${stctrl.lang["Please Log in"]}",
                    style: Get.textTheme.titleMedium,
                  ),
                ),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: ThemeService().switchTheme,
                  child: Container(
                    padding: EdgeInsets.only(left: 20, top: 12.5, bottom: 10),
                    margin:
                        EdgeInsets.only(left: 20, right: 30, top: 5, bottom: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Get.theme.cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Get.theme.shadowColor,
                          blurRadius: 10.0,
                          offset: Offset(2, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 6,
                        ),
                        Icon(
                          Get.theme.brightness == Brightness.dark
                              ? Icons.dark_mode_outlined
                              : Icons.light_mode_outlined,
                          color: Get.theme.primaryColor,
                          size: 18,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          Get.theme.brightness == Brightness.dark
                              ? "${stctrl.lang["Light Theme"]}"
                              : "${stctrl.lang["Dark Theme"]}",
                          style: Get.textTheme.titleSmall,
                        ),
                        Expanded(child: Container()),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    Get.to(() => SettingsPage());
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 20, top: 12.5, bottom: 10),
                    margin:
                        EdgeInsets.only(left: 20, right: 30, top: 5, bottom: 5),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Get.theme.cardColor,
                      boxShadow: [
                        BoxShadow(
                          color: Get.theme.shadowColor,
                          blurRadius: 10.0,
                          offset: Offset(2, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 6,
                        ),
                        Icon(
                          Icons.settings,
                          color: Get.theme.primaryColor,
                          size: 18,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "${stctrl.lang['Settings']}",
                          style: Get.textTheme.titleSmall,
                        ),
                        Expanded(child: Container()),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

Widget drawerListItem(icon, txt) {
  return Container(
    padding: EdgeInsets.only(left: 20, top: 15, bottom: 10),
    margin: EdgeInsets.only(left: 20, right: 30, top: 5, bottom: 5),
    decoration: BoxDecoration(
      color: Get.theme.cardColor,
      boxShadow: [
        BoxShadow(
          color: Get.theme.shadowColor,
          blurRadius: 10.0,
          offset: Offset(2, 3),
        ),
      ],
      borderRadius: BorderRadius.circular(5.0),
    ),
    child: Row(
      children: [
        SizedBox(
          width: 10,
        ),
        Container(
          height: 16,
          width: 16,
          child: SvgPicture.asset(
            icon,
            color: Get.theme.primaryColor,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          txt,
          style: Get.textTheme.titleSmall,
        ),
        Expanded(child: Container()),
        Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
        SizedBox(
          width: 10,
        ),
      ],
    ),
  );
}
