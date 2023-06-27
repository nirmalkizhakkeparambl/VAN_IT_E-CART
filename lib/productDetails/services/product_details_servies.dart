import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ntfp_cart/Constants/error_handling.dart';
import 'package:ntfp_cart/Constants/global_variables.dart';
import 'package:ntfp_cart/Constants/utils.dart';
import 'package:ntfp_cart/Models/Productnw.dart';
import 'package:ntfp_cart/Models/product.dart';
import 'package:ntfp_cart/Models/user.dart';
import 'package:ntfp_cart/Provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ProductDetailsServices {
  void addToCart({
    required BuildContext context,
    required Productnw product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/add-to-cart'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': product.productId,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          User user =
              userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      //  showSnackBar(context, e.toString());
    }
  }

  void rateProduct({
    required BuildContext context,
    required Productnw product,
    required double rating,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/rate-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': product.productId,
          'rating': rating,
        }),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {},
      );
    } catch (e) {
      //  showSnackBar(context, e.toString());
    }
  }
}
