// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/payment_controller.dart';
import 'package:lms_flutter_app/Model/Settings/Country.dart';
import 'package:lms_flutter_app/Model/User/MyAddress.dart';
import 'package:lms_flutter_app/utils/CustomText.dart';
import 'package:lms_flutter_app/utils/widgets/AppBarWidget.dart';

class CheckoutPage extends StatefulWidget {
  // String amount = '';
  // PaymentScreen(this.amount);
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final PaymentController controller = Get.put(PaymentController());

  var tokenKey = "token";
  GetStorage userToken = GetStorage();

  int radioSelector = 0;

  bool isFilterDrawer = false;
  double width = 0;
  double percentageWidth = 0;
  double height = 0;
  double percentageHeight = 0;
  int selectedIndex = 3;
  String coupon = "";
  bool isCouponAvailable = false;

  late Future<CountryList> allCountry;
  late Future<CountryList> allCities;
  late Future<CountryList> allStates;

  bool newSelected = false;

  AllCountry? selectCountry;
  AllCountry? selectCity;
  AllCountry? selectedState;

  Future<CountryList> getCountries() async {
    String token = await userToken.read(tokenKey);
    try {
      Uri myAddressUrl = Uri.parse(baseUrl + '/countries');
      var response = await http.get(
        myAddressUrl,
        headers: header(token: token),
      );
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return CountryList.fromJson(jsonString['data']);
      } else {
        Get.snackbar(
          "${stctrl.lang["Error"]}",
          jsonString['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          borderRadius: 5,
        );
        return CountryList();
      }
    } finally {}
  }

  Future<CountryList> getCities(stateId) async {
    String token = await userToken.read(tokenKey);
    try {
      Uri myAddressUrl = Uri.parse(baseUrl + '/cities/$stateId');
      var response = await http.get(
        myAddressUrl,
        headers: header(token: token),
      );
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return CountryList.fromJson(jsonString['data']);
      } else {
        Get.snackbar(
          "${stctrl.lang["Error"]}",
          jsonString['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          borderRadius: 5,
        );
        return CountryList();
      }
    } finally {}
  }

  Future<CountryList> getStates(countryId) async {
    String token = await userToken.read(tokenKey);
    try {
      Uri myAddressUrl = Uri.parse(baseUrl + '/states/$countryId');
      var response = await http.get(
        myAddressUrl,
        headers: header(token: token),
      );
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return CountryList.fromJson(jsonString['data']);
      } else {
        Get.snackbar(
          "${stctrl.lang["Error"]}",
          jsonString['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          borderRadius: 5,
        );
        return CountryList();
      }
    } finally {}
  }

  @override
  void initState() {
    getDrops();
    super.initState();
  }

