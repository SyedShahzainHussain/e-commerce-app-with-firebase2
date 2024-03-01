import 'package:flutter/material.dart';

class AppWidget {
  static titleHeadingStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
          color: Colors.black,
          fontWeight: FontWeight.w700,
        );
  }

  static const titleHeadingStyle2 = TextStyle(
    color: Colors.black,
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );
  static const lightColorStyle2 = TextStyle(
    color: Colors.grey,
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );
}
