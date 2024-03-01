import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Utils {
  static showToast(String msg) {
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static showSpinner() {
    return const SpinKitChasingDots(
      color: Color(0Xffff5722),
    );
  }

  // ! pickImage
  static Future<File?> pickImage() async {
    ImagePicker _picker = ImagePicker();
    XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      return File(file.path);
    }
    return null;
  }

  // ! stripe payment

  // static Map<String, dynamic>? paymentIntent;

  // static Future<void> makePayment(String amount, BuildContext context) async {
  //   try {
  //     paymentIntent = await createPaymentIntent(amount, "USD");
  //     await Stripe.instance
  //         .initPaymentSheet(
  //             paymentSheetParameters: SetupPaymentSheetParameters(
  //       style: ThemeMode.dark,
  //       merchantDisplayName: "Shahzain",
  //       paymentIntentClientSecret: paymentIntent!['client_secret'],
  //     ))
  //         .then((value) {
  //       displayPaymentSheet(content);
  //     });
  //   } catch (e, s) {
  //     log("error$e$s");
  //   }
  // }

  // // ! display payment
  // static Future<void> displayPaymentSheet(context) async {
  //   try {
  //     await Stripe.instance.presentPaymentSheet().then((value) {
  //       showDialog(
  //           context: context,
  //           builder: (_) => const AlertDialog(
  //                 content: Column(
  //                   children: [
  //                     Row(
  //                       children: [
  //                         Icon(
  //                           Icons.check,
  //                           color: Colors.green,
  //                         ),
  //                         Text("Payment Success")
  //                       ],
  //                     )
  //                   ],
  //                 ),
  //               ));
  //       paymentIntent = null;
  //     }).onError((error, stackTrace) {
  //       log(" $error");
  //     });
  //   } on StripeException catch (_) {
  //     showDialog(
  //         context: context,
  //         builder: (context) => const AlertDialog(
  //               content: Text("Cancelled"),
  //             ));
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  // // ! createPaymentIntent
  // static Future<dynamic> createPaymentIntent(
  //   String amount,
  //   String currency,
  // ) async {
  //   try {
  //     Map<String, dynamic> body = {
  //       'amount': calculateAmount(amount),
  //       'currency': currency,
  //       'payment_method_types[]': 'card'
  //     };

  //     var response = await post(
  //       Uri.parse('https://api.stripe.com/v1/payment_intents'),
  //       headers: {
  //         "Authorization": "Bearer $secretkey",
  //         "Content-Type": "application/x-www-form-urlencoded"
  //       },
  //       body: body,
  //     );
  //     log(response.body.toString());
  //     return jsonDecode(response.body);
  //   } catch (e) {
  //     log(e.toString());
  //   }
  // }

  // static calculateAmount(String amount) {
  //   final calculatedAmount = (int.parse(amount) * 100);
  //   return calculatedAmount.toString();
  // }
}
