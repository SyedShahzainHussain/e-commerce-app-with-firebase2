import 'dart:io';

import 'package:ecommerce_app_firebase/services/database_services.dart';
import 'package:ecommerce_app_firebase/services/shared_preference_helper.dart';
import 'package:ecommerce_app_firebase/utils/routes/route_name.dart';
import 'package:ecommerce_app_firebase/utils/utils.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic>? data;
  File? selectedImage;
  String? profile;

  void pickImage() async {
    final image = await Utils.pickImage();
    if (image != null) {
      selectedImage = image;
      setState(() {
        uploadItem();
      });
    }
  }

  uploadItem() async {
    if (selectedImage != null) {
      profile = await DatabaseService.uploadFile(selectedImage!);
      await SharedPreferenceHelper.updateProfilePic(profile!);
      setState(() {});
    }
  }

  getthesharedpref() async {
    data = await SharedPreferenceHelper.getUser();
    profile = data!["profile"];
    setState(() {});
  }

  onthisload() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    onthisload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: data == null
          ? const CircularProgressIndicator()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom:5.0),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 4.3,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.elliptical(
                                      MediaQuery.sizeOf(context).width, 125.0))),
                        ),
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height / 6.5),
                            child: Material(
                              elevation: 10.0,
                              borderRadius: BorderRadius.circular(60),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(60),
                                child: selectedImage == null
                                    ? GestureDetector(
                                        onTap: () {
                                          pickImage();
                                        },
                                        child: profile == null || profile == ""
                                            ? Image.asset(
                                                "assets/images/boy.jpg",
                                                height: 120,
                                                width: 120,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.network(
                                                profile!,
                                                height: 120,
                                                width: 120,
                                                fit: BoxFit.cover,
                                              ),
                                      )
                                    : Image.file(
                                        selectedImage!,
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 70.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                data!["username"],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 23.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    profileWidget(Icons.person, "Name", data!["username"]),
                    const SizedBox(
                      height: 30.0,
                    ),
                    profileWidget(Icons.email, "Email", data!["email"]),
                    const SizedBox(
                      height: 30.0,
                    ),
                    termswidget(Icons.description, "Terms and Condition", () {}),
                    const SizedBox(
                      height: 30.0,
                    ),
                    termswidget(Icons.admin_panel_settings, "Admin", () {
                      Navigator.pushNamed(context, RouteName.admin);
                    }),
                    const SizedBox(
                      height: 30.0,
                    ),
                    termswidget(Icons.delete, "Delete Account", () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) => AlertDialog(
                                backgroundColor: Colors.black,
                                content: const Text("Are you sure?",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    )),
                                title: const Text(
                                    "You Want To Delete Your Account",
                                    style: TextStyle(color: Colors.white)),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "NO",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        DatabaseService.deleteAccount(context);
                                      },
                                      child: const Text("YES",
                                          style: TextStyle(color: Colors.white)))
                                ],
                              ));
                    }),
                    const SizedBox(
                      height: 30.0,
                    ),
                    termswidget(Icons.logout, "LogOut", () {
                      DatabaseService.signout(context);
                    }),
                  ],
                ),
              ),
            ),
    );
  }

  GestureDetector termswidget(
      IconData icon, String title, void Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          elevation: 2.0,
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 15.0,
              horizontal: 10.0,
            ),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.black,
                ),
                const SizedBox(
                  width: 20.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container profileWidget(IconData icon, String title, String info) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Material(
        borderRadius: BorderRadius.circular(10),
        elevation: 2.0,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 15.0,
            horizontal: 10.0,
          ),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.black,
              ),
              const SizedBox(
                width: 20.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    info,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
