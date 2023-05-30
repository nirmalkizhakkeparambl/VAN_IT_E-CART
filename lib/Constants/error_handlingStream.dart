import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ntfp_cart/Constants/utils.dart';

void httpErrorHandleStream({
  required http.StreamedResponse response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      showSnackBar(context, jsonDecode(response.toString())['msg']);
      break;
    case 500:
      showSnackBar(context, jsonDecode(response.toString())['error']);
      break;
    default:
      showSnackBar(context, response.toString());
  }
}
