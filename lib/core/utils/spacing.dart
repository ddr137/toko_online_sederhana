import 'package:flutter/material.dart';

class AppSpacing {
  static const Widget xs = SizedBox(width: 4, height: 4);
  static const Widget sm = SizedBox(width: 8, height: 8);
  static const Widget md = SizedBox(width: 16, height: 16);
  static const Widget lg = SizedBox(width: 24, height: 24);
  static const Widget xl = SizedBox(width: 32, height: 32);
  static const Widget xxl = SizedBox(width: 48, height: 48);

  static Widget horizontal(double value) => SizedBox(width: value);
  static Widget vertical(double value) => SizedBox(height: value);
}

class AppGaps {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}
