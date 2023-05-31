import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ntfp_cart/Constants/error_handling.dart';
import 'package:ntfp_cart/Constants/error_handlingStream.dart';
import 'package:ntfp_cart/Constants/global_variables.dart';
import 'package:ntfp_cart/Constants/utils.dart';
import 'package:ntfp_cart/Models/product.dart';
import 'package:ntfp_cart/Provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HomeServices {
  Future<List<Product>> fetchCategoryProducts({
    required BuildContext context,
    required String category,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      // http.Response res =
      //     await http.get(Uri.parse('$uri/ProductSearch'), headers: {
      //   'Content-Type': 'application/json; charset=UTF-8',
      // });
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('GET', Uri.parse('$uri/ProductSearch'));
      request.body = json.encode([
        {
          'productName': "",
          'catogory': category,
        }
      ]);
      request.headers.addAll(headers);
      print("hello11");
      http.StreamedResponse res = await request.send();
      String responseBody = await res.stream.bytesToString();
      dynamic jsonData = json.decode(responseBody);
      print(jsonData);
      print("hello");

      httpErrorHandleStream(
        response: res,
        context: context,
        onSuccess: () {
          print("catogory succedd");
          for (int i = 0; i < jsonDecode(responseBody).length; i++) {
            productList.add(
              Product.fromJson(
                jsonEncode(
                  jsonDecode(responseBody)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
      print("product catogory errr");
    }
    return productList;
  }

  Future<Product> fetchDealOfDay({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Product product = Product(
        name: '',
        description: '',
        quantity: 1,
        images: [],
        category: '',
        price: 0);

    try {
      // http.Response res =
      //     await http.get(Uri.parse('$uri/api/deal-of-day'), headers: {
      //   'Content-Type': 'application/json; charset=UTF-8',
      //   'x-auth-token': userProvider.user.token,
      // });
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('GET', Uri.parse('$uri/DealOfTheDay'));
      request.body = json.encode({});
      request.headers.addAll(headers);
      print("hello11");
      http.StreamedResponse res = await request.send();
      String responseBody = await res.stream.bytesToString();
      dynamic jsonData = json.decode(responseBody);
      print(jsonData);
      print("hello");

      httpErrorHandleStream(
        response: res,
        context: context,
        onSuccess: () {
          product = Product.fromJson(res.toString());
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
      print("error deal of the day");
    }
    return product;
  }
}
