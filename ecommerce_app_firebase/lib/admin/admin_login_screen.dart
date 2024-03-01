import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_firebase/utils/routes/route_name.dart';
import 'package:ecommerce_app_firebase/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController userpasswordcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFededeb),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 2),
              height: MediaQuery.sizeOf(context).height / 2,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 53, 51, 51),
                    Colors.black,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  top: Radius.elliptical(
                    MediaQuery.of(context).size.width,
                    110.0,
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: 30.0,
                  right: 30.0,
                  top: MediaQuery.sizeOf(context).height / 5),
              child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      const Text(
                        "Let's start with\nAdmin!",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Material(
                        elevation: 3.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 50.0,
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 20.0, top: 5.0, bottom: 5.0),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 160, 160, 147)),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: TextFormField(
                                    controller: usernamecontroller,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Username';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Username",
                                        hintStyle: TextStyle(
                                            color: Color.fromARGB(
                                                255, 160, 160, 147))),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 40.0,
                              ),
                              Container(
                                padding: const EdgeInsets.only(
                                    left: 20.0, top: 5.0, bottom: 5.0),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color.fromARGB(
                                            255, 160, 160, 147)),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: TextFormField(
                                    controller: userpasswordcontroller,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please Enter Password';
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Password",
                                        hintStyle: TextStyle(
                                            color: Color.fromARGB(
                                                255, 160, 160, 147))),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 40.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  loginAdmin();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: const Center(
                                    child: Text(
                                      "LogIn",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  loginAdmin() {
    if (_formkey.currentState!.validate()) {
      FirebaseFirestore.instance.collection("admin").get().then((snapshot) {
        for (var data in snapshot.docs) {
          final admin = data.data();
          if (admin["id"] != usernamecontroller.text.trim()) {
            Utils.showToast("Admin Credentials is not correct");
          } else if (admin["password"] != userpasswordcontroller.text.trim()) {
            Utils.showToast("Admin Credentials is not correct");
          } else {
            Navigator.pushNamedAndRemoveUntil(
                context, RouteName.adminhome, (route) => false);
            Utils.showToast("Admin login Success");
          }
        }
      });
    }
  }
}
