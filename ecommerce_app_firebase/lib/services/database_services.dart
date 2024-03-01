import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_firebase/utils/routes/route_name.dart';
import 'package:ecommerce_app_firebase/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class DatabaseService {
  // ! update wallet
  static Future<void> updateUserWallet(String id, String amount) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update({"wallet": amount});
  }

  // ! signout
  static Future<void> signout(context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(
        context, RouteName.login, (route) => false);
  }

  // ! delete account
  static Future<void> deleteAccount(context) async {
    final authUser = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(authUser!.uid)
        .delete()
        .then((value) async {
      await authUser.delete();
      Navigator.pushNamedAndRemoveUntil(
          context, RouteName.signUp, (route) => false);
      Utils.showToast("Account Deleted");
    });
  }

  //! upload file to firebasestorage

  static Future<String> uploadFile(File image) async {
    String fileType = image.path.split('.').last;

    Reference reference = FirebaseStorage.instance
        .ref()
        .child("products")
        .child(DateTime.now().toString());
    UploadTask uploadTask = reference.putFile(
        File(image.path).absolute, SettableMetadata(contentType: fileType));
    TaskSnapshot? tasksnapshot = await uploadTask;
    String imageUrl = await tasksnapshot.ref.getDownloadURL();

    return imageUrl;
  }

  // ! admin add product

  static Future<void> addProduct(
      Map<String, dynamic> userInfo, String name) async {
    await FirebaseFirestore.instance.collection(name).add(userInfo);
  }

  // ! home stream
  static Stream<QuerySnapshot<Map<String, dynamic>>> addStream(String name) {
    return FirebaseFirestore.instance.collection(name).snapshots();
  }

  // ! add to cart
  static Future<void> addToCart(
      Map<String, dynamic> cartInfo, String userId) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("cart")
        .add(cartInfo);
  }

  // ! cart Stream
  static Stream<QuerySnapshot<Map<String, dynamic>>> getCartStream(
      String userId) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("cart")
        .snapshots();
  }
}
