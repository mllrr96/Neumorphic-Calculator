import 'package:flutter/material.dart';

extension ThemeExtension on ThemeData {
  bool get isDarkMode => brightness == Brightness.dark;
}
