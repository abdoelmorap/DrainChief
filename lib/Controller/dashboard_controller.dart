// Dart imports:
import 'dart:convert';
import 'dart:io';
import 'dart:math';

// Flutter imports:
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

// Package imports:
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

// Project imports:
import 'package:lms_flutter_app/Config/app_config.dart';
import 'package:lms_flutter_app/Controller/cart_controller.dart';
import 'package:lms_flutter_app/Model/User/User.dart';
import 'package:lms_flutter_app/Service/RemoteService.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

// import 'package:lms_flutter_app/utils/widgets/persistant_bottom_custom/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class DashboardController extends GetxController {
  final CartController cartController = Get.find<CartController>();

  PersistentTabController persistentTabController =
      PersistentTabController(initialIndex: 0);

  var scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  var loginReturn = " ";
  var token = "";
  var tokenKey = "token";
  GetStorage userToken = GetStorage();

  var loggedIn = false.obs;

  String? loadToken;

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  final TextEditingController registerName = TextEditingController();
  final TextEditingController registerEmail = TextEditingController();
  final TextEditingController registerPhone = TextEditingController();
  final TextEditingController registerPassword = TextEditingController();
  final TextEditingController registerConfirmPassword = TextEditingController();

  var isLoading = false.obs;

  var loginMsg = "".obs;

  var profileData = User();

  var isRegisterScreen = false.obs;

  Future<AuthorizationCredentialAppleID?> appleLogin() async {
    try {
      AuthorizationCredentialAppleID appCred = await signInWithApple();

      print('-------------------->');
      print(appCred.email ??
          '${appCred.userIdentifier?.split('.')[0]}@apple.com');
      print(appCred.familyName ?? 'tour_user');
      print(appCred.userIdentifier ?? '');

      return appCred;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
    return null;
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> appleSignOut() async {}

  Future<AuthorizationCredentialAppleID> signInWithApple() async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    final AuthorizationCredentialAppleID appleCredential =
        await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    debugPrint(
        '-------------------------------->apple login<--------------------------------');
    debugPrint('apple credentials = $appleCredential');
    debugPrint('apple user email = ${appleCredential.email}');

    return appleCredential;
  }

  void changeTabIndex(int index) async {
    Get.focusScope?.unfocus();
    persistentTabController.index = index;
    if (Platform.isIOS) {
      if (persistentTabController.index == 2) {
        if (loggedIn.value) {
          // String token = await userToken.read(tokenKey);
          getProfileData();
          scaffoldKey.currentState?.openEndDrawer();
        }

        // changeTabIndex(0);
      }
    } else {
      if (persistentTabController.index == 3) {
        if (loggedIn.value) {
          // String token = await userToken.read(tokenKey);
          getProfileData();
          scaffoldKey.currentState?.openEndDrawer();
        }

        // changeTabIndex(0);
      } else if (persistentTabController.index == 1) {
        if (loggedIn(true)) {
          cartController.cartList.value = [];
          cartController.getCartList();
        }
      }
    }

    checkToken();
  }

  Future<void> loadUserToken() async {
    loadToken = await loadData();
    if (loadToken != null) {
      var toke = await userToken.read(tokenKey);
      checkToken();
      cartController.isLoading.value = true;
      cartController.getCartList();
      isLoading(false);
      return toke;
    } else {
      await userToken.remove(tokenKey);
    }
  }

  Future<String?> loadData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(tokenKey);
  }

  Future<bool> checkToken() async {
    String? token = userToken.read(tokenKey);

    if (token != null && token.isNotEmpty) {
      loggedIn.value = true;
      update();
      getProfileData();
      return true;
    } else {
      loggedIn.value = false;
      update();
      return false;
    }
  }

  // call login api
  Future fetchUserLogin() async {
    try {
      print('-----__>');
      isLoading(true);
      var login = await RemoteServices.login(email.text, password.text);
      if (login != null) {
        print('-------<>');
        if (login['data']['is_verify'] != null) {
          token = login['data']['access_token'];
          loginMsg.value = login['message'];
          if (token.length > 5) {
            await saveToken(token);
            await loadUserToken();
            await setupNotification();
            await stctrl.getLanguage();
          }
          return login;
        } else {
          print('---------------<><> ${stctrl.lang["Before proceeding, please check your email for a verification link Login in Using that Link."]}');
          loginMsg.value = "${stctrl.lang["Not verified"]}";
          Get.snackbar(
            "${stctrl.lang["Verify Your Email Address"]}",
            "${stctrl.lang["Before proceeding, please check your email for a verification link Login in Using that Link."]}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            borderRadius: 5,
            duration: Duration(seconds: 6),
          );
        }
      }
    } finally {
      isLoading(false);
    }
  }

  Future<bool> socialLogin(Map data) async {
    try {
      Uri loginUrl = Uri.parse(baseUrl + '/social-login');

      var body = json.encode(data);
      print('body is --------------------> $body');
      var response = await http.post(loginUrl, headers: header(), body: body);
      print('response is--------------------> ${response.toString()}');
      var jsonString = jsonDecode(response.body);
      print(jsonString.toString());
      print('status code is::: ${response.statusCode}');
      if (response.statusCode == 200) {
        token = jsonString['data']['access_token'];

        if (token.length > 5) {
          await userToken.write("method", "${data['provider']}");

          await saveToken(token);
          await loadUserToken();
          await setupNotification();
          await stctrl.getLanguage();

          return true;
        } else {
          return false;
        }
      } else if (response.statusCode == 401) {
        Get.snackbar(
          "${stctrl.lang["Invalid Credentials"]}",
          "${stctrl.lang["Wrong Email or Password. Please try again"]}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          borderRadius: 5,
        );
      } else {
        Get.snackbar(
          "${stctrl.lang["Something went wrong!"]}",
          "${jsonString['message']}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          borderRadius: 5,
        );
      }
    } catch (e, t) {
      print('error is--->');
      print(e.toString());
      print(t.toString());
    }

    return false;
  }

  void showRegisterScreen() {
    isRegisterScreen.value = !isRegisterScreen.value;
  }

  Future fetchUserRegister() async {
    try {
      isLoading(true);
      var login = await RemoteServices.register(
        registerName.text,
        registerEmail.text,
        registerPhone.text,
        registerPassword.text,
        registerConfirmPassword.text,
      );
      if (login != null) {
        if (login['success'] == true) {
          showRegisterScreen();

          registerName.clear();
          registerEmail.clear();
          registerPhone.clear();
          registerPassword.clear();
          registerConfirmPassword.clear();

          Get.snackbar(
            login['message'],
            "",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            borderRadius: 5,
          );
        }

        return login;
      }
    } finally {
      isLoading(false);
    }
  }

  Future<void> saveToken(String msg) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (msg.length > 5) {
      await preferences.setString(tokenKey, msg);
      await userToken.write(tokenKey, msg);
    } else {}
  }

  Future<void> removeToken(String msg) async {
    try {
      String token = await userToken.read(tokenKey);

      Uri logoutUrl = Uri.parse(baseUrl + '/logout');
      var response = await http.get(logoutUrl, headers: header(token: token));

      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        await preferences.remove(tokenKey);
        await userToken.remove(tokenKey);
        await FacebookAuth.instance.logOut();
        await GoogleSignIn().signOut();
        cartController.cartList.value = [];
        loggedIn.value = false;
        await stctrl.getLanguage();
        loginMsg.value = "${stctrl.lang['Logged out']}";
        update();
        Get.snackbar(
          "${stctrl.lang['Done']}",
          jsonString['message'].toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.theme.primaryColor,
          colorText: Colors.white,
          borderRadius: 5,
        );
      } else {
        Get.snackbar(
          "${stctrl.lang['Error in Sign out']}",
          jsonString['message'].toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 5,
        );
        return null;
      }
    } catch (e) {}
  }

  Future<User?> getProfileData() async {
    String token = await userToken.read(tokenKey);
    try {
      var products = await RemoteServices.getProfile(token);
      profileData = products ?? User();
      return products;
    } finally {}
  }

  String _firebaseAppToken = '';

  Future<void> setupNotification() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    String firebaseAppToken = await messaging.getToken(
          // https://stackoverflow.com/questions/54996206/firebase-cloud-messaging-where-to-find-public-vapid-key
          vapidKey: '',
        ) ??
        '';

    if (AwesomeStringUtils.isNullOrEmpty(firebaseAppToken,
        considerWhiteSpaceAsEmpty: true)) return;

    _firebaseAppToken = firebaseAppToken;

    print('Firebase token: $firebaseAppToken');

    await sendTokenToServer(_firebaseAppToken);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (
          // This step (if condition) is only necessary if you pretend to use the
          // test page inside console.firebase.google.com
          !AwesomeStringUtils.isNullOrEmpty(message.notification?.title,
                  considerWhiteSpaceAsEmpty: true) ||
              !AwesomeStringUtils.isNullOrEmpty(message.notification?.body,
                  considerWhiteSpaceAsEmpty: true)) {
        print('Message also contained a notification: ${message.notification}');

        String? imageUrl;
        imageUrl ??= message.notification?.android?.imageUrl;
        imageUrl ??= message.notification?.apple?.imageUrl;

        // https://pub.dev/packages/awesome_notifications#notification-types-values-and-defaults
        Map<String, dynamic> notificationAdapter = {
          NOTIFICATION_CONTENT: {
            NOTIFICATION_ID: Random().nextInt(2147483647),
            NOTIFICATION_CHANNEL_KEY: 'basic_channel',
            NOTIFICATION_TITLE: message.notification?.title,
            NOTIFICATION_BODY:
                _parseHtmlString(message.notification?.body ?? ''),
            NOTIFICATION_LAYOUT: 'Default',
          }
        };

        AwesomeNotifications()
            .createNotificationFromJsonData(notificationAdapter);
      } else {
        AwesomeNotifications().createNotificationFromJsonData(message.data);
      }

      await getProfileData();

      Get.dialog(
        AlertDialog(
          title: message.data['image'] != null
              ? Image.network(message.data['image'], width: 50, height: 50)
              : Image.asset(
                  "images/$appLogo",
                  width: 50,
                  height: 50,
                ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Text(
                  message.notification?.title ?? "",
                  style: Get.theme.textTheme.titleMedium,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  _parseHtmlString(message.notification?.body ?? ''),
                  style: Get.theme.textTheme.titleSmall,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString =
        parse(document.body?.text).documentElement?.text ?? '';

    return parsedString;
  }

  Future sendTokenToServer(String notificationToken) async {
    await getProfileData();
    String token = await userToken.read(tokenKey);
    final response = await http.post(
        Uri.parse(baseUrl +
            '/set-fcm-token?id=${profileData.id}&token=$notificationToken'),
        headers: header(token: token));
    if (response.statusCode == 200) {
      print('token updated : $notificationToken');
    } else {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove(tokenKey);
      await userToken.remove(tokenKey);
      cartController.cartList.value = [];
      checkToken();
      loginMsg.value = "${stctrl.lang["Logged out"]}";
      update();
      Get.snackbar(
        "${stctrl.lang["Status"]}",
        "${stctrl.lang["Logged out"]}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        borderRadius: 5,
      );
      throw Exception('Failed to load');
    }
  }

  var obscurePass = true.obs;
  var obscureNewPass = true.obs;
  var obscureConfirmPass = true.obs;

  @override
  void onInit() {
    // loadUserToken();
    checkToken();
    if (loggedIn.value) {
      setupNotification();
    }
    if (isDemo) {
      email.text = 'student@infixedu.com';
      password.text = '12345678';
    }
    super.onInit();
  }
}
