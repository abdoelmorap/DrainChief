import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class IAPService {
  Future<void> initPlatformState() async {
    // Enable debug logs before calling `configure`.
    await Purchases.setDebugLogsEnabled(true);
    // await Purchases.setLogLevel(LogLevel.verbose);

    /*
    - appUserID is nil, so an anonymous ID will be generated automatically by the Purchases SDK. Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids

    - observerMode is false, so Purchases will automatically handle finishing transactions. Read more about Observer Mode here: https://docs.revenuecat.com/docs/observer-mode
    */
    PurchasesConfiguration _config;

    _config = PurchasesConfiguration(StoreConfig.instance.apiKey)
      ..appUserID = null
      ..observerMode = false;

    await Purchases.configure(_config);

    Purchases.addCustomerInfoUpdateListener((customerInfo) async {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();

      print(customerInfo);
    });
  }
}

enum Store { appleStore, googlePlay }

class StoreConfig {
  final Store store;
  final String apiKey;
  static StoreConfig? _instance;

  factory StoreConfig({@required Store? store, @required String? apiKey}) {
    _instance ??= StoreConfig._internal(store!, apiKey!);
    return _instance!;
  }

  StoreConfig._internal(this.store, this.apiKey);

  static StoreConfig get instance {
    return _instance!;
  }

  static bool isForAppleStore() => _instance?.store == Store.appleStore;

  static bool isForGooglePlay() => _instance?.store == Store.googlePlay;
}
