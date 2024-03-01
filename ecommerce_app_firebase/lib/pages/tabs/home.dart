import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app_firebase/screen/detail_screen.dart';
import 'package:ecommerce_app_firebase/services/database_services.dart';
import 'package:ecommerce_app_firebase/services/shared_preference_helper.dart';
import 'package:ecommerce_app_firebase/widget/app_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../utils/routes/route_name.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? data;
  getthesharedpref() async {
    data = await SharedPreferenceHelper.getUser();

    setState(() {});
  }

  onthisload() async {
    await getthesharedpref();
    setState(() {});
  }

  void pizzaData() {
    streamData = DatabaseService.addStream("Pizza");
  }

  @override
  void initState() {
    onthisload();
    pizzaData();
    super.initState();
  }

  bool icecream = false, burger = false, pizza = false, salad = false;

  Stream? streamData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.only(
          top: 50,
          left: 20,
          bottom: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                data == null
                    ? Text("Hello Guest",
                        style: AppWidget.titleHeadingStyle(context))
                    : Text("Hello ${data!["username"]},",
                        style: AppWidget.titleHeadingStyle(context)),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, RouteName.order);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 20),
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.black,
                    ),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Text("Delicious Food", style: AppWidget.titleHeadingStyle2),
            const Text("Discover and Get Great Food",
                style: AppWidget.lightColorStyle2),
            const SizedBox(
              height: 10,
            ),
            showCategories(),
            const SizedBox(
              height: 30,
            ),
            SizedBox(
              height: 250,
              child: getProductHorizontalStream(),
            ),
            const SizedBox(
              height: 30,
            ),
            getProductVerticalStream(),
          ],
        ),
      ),
    ));
  }

  Widget getProductHorizontalStream() {
    return StreamBuilder(
      stream: streamData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: SpinKitCircle(
            color: Colors.black,
          ));
        } else if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data!.docs[index];

              return SizedBox(height: 260, child: showslideFood(context, ds));
            },
            itemCount: snapshot.data!.docs.length,
          );
        } else if (snapshot.data!.docs.length.isEmpty) {
          return const Center(
            child: Text("No Data"),
          );
        } else {
          return const Center(
              child: SpinKitCircle(
            color: Colors.black,
          ));
        }
      },
    );
  }

  Widget getProductVerticalStream() {
    return StreamBuilder(
      stream: streamData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: SpinKitCircle(
            color: Colors.black,
          ));
        } else if (snapshot.hasData) {
          return ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data!.docs[index];

              return showsVertivalFood(context, ds);
            },
            itemCount: snapshot.data!.docs.length,
          );
        } else if (snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("No Data"),
          );
        } else {
          return const Center(
              child: SpinKitCircle(
            color: Colors.black,
          ));
        }
      },
    );
  }

  Widget showCategories() {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              icecream = true;
              burger = false;
              salad = false;
              pizza = false;
              streamData = DatabaseService.addStream("Ice-cream");
              setState(() {});
            },
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: icecream ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Image.asset(
                  "assets/images/ice-cream.png",
                  color: icecream ? Colors.white : Colors.black,
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              icecream = false;
              pizza = true;
              burger = false;
              salad = false;
              streamData = DatabaseService.addStream("Pizza");
              setState(() {});
            },
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: pizza ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Image.asset(
                  "assets/images/pizza.png",
                  color: pizza ? Colors.white : Colors.black,
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              icecream = false;
              pizza = false;
              burger = true;
              salad = false;
              streamData = DatabaseService.addStream("Burger");
              setState(() {});
            },
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: burger ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Image.asset(
                  "assets/images/burger.png",
                  color: burger ? Colors.white : Colors.black,
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              icecream = false;
              pizza = false;
              burger = false;
              salad = true;
              streamData = DatabaseService.addStream("Salad");

              setState(() {});
            },
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: salad ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Image.asset(
                  "assets/images/salad.png",
                  color: salad ? Colors.white : Colors.black,
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget showslideFood(context, DocumentSnapshot ds) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          margin: const EdgeInsets.only(bottom: 5, top: 5, left: 4, right: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DetailsScreen(
                                title: ds["Name"],
                                description: ds["Detail"],
                                image: ds["Image"],
                                price: ds["Price"],
                              )));
                },
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CachedNetworkImage(
                            imageUrl: ds["Image"],
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder:
                                (context, url, progress) =>
                                    const SpinKitFadingCircle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          ds["Name"],
                          style: AppWidget.titleHeadingStyle(context),
                        ),
                        Text(
                          ds["Detail"],
                          style: AppWidget.lightColorStyle2,
                        ),
                        Text(
                          "\$${ds['Price']}",
                          style: AppWidget.titleHeadingStyle(context),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget showsVertivalFood(context, DocumentSnapshot ds) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailsScreen(
                      title: ds["Name"],
                      description: ds["Detail"],
                      image: ds["Image"],
                      price: ds["Price"],
                    )));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(8.0),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: ds["Image"],
                  width: 130,
                  height: 130,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  progressIndicatorBuilder: (context, url, progress) =>
                      const SpinKitFadingCircle(
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: Text(
                        ds["Name"],
                        style: AppWidget.titleHeadingStyle(context),
                      ),
                    ),
                    Text(
                      ds["Detail"],
                      style: AppWidget.lightColorStyle2,
                    ),
                    Text(
                      "\$${ds["Price"]}",
                      style: AppWidget.titleHeadingStyle(context),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
