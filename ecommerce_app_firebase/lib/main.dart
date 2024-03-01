// import 'package:ecommerce_app_firebase/admin/admin_login_screen.dart';
import 'package:ecommerce_app_firebase/constants/app_constants.dart';
import 'package:ecommerce_app_firebase/firebase_options.dart';
import 'package:ecommerce_app_firebase/screen/bottom_nav.dart';
import 'package:ecommerce_app_firebase/screen/on_board_screen.dart';
import 'package:ecommerce_app_firebase/utils/routes/pageTransition.dart';
import 'package:ecommerce_app_firebase/utils/routes/routes.dart';
import 'package:ecommerce_app_firebase/viewModel/auth_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = publishedKey;
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          pageTransitionsTheme: PageTransitionsTheme(builders: {
            TargetPlatform.android: PageTransition(),
            TargetPlatform.iOS: PageTransition(),
          }),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return const BottomNav();
              } else {
                return const Onboard();
              }
            }),
        // home: const AdminScreen(),
        onGenerateRoute: Routes.onGenerateRoute,
      ),
    );
  }
}
