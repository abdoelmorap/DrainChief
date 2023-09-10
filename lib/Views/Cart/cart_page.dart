// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// Package imports:

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/cart_controller.dart';
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';
import 'package:lms_flutter_app/Controller/payment_controller.dart';
import 'package:lms_flutter_app/Views/Cart/checkout_page.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';
import 'package:lms_flutter_app/utils/widgets/AppBarWidget.dart';
import 'package:octo_image/octo_image.dart';
import 'package:reactive_forms/reactive_forms.dart';

// ignore: must_be_immutable
class CartPage extends StatelessWidget {
  GetStorage userToken = GetStorage();
  String tokenKey = "token";

  // FormGroup get form => fb.group(<String, dynamic>{'coupon': ['', Validators.required]});
  FormGroup get form => fb.group({'coupon': ['', Validators.required]});


  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.put(CartController());
    final DashboardController dashboardController =
        Get.put(DashboardController());
    final PaymentController paymentController = Get.put(PaymentController());
    double width;
    double percentageWidth;
    double height;
    double percentageHeight;
    width = MediaQuery.of(context).size.width;
    percentageWidth = width / 100;
    height = MediaQuery.of(context).size.height;
    percentageHeight = height / 100;

    // cartController.getCartList();
    return SafeArea(
      child: Scaffold(
          appBar: AppBarWidget(
            showSearch: false,
            goToSearch: false,
            showFilterBtn: false,
            showBack: false,
          ),
          body: Container(
            child: ListView(
              physics: BouncingScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                SizedBox(
                  height: 15,
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(
                      left: 20,
                      bottom: 14.72,
                      right: 20,
                    ),
                    child: Texth1("${stctrl.lang["Cart List"]}")),
                Obx(() {
                  if (cartController.isLoading.value) {
                    return CupertinoActivityIndicator();
                  } else {
                    return Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Obx(() {
                        return cartController.cartList.length == 0
                            ? Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${stctrl.lang["There are no items in Cart"]}",
                                      style: Get.textTheme.titleSmall,
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: cartController.cartList.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                      decoration: BoxDecoration(
                                        color: Get.theme.cardColor,
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Get.theme.shadowColor,
                                            blurRadius: 10.0,
                                            offset: Offset(2, 3),
                                          ),
                                        ],
                                      ),
                                      margin: EdgeInsets.only(
                                        bottom: 14.72,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            child: OctoImage(
                                              image: NetworkImage(
                                                  "$rootUrl/${cartController.cartList[index].course?.image}"),
                                              placeholderBuilder:
                                                  OctoPlaceholder.blurHash(
                                                'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                                              ),
                                              fit: BoxFit.cover,
                                              width: 88,
                                              height: 85,
                                            ),
                                          ),
                                          Flexible(
                                            child: Container(
                                              margin: EdgeInsets.only(left: 18),
                                              width: 220,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  courseTitle(cartController
                                                              .cartList[index]
                                                              .course
                                                              ?.title?[
                                                          '${stctrl.code.value}'] ??
                                                      "${cartController.cartList[index].course?.title?['en']}"),
                                                  courseTPublisher(cartController.cartList[index].course?.user?.name ?? ''),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  cartMoney(appCurrency +
                                                      cartController
                                                          .cartList[index].price
                                                          .toString()),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          PopupMenuButton(
                                            itemBuilder: (context) {
                                              return [
                                                PopupMenuItem(
                                                  value: 'remove',
                                                  child: Text(
                                                    "${stctrl.lang["Remove"]}",
                                                  ),
                                                  height: 0,
                                                ),
                                              ];
                                            },
                                            onSelected: (String value) async {
                                              await cartController.removeToCart(
                                                  cartController
                                                      .cartList[index].id);
                                              cartController.cartList.value =
                                                  [];
                                              await cartController
                                                  .getCartList();
                                            },
                                          ),
                                        ],
                                      ));
                                });
                      }),
                    );
                  }
                }),
                Obx(() {
                  if (cartController.isLoading.value ||
                      cartController.cartList.length == 0) {
                    return Container();
                  } else {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                          left: 20,
                          bottom: 14.72,
                          top: 14.72,
                          right: 20,
                        ),
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(
                                    left: 20, bottom: 20, top: 20, right: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Texth1("${stctrl.lang["Order Summary"]}"),
                                  ],
                                )),
                            Obx(() {
                              return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: cartController.cartList.length,
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder:
                                      (BuildContext context, int position) {
                                    return Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.only(
                                            left: 20,
                                            bottom: 15,
                                            top: 0,
                                            right: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: cartTitle(cartController
                                                          .cartList[position]
                                                          .course
                                                          ?.title?[
                                                      '${stctrl.code.value}'] ??
                                                  "${cartController.cartList[position].course?.title?['en']}"),
                                            ),
                                            cartMoney(appCurrency +
                                                cartController
                                                    .cartList[position].price
                                                    .toString()),
                                          ],
                                        ));
                                  });
                            }),
                            Obx(() {
                              if (cartController.isCouponAvailable.value) {
                                return Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.only(
                                        left: 20,
                                        bottom: 12,
                                        top: 0,
                                        right: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            couponTotal(
                                                cartController.couponMsg.value),
                                            GestureDetector(
                                              onTap: () {
                                                cartController.removeCoupon();
                                              },
                                              child: Icon(
                                                FontAwesomeIcons.times,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            cartTotal(
                                                "${stctrl.lang["Total"]}"),
                                            cartTotal(appCurrency +
                                                cartController.total.value
                                                    .toString()),
                                          ],
                                        ),
                                      ],
                                    ));
                              } else {
                                return Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 20,
                                              bottom: 12,
                                              top: 0,
                                              right: 20),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              cartController.couponMsg.value ==
                                                      ""
                                                  ? Container()
                                                  : couponError(cartController
                                                          .couponMsg.value),
                                              Divider(),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  cartTotal(
                                                      "${stctrl.lang["Total"]}"),
                                                  cartTotal(appCurrency +
                                                      cartController
                                                          .totalAmount()),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        ReactiveFormBuilder(
                                            form: () => form,
                                            builder: (context, form, child) {
                                              return Container(
                                                margin: EdgeInsets.only(
                                                    left: 20,
                                                    right: 10,
                                                    bottom: 20),
                                                height: percentageHeight * 8,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        width: percentageWidth *
                                                            60,
                                                        height:
                                                            percentageHeight *
                                                                8,
                                                        alignment:
                                                            Alignment.center,
                                                        child:
                                                            ReactiveTextField<
                                                                String>(
                                                          formControlName:
                                                              'coupon',
                                                          autocorrect: false,
                                                          autofocus: false,
                                                          decoration:
                                                              new InputDecoration(
                                                                  contentPadding:
                                                                      EdgeInsets.only(
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              10),
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .blueGrey,
                                                                        width:
                                                                            1.0),
                                                                  ),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .blueGrey,
                                                                        width:
                                                                            1.0),
                                                                  ),
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .blueGrey,
                                                                        width:
                                                                            1.0),
                                                                  ),
                                                                  disabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .blueGrey,
                                                                        width:
                                                                            1.0),
                                                                  ),
                                                                  hintText:
                                                                      "${stctrl.lang["Enter coupon code"]}"),
                                                          validationMessages:
                                                              (errors) => {
                                                            ValidationMessage
                                                                    .required:
                                                                "${stctrl.lang["Coupon must not be empty"]}",
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    ReactiveFormConsumer(
                                                      builder: (context, form,
                                                          child) {
                                                        return Container(
                                                          height: 40,
                                                          child: ElevatedButton(
                                                            onPressed:
                                                                form.valid
                                                                    ? () {
                                                                  String? couponCode = form.value['coupon'] as String?;
                                                                  cartController.applyCoupon(code: couponCode, totalAmount: cartController.total);

                                                                  // cartController.applyCoupon(code: form.value['coupon'], totalAmount: cartController.total);
                                                                      }
                                                                    : null,
                                                            child: Text(
                                                              "${stctrl.lang["Apply"]}",
                                                              style: Get
                                                                  .textTheme
                                                                  .titleMedium
                                                                  ?.copyWith(
                                                                      color: Colors
                                                                          .white),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                      ],
                                    ));
                              }
                            }),
                          ],
                        ));
                  }
                }),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            height: 50,
            child: Obx(() {
              if (cartController.cartList.length == 0 ||
                  cartController.isLoading.value) {
                return ElevatedButton(
                  onPressed: () {
                    dashboardController.changeTabIndex(0);
                  },
                  child: Text(
                    "${stctrl.lang["Browse Courses"]}",
                    textAlign: TextAlign.center,
                    style:
                        Get.textTheme.titleSmall?.copyWith(color: Colors.white),
                  ),
                );
              } else {
                return ElevatedButton(
                  onPressed: () {
                    paymentController.getMyAddress();
                    paymentController.paymentAmount.value =
                        cartController.total.value.toString();
                    paymentController.trackingId.value = cartController.cartList.first.tracking ??'';
                    Get.to(() => CheckoutPage());
                  },
                  child: Text(
                    "${stctrl.lang["Proceed to Checkout"]}",
                    textAlign: TextAlign.center,
                    style:
                        Get.textTheme.titleSmall?.copyWith(color: Colors.white),
                  ),
                );
              }
            }),
          )),
    );
  }
}
