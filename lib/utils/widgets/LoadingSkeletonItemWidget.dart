import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:loading_skeleton_niu/loading_skeleton.dart';
// import 'package:loading_skeleton/loading_skeleton.dart';

class LoadingSkeletonItemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width;
    double percentageWidth;
    double height;
    double percentageHeight;

    width = MediaQuery.of(context).size.width;
    percentageWidth = width / 100;
    height = MediaQuery.of(context).size.height;
    percentageHeight = height / 100;
    return Container(
      height: 220,
      child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          separatorBuilder: (context, index) {
            return SizedBox(
              width: 18,
            );
          },
          padding: EdgeInsets.fromLTRB(Get.locale == Locale('ar') ? 0 : 5,
              0, Get.locale == Locale('ar') ? 5 : 0, 0),
          physics: BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(
                color: Get.theme.cardColor,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                    color: Get.theme.shadowColor,
                    blurRadius: 10.0,
                    offset: Offset(2, 3),
                  ),
                ],
              ),
              margin: EdgeInsets.only(bottom: 5),
              width: 174,
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: LoadingSkeleton(
                      width: 174,
                      height: 100,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 5.0),
                      child: Column(
                        children: [
                          LoadingSkeleton(
                            height: percentageHeight * 1.5,
                            width: percentageWidth * 40,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          LoadingSkeleton(
                            height: percentageHeight * 1.5,
                            width: percentageWidth * 40,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      )),
                ],
              ),
            );
          }),
    );
  }
}
