// Package imports:
import 'package:get/get.dart';

// Project imports:
import 'package:lms_flutter_app/Controller/account_controller.dart';
import 'package:lms_flutter_app/Controller/cart_controller.dart';
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';
import 'package:lms_flutter_app/Controller/home_controller.dart';

class DashboardBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<AccountController>(() => AccountController());
  }

}
