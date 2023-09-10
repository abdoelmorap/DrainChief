import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../Config/app_config.dart';

class SslService {
  Future<String> getSSLPaymentResponse() async {
    Uri addToCartUrl = Uri.parse('$baseUrl/make-order-ssl');
    GetStorage userToken = GetStorage();
    String token = await userToken.read('token');
    var response = await http.get(
      addToCartUrl,
      headers: header(token: token),
    );
    if (response.statusCode == 200) {
      var jsonString = jsonDecode(response.body);
      var message = jsonEncode(jsonString);//jsonString['message']
      print('------->');
      print(message);
      return message;
    } else {
      //show error message
      return "Somthing Wrong";
    }
  }
}
