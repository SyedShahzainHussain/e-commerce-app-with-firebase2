import 'dart:async';

import 'package:ecommerce_app_firebase/services/database_services.dart';
import 'package:ecommerce_app_firebase/services/shared_preference_helper.dart';
import 'package:ecommerce_app_firebase/utils/utils.dart';
import 'package:ecommerce_app_firebase/widget/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  Stream? foodStream;
  String? userid;
  String? wallet;
  int total = 0;
  int amount2 = 0;
  late Timer _timer;
  void getUserId() async {
    final user = await SharedPreferenceHelper.getUser();
    userid = user["userId"];
    wallet = user["wallet"];
    setState(() {
      getCart();
    });
  }

  void getCart() {
    foodStream = DatabaseService.getCartStream(userid!);
  }

  @override
  void initState() {
    getUserId();
    _timer = Timer(const Duration(seconds: 3), () {
      amount2 = total;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget getCartPrdouct() {
    return StreamBuilder(
        stream: foodStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SpinKitFadingCircle(
                color: Colors.black,
              ),
            );
          } else if (snapshot.hasData) {
            total = snapshot.data.docs.fold(
                0,
                (previousValue, element) =>
                    previousValue + int.parse(element["Total"]));
            return ListView.separated(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final data = snapshot.data.docs[index];
                  return Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                    ),
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              height: 100,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0)),
                              child: Center(child: Text(data!["Quantity"])),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Material(
                              elevation: 4.0,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(50)),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(data!["Image"]),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  data!["Name"],
                                  style: AppWidget.titleHeadingStyle(context),
                                ),
                                Text(
                                  "\$${data!["Total"]}",
                                  style: AppWidget.titleHeadingStyle(context),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                itemCount: snapshot.data.docs.length);
          } else {
            return const Center(
              child: SpinKitFadingCircle(
                color: Colors.black,
              ),
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4.0,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        title: const Text(
          "Food Cart",
          style: AppWidget.titleHeadingStyle2,
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height -
              MediaQuery.paddingOf(context).top -
              MediaQuery.paddingOf(context).bottom -
              kToolbarHeight -
              kBottomNavigationBarHeight,
          child: Container(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                getCartPrdouct(),
                const Spacer(),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Price",
                        style: AppWidget.titleHeadingStyle(context),
                      ),
                      Text(
                        "\$$amount2",
                        style: AppWidget.titleHeadingStyle2,
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  onTap: () async {
                    int wallets = int.parse(wallet!);
                    if (wallets < amount2) {
                      Utils.showToast(
                          "Your Wallet Amount is less for this product please increase the amount in wallet");
                    } else if (amount2 == 0 ){
                       Utils.showToast("Wait For a second");
                    } else {
                      int amount = wallets - amount2;
                      await DatabaseService.updateUserWallet(
                          userid!, amount.toString());
                      await SharedPreferenceHelper.updateWallet(
                          amount.toString());
                      Utils.showToast("Your Order has been placed");

                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsets.only(
                        left: 20.0, right: 20.0, bottom: 20.0),
                    child: const Center(
                        child: Text(
                      "CheckOut",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
