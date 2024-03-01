import 'package:ecommerce_app_firebase/pages/tabs/home.dart';
import 'package:ecommerce_app_firebase/pages/tabs/order.dart';
import 'package:ecommerce_app_firebase/pages/tabs/profile.dart';
import 'package:ecommerce_app_firebase/pages/tabs/wallet.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentIndex = 0;
  final List _pages = [
    const HomeScreen(),
    const Order(),
     const Wallet(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      bottomNavigationBar: CurvedNavigationBar(
        index: currentIndex,
        onTap: (index) {
          currentIndex = index;
          setState(() {});
        },
        backgroundColor: Colors.white,
        color: Colors.black,
        animationDuration: const Duration(milliseconds: 50),
        height: 65,
        items: const [
          Icon(
            Icons.home,
            color: Colors.white,
          ),
          Icon(
            Icons.shopping_bag_outlined,
            color: Colors.white,
          ),
          Icon(
            Icons.wallet,
            color: Colors.white,
          ),
          Icon(
            Icons.person_outline,
            color: Colors.white,
          ),
        ],
      ),
      body: _pages[currentIndex],
    );
  }
}
