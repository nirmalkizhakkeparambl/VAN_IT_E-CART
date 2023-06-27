import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ntfp_cart/Constants/error_handling.dart';
import 'package:ntfp_cart/Models/rating.dart';
import 'package:ntfp_cart/Provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:ntfp_cart/Constants/error_handlingStream.dart';
import 'package:ntfp_cart/Constants/global_variables.dart';
import 'package:ntfp_cart/Constants/utils.dart';

class Productnw {
  final int productId;
  final String productName;
  final String productDescription;
  final int productQuantity;
  final String productCategory;
  final double productPrice;
  final List<String> productImages;
  final List<Rating> rating;
  final DateTime createdAt;
  final DateTime? modifiedAt;

  Productnw({
    required this.productId,
    required this.productName,
    required this.productDescription,
    required this.productQuantity,
    required this.productCategory,
    required this.productPrice,
    required this.productImages,
    required this.rating,
    required this.createdAt,
    this.modifiedAt,
  });

  factory Productnw.fromJson(Map<String, dynamic> json) {
    // Map<String, dynamic> rate;
    // if (json['product_rating'] == null) {
    //   rate = 00;
    // } else {
    //   rate = json['product_rating'];
    // }
    return Productnw(
      productId: json['product_id'] ?? 0,
      productName: json['product_name'] ?? "",
      productDescription: json['product_discription'] ?? "",
      productQuantity: int.parse(json['product_quntity'] ?? 0),
      productCategory: json['product_catogory'] ?? "",
      productPrice: double.parse(json['product_price'] ?? 0),
      productImages: List<String>.from(json['product_images'].split(',') ?? []),
      rating: List<Rating>.from(json['product_rating'].split(',')),
      createdAt: DateTime.parse(json['create_at']),
      modifiedAt: json['modify_at'] != null
          ? DateTime.parse(json['modify_at'])
          : DateTime(200),
    );
  }
}
