import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_firebase/services/shared_preference_helper.dart';
import 'package:ecommerce_app_firebase/utils/routes/route_name.dart';
import 'package:ecommerce_app_firebase/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthViewModel with ChangeNotifier {
  final firebaseAuth = FirebaseAuth.instance;
  final firebasecore = FirebaseFirestore.instance;

  // ! login loading
  bool _isLoginLoading = false;
  bool get isLoginLoading => _isLoginLoading;
  setLoginLoading(bool loginLoading) {
    _isLoginLoading = loginLoading;
    notifyListeners();
  }

  // ! sign up loading
  bool _isSignUpLoading = false;
  bool get isSignUpLoading => _isSignUpLoading;
  setSignUpLoading(bool signUpLoading) {
    _isSignUpLoading = signUpLoading;
    notifyListeners();
  }

  // ! forgot password loading
  bool _isForgotLoading = false;
  bool get isForgotLoading => _isForgotLoading;
  setForgotLoading(bool forgotLoading) {
    _isForgotLoading = forgotLoading;
    notifyListeners();
  }

  // ! login
  Future<void> login(String email, String password, context) async {
    setLoginLoading(true);
    try {
      await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        setLoginLoading(false);
        Navigator.pushNamedAndRemoveUntil(
            context, RouteName.bottomNav, (route) => false);
        Utils.showToast("Login Success");
      });
    } on FirebaseAuthException catch (error) {
      setLoginLoading(false);
      if (error.code == "user-not-found") {
        Utils.showToast("User not Found");
      } else if (error.code == "wrong-password") {
        Utils.showToast("Email and Password are wrong");
      } else if (error.code == "invalid-email") {
        Utils.showToast("Invalid credentials");
      } else if (error.code == "invalid-credential") {
        Utils.showToast("Invalid credentials");
      } else {
        Utils.showToast("Error Occured");
      }
    }
  }

  // ! sign up
  Future<void> signUp(
      String username, String email, String password, context) async {
    setSignUpLoading(true);
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = userCredential.user;
      await SharedPreferenceHelper.saveUser(
        email,
        password,
        user!.uid,
        username,
        "0",
      );
      firebasecore.collection("users").doc(user.uid).set({
        "email": user.email,
        "username": username,
        "wallet": 0,
      }).then((value) {
        setSignUpLoading(false);
        Navigator.pushNamedAndRemoveUntil(
            context, RouteName.bottomNav, (route) => false);
        Utils.showToast("Register Successfully");
      });
    } on FirebaseAuthException catch (error) {
      setSignUpLoading(false);
      if (error.code == "weak-password") {
        Utils.showToast("Your password is weak");
      } else if (error.code == "email-already-in-use") {
        Utils.showToast("Account Already exsists");
      }
    }
  }

  // ! forgot password
  Future<void> forgotPassword(String email) async {
    setForgotLoading(true);
    try {
      firebaseAuth.sendPasswordResetEmail(email: email).then((value) {
        setForgotLoading(false);
        Utils.showToast("Password Reset Email has been sent !");
      });
    } on FirebaseAuthException catch (error) {
      setForgotLoading(false);
      if (error.code == "user-not-found") {
        Utils.showToast("No user found");
      } else if (error.code == "invalid-email") {
        Utils.showToast("Invalid email");
      } else {
        Utils.showToast("Error Occured");
      }
    }
  }
}
