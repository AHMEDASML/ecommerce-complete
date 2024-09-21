import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JoinUsController extends GetxController {
  Dio dio = Dio();

  Future<void> sendJoinRequest({
    required String name,
    required String phone,
    required String email,
    required BuildContext context,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? token = sharedPreferences.getString(AppConstants.userLoginToken);

    if (token != null) {
      print("User token: $token");
    } else {
      print("No token found");
    }

    var headers = {'Authorization': 'Bearer $token'};

    var data = json.encode({
      'name': name,
      'phone': phone,
      'email': email,
    });

    try {
      var response = await dio.post(
        'https://www.winbywin.shop/api/v1/JoinRequest',
        options: Options(headers: headers),
        data: data,
      );

      if (response.statusCode == 200) {
        print("Request successful:");
        print(json.encode(response.data));

        Fluttertoast.showToast(
            msg: getTranslated(
                'the_request_has_been_sent_successfully.', context)!,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);

        Navigator.pop(context);
      } else {
        print("Failed with status: ${response.statusCode}");
        print("Error message: ${response.statusMessage}");

        Fluttertoast.showToast(
            msg: getTranslated(
                'failed_to_send_request._please_try_again.', context)!,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      // معالجة الأخطاء
      print("Error occurred: $e");
      Fluttertoast.showToast(
          msg: getTranslated('an_error_occurred', context)!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
