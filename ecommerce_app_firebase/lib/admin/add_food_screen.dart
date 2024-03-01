import 'dart:io';

import 'package:ecommerce_app_firebase/services/database_services.dart';
import 'package:ecommerce_app_firebase/utils/utils.dart';
import 'package:ecommerce_app_firebase/widget/app_widget.dart';

import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddFood extends StatefulWidget {
  const AddFood({super.key});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  final List<String> fooditems = ['Ice-cream', 'Burger', 'Salad', 'Pizza'];
  String? value;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController detailcontroller = TextEditingController();
  bool isLoading = false;
  File? selectedImage;

  void pickImage() async {
    final image = await Utils.pickImage();
    if (image != null) {
      setState(() {
        selectedImage = image;
      });
    }
  }

  void uploadItem() async {
    setState(() {
      isLoading = true;
    });
    if (selectedImage != null &&
        namecontroller.text != "" &&
        pricecontroller.text != "" &&
        detailcontroller.text != "") {
      String downloadUrl = await DatabaseService.uploadFile(selectedImage!);

      Map<String, dynamic> addItem = {
        "Image": downloadUrl,
        "Name": namecontroller.text,
        "Price": pricecontroller.text,
        "Detail": detailcontroller.text
      };
      await DatabaseService.addProduct(addItem, value!).then((value) {
        setState(() {
          isLoading = false;
        });
        Utils.showToast("Products Added");
        selectedImage = null;
        namecontroller.clear();
        pricecontroller.clear();
        detailcontroller.clear();
        setState(() {});
      }).onError((error, stackTrace) {
        setState(() {
          isLoading = false;
        });
        Utils.showToast("Error Occured");
      });
    } else {
      Utils.showToast("All Feild are Requried");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Color(0xFF373866),
            )),
        centerTitle: true,
        title: const Text(
          "Add Item",
          style: AppWidget.titleHeadingStyle2,
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        progressIndicator: const SpinKitFadingCircle(
          color: Colors.black,
        ),
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(
                left: 20.0, right: 20.0, top: 20.0, bottom: 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Upload the Item Picture",
                  style: AppWidget.titleHeadingStyle(context),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                selectedImage == null
                    ? GestureDetector(
                        onTap: () {
                          pickImage();
                        },
                        child: Center(
                          child: Material(
                            elevation: 4.0,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(Icons.camera_alt),
                            ),
                          ),
                        ),
                      )
                    : Center(
                        child: Material(
                          elevation: 4.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                  ))),
                        ),
                      ),
                Text(
                  "Item Name",
                  style: AppWidget.titleHeadingStyle(context),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                addItemFields(
                  context,
                  namecontroller,
                  "Enter Item Name",
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Text(
                  "Item Price",
                  style: AppWidget.titleHeadingStyle(context),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                addItemFields(
                  context,
                  pricecontroller,
                  "Enter Item Price",
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Text(
                  "Item Detail",
                  style: AppWidget.titleHeadingStyle(context),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                addItemFields(
                  context,
                  detailcontroller,
                  "Enter Item Details ",
                  maxlength: 5,
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Select Category",
                  style: AppWidget.titleHeadingStyle(context),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: const Color(0xFFececf8),
                      borderRadius: BorderRadius.circular(10)),
                  child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                    items: fooditems
                        .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                              ),
                            )))
                        .toList(),
                    onChanged: ((value) => setState(() {
                          this.value = value;
                        })),
                    dropdownColor: Colors.white,
                    hint: const Text("Select Category"),
                    iconSize: 36,
                    isExpanded: true,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    value: value,
                  )),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                GestureDetector(
                  onTap: () {
                    uploadItem();
                  },
                  child: Center(
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        width: 150,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                          child: Text(
                            "Add",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container addItemFields(
    BuildContext context,
    TextEditingController controller,
    String hintText, {
    int? maxlength = 1,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: const Color(0xFFececf8),
          borderRadius: BorderRadius.circular(10)),
      child: TextField(
        maxLines: maxlength,
        controller: controller,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: AppWidget.lightColorStyle2),
      ),
    );
  }
}
