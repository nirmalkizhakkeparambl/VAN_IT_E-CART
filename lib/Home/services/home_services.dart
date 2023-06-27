import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ntfp_cart/Constants/error_handling.dart';
import 'package:ntfp_cart/Constants/error_handlingStream.dart';
import 'package:ntfp_cart/Constants/global_variables.dart';
import 'package:ntfp_cart/Constants/utils.dart';
import 'package:ntfp_cart/Models/Productnw.dart';
import 'package:ntfp_cart/Models/product.dart';
import 'package:ntfp_cart/Provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HomeServices {
  List<Productnw> product = [];
  Future<List<Product>> fetchCategoryProducts({
    required BuildContext context,
    required String category,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];

    // List<Product> products = parseProducts(jsonResponse);
    try {
      // http.Response res =
      //     await http.get(Uri.parse('$uri/ProductSearch'), headers: {
      //   'Content-Type': 'application/json; charset=UTF-8',
      // });
      var headers = {'Content-Type': 'application/json'};
      var request = http.Request('GET', Uri.parse('$uri/ProductSearch'));
      request.body = json.encode({
        'productName': "",
        'catogory': category,
      });
      request.headers.addAll(headers);

      http.StreamedResponse res = await request.send();
      // final List<int> responseBytes = (await res.stream.toList());
      // final String responseBody = utf8.decode(responseBytes);
      // final jsonResponse = jsonDecode(responseBody);
      // final List<int> responseBytes = await response.stream.toList();
      // final String responseBody = utf8.decode(responseBytes);
      // final jsonResponse = jsonDecode(responseBody);
      final List<List<int>> responseBytesList = await res.stream.toList();
      final List<int> responseBytes =
          responseBytesList.expand((bytes) => bytes).toList();
      final String responseBody = utf8.decode(responseBytes);
      String jsonString = responseBody.substring(1, responseBody.length - 1);
      String withoutCommas = responseBody.replaceAll('{', '[{');

      String withoutCommaaa = withoutCommas.replaceAll('}', '}]');
      final jsonResponse = jsonDecode(withoutCommaaa);
      // String jsonResponc = {
      //   "product_id": 21,r
      //   "product_name": "umberlaa",
      //   "product_discription": "red ",
      //   "product_quntity": "10",
      //   "product_catogory": "middle",
      //   "product_price": "1420","};
      // print("JSONRESSS" + jsonResponse);
      print("BODU" + jsonResponse.toString());
      print("hello" + responseBody);

      httpErrorHandleStream(
        response: res,
        context: context,
        onSuccess: () {
          // final jsonResponse = jsonDecode(responseBody) as List;
          // final List<String> jsonArray = [];
          // for (final item in jsonResponse) {
          //   final Map<String> jsonMap = Map<String, dynamic>.from(item);
          //   jsonArray.add(jsonMap);
          // }
          print("PRODUCTTLENN" +
              jsonDecode(jsonResponse.toString()).length.toString());
          print("catogory succedd");
          // for (int i = 0; i < jsonDecode(jsonResponse.toString()).length; i++) {
          //   print("PRODUCTT" + productList.toString());
          //   productList.add(
          //     Product.fromJson(
          //       // jsonEncode(
          //       jsonDecode(jsonResponse.toString())[i],
          //     ),
          //     // ),
          //   );
          // }
          List<dynamic> jsonList = jsonDecode(jsonResponse.toString());
          for (int i = 0; i < jsonList.length; i++) {
            productList.add(
              Product.fromJson(
                jsonList[i],
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
      print("product catogory errr  " + e.toString());
    }
    return productList;
  }

  Future<List<Productnw>> fetchDealOfDay(
      {required BuildContext context}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('GET', Uri.parse('$uri/DealOfTheDay'));
    request.body = json.encode([{}]);
    request.headers.addAll(headers);

    try {
      print("helloDealOf");
      http.StreamedResponse res = await request.send();
      String responseBody = await res.stream.bytesToString();
      dynamic jsonData = json.decode(responseBody);

      if (jsonData is List &&
          jsonData.length == 1 &&
          jsonData[0]['Status'] == 'Not Found!') {
        // Return an empty list since the response indicates "Not Found"
        return [];
      } else {
        print(jsonData);
        print("helloDealOfDay");
        List<Productnw> products =
            (jsonData as List<dynamic>).map((jsonObject) {
          return Productnw.fromJson(jsonObject);
        }).toList();
        return products;
      }
    } catch (e) {
      print("Error fetching deal of the day: $e");
      return [];
    }
  }

  // Future<List> fetchDealOfDay({
  //   required BuildContext context,
  // }) async {
  //   final userProvider = Provider.of<UserProvider>(context, listen: false);
  //   // // Productnw product = Product(
  //   // //     name: '',
  //   // //     description: '',
  //   // //     quantity: 1,
  //   // //     images: [],
  //   // //     category: '',
  //   // //     price: 0);

  //   // try {
  //   //   // http.Response res =
  //   //   //     await http.get(Uri.parse('$uri/api/deal-of-day'), headers: {
  //   //   //   'Content-Type': 'application/json; charset=UTF-8',
  //   //   //   'x-auth-token': userProvider.user.token,
  //   //   // });
  //   //   var headers = {'Content-Type': 'application/json'};
  //   //   var request = http.Request('GET', Uri.parse('$uri/DealOfTheDay'));
  //   //   request.body = json.encode({});
  //   //   request.headers.addAll(headers);
  //   //   print("helloDealOf");
  //   //   http.StreamedResponse res = await request.send();
  //   //   String responseBody = await res.stream.bytesToString();
  //   //   dynamic jsonData = json.decode(responseBody);
  //   //   print(jsonData);
  //   //   print("helloDealOfDay");
  //   //   product = (json.decode(responseBody) as List<dynamic>).map((jsonObject) {
  //   //     return Productnw.fromJson(jsonObject);
  //   //   }).toList();
  //   //   httpErrorHandleStream(
  //   //     response: res,
  //   //     context: context,
  //   //     onSuccess: () {
  //   //       Productnw product = Productnw.fromJson(jsonData);
  //   //     },
  //   //   );
  //   // } catch (e) {
  //   //   // showSnackBar(context, e.toString());
  //   //   print("error deal of the day");
  //   // }
  //   // return product;
  //   var headers = {'Content-Type': 'application/json'};
  //   var request = http.Request(
  //       'GET', Uri.parse('http://68.178.167.39/E_CART_API/API/DealOfTheDay'));
  //   request.body = json.encode([{}]);
  //   request.headers.addAll(headers);

  //   try {
  //     print("helloDealOf");
  //     http.StreamedResponse res = await request.send();
  //     String responseBody = await res.stream.bytesToString();
  //     dynamic jsonData = json.decode(responseBody);
  //     print(jsonData);
  //     print("helloDealOfDay");
  //     List<Productnw> products = [];
  //     if (jsonData is List<dynamic>) {
  //       products = jsonData
  //           .map((jsonObject) => Productnw.fromJson(jsonObject))
  //           .toList();
  //     } else if (jsonData is Map<String, dynamic>) {
  //       products.add(Productnw.fromJson(jsonData));
  //     }
  //     return products;
  //   } catch (e) {
  //     print("Error fetching deal of the day: $e");
  //     return [];
  //   }
  // }
}
