import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' show TextStyle;
import 'package:flutter/src/painting/basic_types.dart' as prefix;
import 'package:ntfp_cart/CommonWidgets/loader.dart';
import 'package:ntfp_cart/Home/services/home_services.dart';
import 'package:ntfp_cart/Models/Productnw.dart';
import 'package:ntfp_cart/Models/product.dart';
import 'package:ntfp_cart/productDetails/screens/product_details_screen.dart';

class DealOfDay extends StatefulWidget {
  const DealOfDay({Key? key}) : super(key: key);

  @override
  State<DealOfDay> createState() => _DealOfDayState();
}

class _DealOfDayState extends State<DealOfDay> {
  // Productnw? product;
  List<Productnw> product = [];
  final HomeServices homeServices = HomeServices();

  @override
  void initState() {
    super.initState();
    fetchDealOfDay();
  }

  void fetchDealOfDay() async {
    List<Productnw> fetchedProducts =
        await homeServices.fetchDealOfDay(context: context);
    if (mounted) {
      setState(() {
        product = fetchedProducts;
      });
    }
  }

  void navigateToDetailScreen() {
    Navigator.pushNamed(
      context,
      ProductDetailScreen.routeName,
      arguments: product,
    );
  }

  @override
  Widget build(BuildContext context) {
    return product.isEmpty
        ? const Loader()
        : GestureDetector(
            onTap: navigateToDetailScreen,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 10, top: 15),
                  child: const Text(
                    'Deal of the day',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: product.map((currentProduct) {
                      return Column(
                        children: [
                          Image.network(
                            currentProduct.productImages[0],
                            height: 235,
                            fit: BoxFit.fitHeight,
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 15),
                            alignment: Alignment.topLeft,
                            child: Text(
                              '\$${currentProduct.productPrice}',
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(
                                left: 15, top: 5, right: 40),
                            child: Text(
                              currentProduct.productName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ).copyWith(left: 15),
                  alignment: Alignment.topLeft,
                  child: const Text(
                    'See all deals',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          );
    // if (product == null) {
    //   return CircularProgressIndicator();
    // } else {
    //   return ListView.builder(
    //     itemCount: product.length,
    //     itemBuilder: (BuildContext context, int index) {
    //       Productnw productb = product[0];
    //       return ListTile(
    //         title: Text(productb.productName),
    //         subtitle: Text(productb.productDescription),
    //       );
    //     },
    //   );
    // }
    // return Container();
  }
}
