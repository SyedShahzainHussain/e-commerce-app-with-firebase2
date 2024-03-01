import 'dart:convert';
import 'dart:developer';

import 'package:ecommerce_app_firebase/constants/app_constants.dart';
import 'package:ecommerce_app_firebase/services/database_services.dart';
import 'package:ecommerce_app_firebase/services/shared_preference_helper.dart';
import 'package:ecommerce_app_firebase/utils/utils.dart';
import 'package:ecommerce_app_firebase/widget/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  Map<String, dynamic>? paymentIntent;
  int? add;
  Map<String, dynamic>? data;
  TextEditingController amountcontroller = TextEditingController();

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  // ! make payment
  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, "USD");
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
        style: ThemeMode.dark,
        merchantDisplayName: "Shahzain",
        paymentIntentClientSecret: paymentIntent!['client_secret'],
      ))
          .then((value) {
        displayPaymentSheet(
          amount,
        );
      });
    } catch (e, s) {
      log("error$e$s");
    }
  }

  // ! display payment

  Future<void> displayPaymentSheet(
    String amount,
  ) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        add = int.parse(data!["wallet"].toString()) + int.parse(amount);
        await SharedPreferenceHelper.updateWallet(add.toString());
        await DatabaseService.updateUserWallet(data!["userId"], add.toString());
        showDialog(
            // ignore: use_build_context_synchronously
            context: context,
            builder: (_) => const AlertDialog(
                  backgroundColor: Colors.white,
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                          Text("Payment Success")
                        ],
                      )
                    ],
                  ),
                ));
        await ontheload();

        paymentIntent = null;
      }).onError((error, stackTrace) {
        log(" $error");
      });
    } on StripeException catch (_) {
      showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) => const AlertDialog(
                content: Text("Cancelled"),
              ));
    } catch (e) {
      log(e.toString());
    }
  }

  // ! createPaymentIntent
  Future<dynamic> createPaymentIntent(
    String amount,
    String currency,
  ) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          "Authorization": "Bearer $secretkey",
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: body,
      );
      log(response.body.toString());
      return jsonDecode(response.body);
    } catch (e) {
      log(e.toString());
    }
  }

  // ! calculateAmount
  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount) * 100);
    return calculatedAmount.toString();
  }

  getthesharedpref() async {
    data = await SharedPreferenceHelper.getUser();
    setState(() {});
  }

  Future ontheload() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: data == null
          ? const CircularProgressIndicator()
          : SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    elevation: 2.0,
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      decoration: const BoxDecoration(),
                      child: const Center(
                          child: Text(
                        "Wallet",
                        style: AppWidget.titleHeadingStyle2,
                      )),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(color: Color(0xFFF2F2F2)),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/images/wallet.png",
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(
                          width: 40.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Your Wallet",
                              style: AppWidget.lightColorStyle2,
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              "\$${data!['wallet']}",
                              style: AppWidget.titleHeadingStyle2,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Add money",
                      style: AppWidget.titleHeadingStyle2,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      moneyWidget(
                        "100",
                      ),
                      moneyWidget(
                        "500",
                      ),
                      moneyWidget(
                        "1000",
                      ),
                      moneyWidget(
                        "2000",
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      openEdit();
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: const Color(0xFF008080),
                          borderRadius: BorderRadius.circular(8)),
                      child: const Center(
                        child: Text(
                          "Add Money",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Widget moneyWidget(final String title) {
    return GestureDetector(
      onTap: () {
        makePayment(title);
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE9E2E2)),
            borderRadius: BorderRadius.circular(5)),
        child: Text(
          "\$$title ",
          style: AppWidget.titleHeadingStyle2,
        ),
      ),
    );
  }

  Future openEdit() async => await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.cancel)),
                      const SizedBox(
                        width: 60.0,
                      ),
                      const Center(
                        child: Text(
                          "Add Money",
                          style: TextStyle(
                            color: Color(0xFF008080),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text("Amount"),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38, width: 2.0),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: amountcontroller,
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: 'Enter Amount'),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        int? isInteger = int.tryParse(amountcontroller.text);

                        if (amountcontroller.text.isEmpty ||
                            amountcontroller.text == "0") {
                          Utils.showToast("Amount Field Required");
                        } else if (isInteger == null) {
                          Utils.showToast("Only Interger Value Required");
                        } else {
                          Navigator.pop(context);
                          makePayment(amountcontroller.text);
                        }
                      },
                      child: Container(
                        width: 100,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF008080),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                            child: Text(
                          "Pay",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ));
}
