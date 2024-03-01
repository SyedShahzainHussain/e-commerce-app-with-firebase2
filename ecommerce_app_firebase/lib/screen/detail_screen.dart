import 'package:ecommerce_app_firebase/services/database_services.dart';
import 'package:ecommerce_app_firebase/services/shared_preference_helper.dart';
import 'package:ecommerce_app_firebase/utils/utils.dart';
import 'package:ecommerce_app_firebase/widget/app_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DetailsScreen extends StatefulWidget {
  final String image;
  final String title;
  final String description;
  final String price;

  const DetailsScreen(
      {super.key,
      required this.image,
      required this.title,
      required this.description,
      required this.price});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  int a = 1;
  int total = 0;
  String? userId;

  getUserId() async {
    final user = await SharedPreferenceHelper.getUser();
    userId = user["userId"];
  }

  @override
  void initState() {
    total = int.parse(widget.price);
    getUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(8.0),
              child: Image.network(
                widget.image,
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height / 2.5,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: AppWidget.titleHeadingStyle2,
                    ),
                    // Text(
                    //   "Chickpea Salad",
                    //   style: AppWidget.titleHeadingStyle(context),
                    // ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    if (a > 1) {
                      a--;
                      total = total - int.parse(widget.price);
                      setState(() {});
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.remove,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  a.toString(),
                  style: AppWidget.titleHeadingStyle2,
                ),
                const SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    a++;
                    total = total + int.parse(widget.price);
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              widget.description,
              style: AppWidget.lightColorStyle2,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Text(
                  "Delivery Time",
                  style: AppWidget.titleHeadingStyle(context),
                ),
                const SizedBox(
                  width: 25.0,
                ),
                const Icon(
                  Icons.alarm,
                  color: Colors.black54,
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Text(
                  "30 min",
                  style: AppWidget.titleHeadingStyle(context),
                )
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Price",
                        style: AppWidget.titleHeadingStyle(context),
                      ),
                      Text("\$$total", style: AppWidget.titleHeadingStyle2),
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      final usercartData = {
                        "Name": widget.title,
                        "Quantity": a.toString(),
                        "Total": total.toString(),
                        "Image": widget.image
                      };

                      DatabaseService.addToCart(usercartData, userId!)
                          .then((value) {
                        total = int.parse(widget.price);
                        a = 1;
                        setState(() {
                          
                        });
                        Utils.showToast("Prdoucts Added To Cart");
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(children: [
                        const Text(
                          "Add To Cart",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: const Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                          ),
                        )
                      ]),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
