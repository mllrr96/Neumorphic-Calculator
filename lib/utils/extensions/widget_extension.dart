import 'package:flutter/material.dart';

extension WidgetExtension on Widget {
  void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => this,
    );
  }
}
