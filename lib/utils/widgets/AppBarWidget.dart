// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';
import 'package:lms_flutter_app/Controller/home_controller.dart';
import 'package:lms_flutter_app/Views/Home/Course/all_course_view.dart';

class AppBarWidget extends StatefulWidget implements PreferredSizeWidget {
  final bool? showSearch;
  final bool? goToSearch;
  final bool? showBack;
  final bool? showFilterBtn;
  final Function(String)? searching;

  AppBarWidget(
      {this.showSearch,
      this.goToSearch,
      this.searching,
      this.showBack,
      this.showFilterBtn});

  @override
  Size get preferredSize =>
      Size(Get.width, showSearch! ? Get.height * 0.20 : Get.height * 0.10);

  @override
  _AppBarWidgetState createState() => _AppBarWidgetState();
}

class _AppBarWidgetState extends State<AppBarWidget> {
  final HomeController homeController = Get.put(HomeController());

  final DashboardController controller = Get.put(DashboardController());

  @override
  void initState() {
    print(Get.theme.brightness);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Get.theme.appBarTheme.backgroundColor,
      centerTitle: false,
      elevation: 0,
      automaticallyImplyLeading: false,
      actions: [
        Container(),
      ],
      flexibleSpace: Container(
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    widget.showBack!
                        ? Container(
                            child: IconButton(
                              icon: Icon(Icons.arrow_back_ios_sharp),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          )
                        : Container(),
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 15, horizontal: widget.showBack! ? 5 : 20),
                      alignment: Alignment.centerLeft,
                      width: 80,
                      height: 30,
                      child: Image.asset(
                        'images/$appLogo',
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Obx(() {
                      return !controller.loggedIn.value
                          ? IconButton(
                              onPressed: () {
                                controller.scaffoldKey.currentState
                                    ?.openEndDrawer();
                              },
                              icon: Icon(
                                Icons.list,
                                color: Get.theme.iconTheme.color,
                              ),
                            )
                          : SizedBox.shrink();
                    }),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ],
            ),
            widget.showSearch!
                ? GestureDetector(
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                blurRadius: 10,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          margin:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                          child: TextField(
                            enabled: widget.goToSearch! ? false : true,
                            onChanged: widget.searching,
                            autofocus: false,
                            autocorrect: false,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Get.theme.canvasColor,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: Color.fromRGBO(48, 59, 88, 0.07),
                                    width: 1.0),
                              ),
                              hintText: '${stctrl.lang['What do you want to learn?']}',
                              hintStyle: Get.textTheme.labelLarge,
                              prefixIcon: Icon(
                                Icons.search,
                                size: 28,
                                color: Get.theme.iconTheme.color,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Get.locale == Locale('ar')
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: widget.showFilterBtn!
                              ? IconButton(
                                  padding: EdgeInsets.only(
                                      left: 35, top: 10, bottom: 10, right: 35),
                                  icon: Container(
                                    height: 20,
                                    width: 20,
                                    child: SvgPicture.asset(
                                      'images/filter_icon.svg',
                                      color: Get.theme.iconTheme.color,
                                    ),
                                  ),
                                  onPressed: () {
                                    if (widget.goToSearch!) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AllCourseView(),
                                          ));
                                    } else {
                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      print("hello");
                                      homeController.filterDrawer.currentState
                                          ?.openEndDrawer();
                                    }
                                    // showPopup(context);
                                  },
                                )
                              : Container(),
                        ),
                      ],
                    ),
                    onTap: () {
                      if (widget.goToSearch!) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AllCourseView(),
                            ));
                      }
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
