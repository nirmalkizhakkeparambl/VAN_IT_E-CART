import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ntfp_cart/Constants/error_handling.dart';
import 'package:ntfp_cart/Constants/error_handlingStream.dart';
import 'package:ntfp_cart/Constants/global_variables.dart';
import 'package:ntfp_cart/Constants/utils.dart';
import 'package:ntfp_cart/Models/user.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../CommonWidgets/bottom_bar.dart';
import '../Provider/user_provider.dart';

class AuthService {
  // sign up user
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      User user = User(
        id: '',
        name: name,
        password: password,
        email: email,
        address: '',
        type: 'user',
        token: '',
        cart: [],
      );
      List<String> requestBody = [user.toJson()];
      http.Response res = await http.post(
        Uri.parse('$uri/vanITSignUp'),
        body: jsonEncode(requestBody),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print(user.toJson());
      print(requestBody);

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'Account created! Login with the same credentials!',
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
      print(e.toString());
    }
  }

  // sign in user
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request(
          'GET', Uri.parse('http://68.178.167.39/E_CART_API/API/vanITLogin'));
      request.body = json.encode({
        'email': email,
        'password': password,
      });
      request.headers.addAll(headers);
      print("hello11");
      http.StreamedResponse res = await request.send();
      final responseBody = await res.stream.bytesToString();
      print(responseBody);
      print(res.stream);
      print("hello");
      // http.Response res = await http.get(
      //   Uri.parse('$uri/vanITLogin'),
      //   body: jsonEncode([
      //     {
      //       'email': email,
      //       'password': password,
      //     }
      //   ]),
      //   headers: <String, String>{
      //     'Content-Type': 'application/json; charset=UTF-8',
      //   },
      // );
      httpErrorHandleStream(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false)
              .setUser(responseBody);

          await prefs.setString(
              'x-auth-token', jsonDecode(responseBody)['type_user']);
          Navigator.pushNamedAndRemoveUntil(
            context,
            BottomBar.routeName,
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
      // Navigator.pushNamedAndRemoveUntil(
      //   context,
      //   BottomBar.routeName,
      //   (route) => false,
      // );
    }
  }

  // get user data
  void getUserData(
    BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');
      print("Token123" + token.toString());
      if (token == null) {
        prefs.setString('x-auth-token', '');
      }
      print("Token1233");
      var tokenRes = await http.post(
        Uri.parse('$uri/ValidateToken'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('$uri/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
