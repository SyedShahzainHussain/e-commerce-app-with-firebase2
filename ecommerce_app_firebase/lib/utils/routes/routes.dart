import 'package:ecommerce_app_firebase/admin/add_food_screen.dart';
import 'package:ecommerce_app_firebase/admin/admin_home_screen.dart';
import 'package:ecommerce_app_firebase/admin/admin_login_screen.dart';
import 'package:ecommerce_app_firebase/pages/tabs/order.dart';
import 'package:ecommerce_app_firebase/pages/tabs/profile.dart';
import 'package:ecommerce_app_firebase/pages/tabs/wallet.dart';
import 'package:ecommerce_app_firebase/screen/auth/login_screen.dart';
import 'package:ecommerce_app_firebase/screen/auth/sign_up_screen.dart';
import 'package:ecommerce_app_firebase/screen/bottom_nav.dart';
import 'package:ecommerce_app_firebase/utils/routes/route_name.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.login:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case RouteName.signUp:
        return MaterialPageRoute(builder: (context) => const SignUpScreen());
      case RouteName.order:
        return MaterialPageRoute(builder: (context) => const Order());
      case RouteName.wallet:
        return MaterialPageRoute(builder: (context) => const Wallet());
      case RouteName.profile:
        return MaterialPageRoute(builder: (context) => const Profile());
      case RouteName.bottomNav:
        return MaterialPageRoute(builder: (context) => const BottomNav());

      // ! admin
      case RouteName.admin:
        return MaterialPageRoute(builder: (context) => const AdminScreen());
      case RouteName.adminhome:
        return MaterialPageRoute(builder: (context) => const HomeAdminScreen());
      case RouteName.adminaddhome:
        return MaterialPageRoute(builder: (context) => const AddFood());
      default:
        return MaterialPageRoute(
            builder: (context) => const Scaffold(
                  body: Center(
                    child: Text("NO Route Defined"),
                  ),
                ));
    }
  }
}
