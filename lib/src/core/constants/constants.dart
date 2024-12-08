import 'package:flutter/material.dart';

class Constants {
  static double borderValue = 14.0;
  static double paddingValue = 12;

  static Color mainColor = Colors.black12;

  static Duration mainDuration = const Duration(
    milliseconds: 200,
  );

  static BorderRadius mainBorderRadius = BorderRadius.circular(
    borderValue,
  );
  static EdgeInsets authInputContent = const EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 16,
  );
}
