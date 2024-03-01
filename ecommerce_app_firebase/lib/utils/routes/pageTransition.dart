import 'package:flutter/material.dart';

// class CustomTransition<T> extends MaterialPageRoute<T> {
//   CustomTransition({required super.builder, RouteSettings? setting})
//       : super(settings: setting);
//   @override
//   Widget buildTransitions(BuildContext context, Animation<double> animation,
//       Animation<double> secondaryAnimation, Widget child) {
//     if (settings.name == '/') {
//       return child;
//     }
//     return FadeTransition(
//       opacity: animation,
//       child: child,
//     );
//   }
// }

class PageTransition extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {
    if (route.settings.name == "/") {
      return child;
    }

  

    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