  void getDrops() {
    setState(() {
      allCountry = getCountries();
      allCountry.then((value) {
        selectCountry = value.countries?[0];
        allStates = getStates(selectCountry?.id);
        allStates.then((stateValue) {
          selectedState = stateValue.countries?[0];
          allCities = getCities(selectedState?.id);
          allCities.then((cityValue) {
            selectCity = cityValue.countries?[0];
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    percentageWidth = width / 100;
    height = MediaQuery.of(context).size.height;
    percentageHeight = height / 100;
    return SafeArea(
      child: Scaffold(
          backgroundColor: context.theme.scaffoldBackgroundColor,
          appBar: AppBarWidget(
            showSearch: false,
            goToSearch: false,
            showFilterBtn: false,
            showBack: true,
          ),
          body: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 20),
            children: [
              Texth1("${stctrl.lang["Select Billing"]}"),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Get.theme.canvasColor,
                ),
                child: Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${stctrl.lang["Amount to checkout"]}",
                        style: Get.textTheme.titleMedium,
                      ),
                      Text(
                        appCurrency +
                            ' ' +
                            controller.paymentAmount.value.toString(),
                        style: Get.textTheme.titleMedium
                            ?.copyWith(color: Get.theme.primaryColor),
                      ),
                    ],
                  );
                }),
              ),
              SizedBox(
                height: 10,
              ),
              Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (controller.myAddress.isNotEmpty) {
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              newSelected = !newSelected;
                            });
                            controller.firstNameController?.clear();
                            controller.lastNameController?.clear();
                            controller.addressController?.clear();
                            controller.phoneController?.clear();
                            controller.emailController?.clear();
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Get.theme.canvasColor),
                            child: Row(
                              children: [
                                Icon(
                                  !newSelected
                                      ? FontAwesomeIcons.locationArrow
                                      : Icons.arrow_back_ios_sharp,
                                  size: 12.5,
                                  color: Get.theme.primaryColor,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    !newSelected
                                        ? "${stctrl.lang["Add New Address"]}"
                                        : "${stctrl.lang["Choose old Address"]}",
                                    style: Get.textTheme.titleMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        newSelected
                            ? addAddressWidget()
                            : ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: controller.myAddress.length,
                                physics: NeverScrollableScrollPhysics(),
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    height: 10,
                                  );
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Get.theme.canvasColor,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        width: 0.2,
                                        color: controller.myAddress[index] == controller.myAddress[radioSelector] ? Get.textTheme.titleMedium!.color! : Get.theme.canvasColor,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Get.theme.shadowColor,
                                          blurRadius: 10.0,
                                          offset: Offset(2, 3),
                                        ),
                                      ],
                                    ),
                                    child: RadioListTile<MyAddress>(
                                      value: controller.myAddress[index],
                                      activeColor: Get.theme.primaryColor,
                                      selected: true,
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            controller.myAddress[index]
                                                    .firstName ??
                                                "",
                                            style: Get.textTheme.titleSmall,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                              controller.myAddress[index]
                                                      .lastName ??
                                                  "",
                                              style: Get.textTheme.titleSmall),
                                        ],
                                      ),
                                      subtitle: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              controller.myAddress[index]
                                                      .address1 ??
                                                  "",
                                              style: Get.textTheme.titleSmall),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                  controller.myAddress[index]
                                                          .city ??
                                                      "",
                                                  style:
                                                      Get.textTheme.titleSmall),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                  controller.myAddress[index]
                                                          .zipCode ??
                                                      "",
                                                  style:
                                                      Get.textTheme.titleSmall),
                                            ],
                                          ),
                                        ],
                                      ),
                                      groupValue:
                                          controller.myAddress[radioSelector],
                                      onChanged: (value) {
                                        setState(() {
                                          radioSelector = index;
                                          controller.myAddress[radioSelector] =
                                              value ?? MyAddress();

                                          controller.tracking.value = controller
                                              .myAddress[index].trackingId ?? '';
                                          controller.firstName.value =
                                              controller
                                                  .myAddress[index].firstName ?? '';
                                          controller.lastName.value = controller
                                              .myAddress[index].lastName ?? '';
                                          controller.countryName.value =
                                              controller.myAddress[index]
                                                  .country?.name ?? '';
                                          controller.cityName.value =
                                              controller.myAddress[index].city ?? '';
                                          controller.address1.value = controller
                                              .myAddress[index].address1 ?? '';
                                          controller.email.value =
                                              controller.myAddress[index].email ?? '';
                                          controller.phone.value =
                                              controller.myAddress[index].phone ?? '';

                                          //old billing id
                                          controller.oldBilling.value =
                                              controller.myAddress[index].id;
                                          controller.billingAddress.value =
                                              "previous";
                                        });
                                      },
                                    ),
                                  );
                                }),
                      ],
                    );
                  } else {
                    return addAddressWidget();
                  }
                }
              }),
            ],
          ),
          bottomNavigationBar: Container(
            height: 40,
            child: Obx(() {
              return controller.myAddress.isNotEmpty
                  ? (newSelected
                      ? ElevatedButton(
                          onPressed: () {
                            if (controller.firstNameController?.value.text == "" ||
                                controller.lastNameController?.value.text ==
                                    "" ||
                                controller.firstNameController?.value.text ==
                                    "" ||
                                controller.addressController?.value.text == "" ||
                                controller.phoneController?.value.text == "" ||
                                controller.emailController?.value.text == "") {
                              Get.snackbar(
                                "${stctrl.lang["Error"]}",
                                "${stctrl.lang["Please fill-up all the fields"]}",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.redAccent,
                                colorText: Colors.white,
                                borderRadius: 5,
                              );
                            } else {
                              controller.countryId.value = selectCountry?.id ?? 0;
                              controller.stateId.value = selectedState?.id ?? 0;
                              controller.cityId.value = selectCity?.id ?? 0;
                              controller.makeOrderNew();
                            }
                          },
                          child: Text(
                            "${stctrl.lang["Create Order"]}",
                            textAlign: TextAlign.center,
                            style: Get.textTheme.titleSmall?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: () {
                            controller.makeOrderOld();
                          },
                          child: Text(
                            "${stctrl.lang["Proceed to Payment"]}",
                            textAlign: TextAlign.center,
                            style: Get.textTheme.titleSmall?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ))
                  : ElevatedButton(
                      onPressed: () {
                        if (controller.firstNameController?.value.text == "" ||
                            controller.lastNameController?.value.text == "" ||
                            controller.firstNameController?.value.text == "" ||
                            controller.addressController?.value.text == "" ||
                            controller.phoneController?.value.text == "" ||
                            controller.emailController?.value.text == "") {
                          Get.snackbar(
                            "${stctrl.lang["Error"]}",
                            "${stctrl.lang["Please fill-up all the fields"]}",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.redAccent,
                            colorText: Colors.white,
                            borderRadius: 5,
                          );
                        } else {
                          controller.countryId.value = selectCountry?.id ?? 0;
                          controller.stateId.value = selectedState?.id ?? 0;
                          controller.cityId.value = selectCity?.id ?? 0;
                          controller.makeOrderNew();
                        }
                      },
                      child: Text(
                        "${stctrl.lang["Create Order"]}",
                        textAlign: TextAlign.center,
                        style: Get.textTheme.titleSmall?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    );
            }),
          )),
    );
  }

  Widget addAddressWidget() {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        SizedBox(
          height: 10,
        ),
        Text(
          "${stctrl.lang["Add Billing Address"]}",
          style: Get.textTheme.titleMedium,
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${stctrl.lang["First Name"]}",
                      style: Get.textTheme.titleSmall,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: controller.firstNameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: 15, top: 3, bottom: 3, right: 15),
                        filled: true,
                        fillColor: Get.theme.canvasColor,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(142, 153, 183, 0.4),
                              width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(142, 153, 183, 0.4),
                              width: 1.0),
                        ),
                        hintText: "${stctrl.lang["First Name"]}",
                        hintStyle: TextStyle(
                          color: Color(0xff8E99B7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${stctrl.lang["Last Name"]}",
                      style: Get.textTheme.titleSmall,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: controller.lastNameController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                            left: 15, top: 3, bottom: 3, right: 15),
                        filled: true,
                        fillColor: Get.theme.canvasColor,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(142, 153, 183, 0.4),
                              width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(
                              color: Color.fromRGBO(142, 153, 183, 0.4),
                              width: 1.0),
                        ),
                        hintText: "${stctrl.lang["Last Name"]}",
                        hintStyle: TextStyle(
                          color: Color(0xff8E99B7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        FutureBuilder(
          future: allCountry,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${stctrl.lang["Select Country"]}",
                    style: Get.textTheme.titleSmall,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  // getCountryDropDown(snapshot.data?.countries),
                  // getCountryDropDown(snapshot.data?.countries),

            SizedBox(
                    height: 20,
                  ),
                  Text(
                    "${stctrl.lang["Select State"]}",
                    style: Get.textTheme.titleSmall,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  FutureBuilder(
                    future: allStates,
                    builder: (context, secSnap) {
                      if (secSnap.connectionState == ConnectionState.waiting) {
                        return Center(child: CupertinoActivityIndicator());
                      }
                      if (secSnap.hasData) {
                        return getCitiesDropDown([]);
                        // return getStatesDropDown(secSnap.data?.countries);
                      } else {
                        return SizedBox();
                      }
                    },
                  ),
                ],
              );
            } else {
              return Center(child: CupertinoActivityIndicator());
            }
          },
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${stctrl.lang["Address"]}",
                style: Get.textTheme.titleSmall,
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: controller.addressController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 15, top: 3, bottom: 3, right: 15),
                  filled: true,
                  fillColor: Get.theme.canvasColor,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                        color: Color.fromRGBO(142, 153, 183, 0.4), width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                        color: Color.fromRGBO(142, 153, 183, 0.4), width: 1.0),
                  ),
                  hintText: "${stctrl.lang["Address"]}",
                  hintStyle: TextStyle(
                    color: Color(0xff8E99B7),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${stctrl.lang["Email"]}",
                style: Get.textTheme.titleSmall,
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: controller.emailController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 15, top: 3, bottom: 3, right: 15),
                  filled: true,
                  fillColor: Get.theme.canvasColor,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                        color: Color.fromRGBO(142, 153, 183, 0.4), width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                        color: Color.fromRGBO(142, 153, 183, 0.4), width: 1.0),
                  ),
                  hintText: "${stctrl.lang["Email"]}",
                  hintStyle: TextStyle(
                    color: Color(0xff8E99B7),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${stctrl.lang["Phone"]}",
                style: Get.textTheme.titleSmall,
              ),
              SizedBox(
                height: 5,
              ),
              TextField(
                controller: controller.phoneController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 15, top: 3, bottom: 3, right: 15),
                  filled: true,
                  fillColor: Get.theme.canvasColor,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                        color: Color.fromRGBO(142, 153, 183, 0.4), width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                        color: Color.fromRGBO(142, 153, 183, 0.4), width: 1.0),
                  ),
                  hintText: "${stctrl.lang["Phone"]}",
                  hintStyle: TextStyle(
                    color: Color(0xff8E99B7),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Widget getCountryDropDown(List<AllCountry> country) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: DropdownButton(
        elevation: 1,
        isExpanded: true,
        underline: Container(),
        items: country.map((item) {
          return DropdownMenuItem<AllCountry>(
            value: item,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(item.name ?? ''),
            ),
          );
        }).toList(),
        onChanged: (value) async {
          setState(() {
            selectCountry = '$value' as AllCountry?;
            debugPrint('User select country ${selectCountry?.name}');
          });

          // allStates = getStates(value?.id);

          allStates.then((stateValue) {
            selectedState = (stateValue.countries?.length ?? 0) > 0
                ? stateValue.countries![0]
                : AllCountry(name: 'Null', id: 0);

            // allCities = getCities(selectedState?.id);
            allCities.then((cityVal) {
              selectCity = (cityVal.countries?.length ?? 0) > 0
                  ? cityVal.countries![0]
                  : AllCountry(name: 'Null', id: 0);
            });
          });
        },
        value: selectCountry,
      ),
    );
  }

  Widget getCitiesDropDown(List<AllCountry> cities) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        underline: Container(),
        items: cities.map((item) {
          return DropdownMenuItem<AllCountry>(
            value: item,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(item.name.toString()),
            ),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            // selectCity = value;
            // debugPrint('User select city ${selectCity.name}');
          });
        },
        value: selectCity,
      ),
    );
  }

  Widget getStatesDropDown(List<AllCountry> states) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          child: DropdownButton(
            elevation: 0,
            isExpanded: true,
            underline: Container(),
            items: states.map((item) {
              return DropdownMenuItem<AllCountry>(
                value: item,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(item.name.toString()),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                // selectedState = value;
                // debugPrint('User select state ${selectedState.name}');

                // allCities = getCities(value.id);
                allCities.then((value) {
                  selectCity = (value.countries?.length ?? 0) > 0
                      ? value.countries![0]
                      : AllCountry(name: 'Null', id: 0);
                });
              });
            },
            value: selectedState,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "${stctrl.lang["Select City"]}",
          style: Get.textTheme.titleSmall,
        ),
        SizedBox(
          height: 5,
        ),
        FutureBuilder(
          future: allCities,
          builder: (context, secSnap) {
            if (secSnap.hasData) {
              return getCitiesDropDown([]);
              // return getCitiesDropDown(secSnap.data.countries);
            } else {
              return Center(child: CupertinoActivityIndicator());
            }
          },
        ),
      ],
    );
  }

  // int getCode<T>(T t, String title) {
  //   int code;
  //   for (var cls in t) {
  //     if (cls.name == title) {
  //       code = cls.id;
  //       break;
  //     }
  //   }
  //   return code;
  // }
}
