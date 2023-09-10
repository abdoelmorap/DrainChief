import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';
import 'package:octo_image/octo_image.dart';

class SingleItemCardWidget extends StatelessWidget {
  final bool? showPricing;
  final String? image;
  final String? title;
  final String? subTitle;
  final VoidCallback? onTap;
  final dynamic price;
  final dynamic discountPrice;
  SingleItemCardWidget({
    this.showPricing,
    this.image,
    this.title,
    this.subTitle,
    this.onTap,
    this.price,
    @required this.discountPrice,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
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
        margin: EdgeInsets.only(bottom: 20),
        width: 174,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: Container(
                      width: Get.width,
                      height: 120,
                      child: OctoImage(
                        image: NetworkImage(image ?? ''),
                        placeholderBuilder: OctoPlaceholder.blurHash(
                          'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                        ),
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Image.asset('images/fcimg.png');
                        },
                      ),
                    ),
                  ),
                  showPricing == false
                      ? discountPrice != 0
                          ? Positioned(
                              top: 0,
                              right: 0,
                              child: Align(
                                  alignment: Alignment.topRight,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(5),
                                    ),
                                    child: Container(
                                      color: Color(0xFFD7598F),
                                      padding: EdgeInsets.all(4),
                                      alignment: Alignment.center,
                                      child: Row(
                                        children: [
                                          Text(
                                            "$appCurrency${discountPrice.toString()}",
                                            style: Get.textTheme.titleSmall
                                                ?.copyWith(
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "$appCurrency${price.toString()}",
                                            style: Get.textTheme.titleSmall
                                                ?.copyWith(
                                              color: Colors.white,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              decorationThickness: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )),
                            )
                          : Positioned(
                              top: 0,
                              right: 0,
                              child: Align(
                                  alignment: Alignment.topRight,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(5),
                                    ),
                                    child: Container(
                                      color: Color(0xFFD7598F),
                                      padding: EdgeInsets.all(4),
                                      alignment: Alignment.center,
                                      child: double.parse(price.toString()) > 0
                                          ? Text(
                                              "$appCurrency${price.toString()}",
                                              style: Get.textTheme.titleSmall
                                                  ?.copyWith(
                                                      color: Colors.white),
                                            )
                                          : Text(
                                              "${stctrl.lang["Free"]}",
                                              style: Get.textTheme.titleSmall
                                                  ?.copyWith(
                                                      color: Colors.white),
                                            ),
                                    ),
                                  )),
                            )
                      : Container(),
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    courseTitle(title ?? ''),
                    SizedBox(
                      height: 4,
                    ),
                    courseTPublisher(subTitle ?? ''),
                  ],
                )),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
