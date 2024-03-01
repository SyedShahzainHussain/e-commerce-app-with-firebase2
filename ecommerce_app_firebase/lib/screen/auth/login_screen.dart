import 'package:ecommerce_app_firebase/screen/auth/sign_up_screen.dart';
import 'package:ecommerce_app_firebase/screen/forgot_pass_screen.dart';
import 'package:ecommerce_app_firebase/utils/utils.dart';
import 'package:ecommerce_app_firebase/viewModel/auth_view_model.dart';
import 'package:ecommerce_app_firebase/widget/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();

  TextEditingController useremailcontroller = TextEditingController();
  TextEditingController userpasswordcontroller = TextEditingController();

  save() {
    if (_formkey.currentState!.validate()) {
      String email = useremailcontroller.text.trim();
      String password = userpasswordcontroller.text.trim();
      FocusScope.of(context).unfocus();

      context.read<AuthViewModel>().login(email, password, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Consumer<AuthViewModel>(
      builder: (context, value, _) => ModalProgressHUD(
        inAsyncCall: value.isLoginLoading,
        progressIndicator: Utils.showSpinner(),
        child: Stack(
          children: [
            Container(
              height: MediaQuery.sizeOf(context).height / 2.5,
              width: MediaQuery.sizeOf(context).width,
              color: Colors.red,
            ),
            Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.sizeOf(context).height / 3),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  )),
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
            ),
            SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.only(
                    top: 60.0, left: 20.0, right: 20.0, bottom: 10),
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/images/logo.png",
                        fit: BoxFit.cover,
                        width: MediaQuery.sizeOf(context).width / 1.5,
                      ),
                    ),
                    const SizedBox(
                      height: 50.0,
                    ),
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, bottom: 50),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 30.0,
                              ),
                              const Text(
                                "Login",
                                style: AppWidget.titleHeadingStyle2,
                              ),
                              const SizedBox(
                                height: 30.0,
                              ),
                              TextFormField(
                                controller: useremailcontroller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Email';
                                  }
                                  return null;
                                },
                                cursorColor: const Color(0Xffff5722),
                                decoration: InputDecoration(
                                    focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0Xffff5722),
                                            width: 2)),
                                    enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0Xffff5722),
                                            width: 2)),
                                    border: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0Xffff5722),
                                            width: 2)),
                                    hintText: 'Email',
                                    hintStyle:
                                        AppWidget.titleHeadingStyle(context),
                                    prefixIcon: const Icon(
                                      Icons.email_outlined,
                                      color: Colors.black,
                                    )),
                              ),
                              const SizedBox(
                                height: 30.0,
                              ),
                              TextFormField(
                                controller: userpasswordcontroller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Enter Password';
                                  }
                                  return null;
                                },
                                obscureText: true,
                                cursorColor: const Color(0Xffff5722),
                                decoration: InputDecoration(
                                    focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0Xffff5722),
                                            width: 2)),
                                    enabledBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0Xffff5722),
                                            width: 2)),
                                    border: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0Xffff5722),
                                            width: 2)),
                                    hintText: 'Password',
                                    hintStyle:
                                        AppWidget.titleHeadingStyle(context),
                                    prefixIcon:
                                        const Icon(Icons.password_outlined)),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgotPassword()));
                                },
                                child: Container(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      "Forgot Password?",
                                      style:
                                          AppWidget.titleHeadingStyle(context),
                                    )),
                              ),
                              const SizedBox(
                                height: 40.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  save();
                                },
                                child: Material(
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    width: 200,
                                    decoration: BoxDecoration(
                                        color: const Color(0Xffff5722),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: const Center(
                                        child: Text(
                                      "LOGIN",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 70.0,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()));
                        },
                        child: Text(
                          "Don't have an account? Sign up",
                          style: AppWidget.titleHeadingStyle(context),
                        ))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
