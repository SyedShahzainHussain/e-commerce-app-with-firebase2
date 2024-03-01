import 'package:ecommerce_app_firebase/screen/auth/sign_up_screen.dart';
import 'package:ecommerce_app_firebase/utils/utils.dart';
import 'package:ecommerce_app_firebase/viewModel/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController useremailcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  save() {
    if (_formkey.currentState!.validate()) {
      String email = useremailcontroller.text.trim();
      context.read<AuthViewModel>().forgotPassword(
            email,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthViewModel>(
        builder: (context,value,_)=>
         ModalProgressHUD(
          inAsyncCall: value.isForgotLoading,
          progressIndicator: Utils.showSpinner(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 70.0,
                ),
                Container(
                  alignment: Alignment.topCenter,
                  child: const Text(
                    "Password Recovery",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                const Text(
                  "Enter your Email",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                Expanded(
                    child: Form(
                        key: _formkey,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: ListView(
                            children: [
                              Container(
                                padding: const EdgeInsets.only(left: 10.0),
                                // decoration: BoxDecoration(
                                //   border:
                                //       Border.all(color: Colors.black, width: 2.0),
                                //   borderRadius: BorderRadius.circular(30),
                                // ),
                                child: TextFormField(
                                  controller: useremailcontroller,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Email';
                                    }
                                    return null;
                                  },
                                  style: const TextStyle(color: Colors.black),
                                  decoration:  InputDecoration(
                                    
                                      hintText: "Email",
                                      hintStyle: const TextStyle(
                                          fontSize: 18.0, color: Colors.black),
                                      prefixIcon: const Icon(
                                        Icons.person,
                                        color: Colors.black,
                                        size: 30.0,
                                      ),
                                      focusedBorder:  OutlineInputBorder(
                                         borderRadius: BorderRadius.circular(30),
                                         borderSide: const BorderSide(color: Colors.black,width: 2.0)
                                      ),
                                      border: OutlineInputBorder(
                                         borderRadius: BorderRadius.circular(30),
                                         borderSide: const BorderSide(color: Colors.black,width: 2.0)
                                      ),enabledBorder:   OutlineInputBorder(
                                         borderRadius: BorderRadius.circular(30),
                                         borderSide: const BorderSide(color: Colors.black,width: 2.0)
                                      )),
                                ),
                              ),
                              const SizedBox(
                                height: 40.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  save();
                                },
                                child: Container(
                                  width: 140,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Center(
                                    child: Text(
                                      "Send Email",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 50.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Don't have an account?",
                                    style: TextStyle(
                                        fontSize: 18.0, color: Colors.black),
                                  ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SignUpScreen()));
                                    },
                                    child: const Text(
                                      "Create",
                                      style: TextStyle(
                                          color: Color.fromARGB(225, 184, 166, 6),
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
