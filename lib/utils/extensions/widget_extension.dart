import 'package:flutter/material.dart';

extension WidgetExtension on Widget {
  Future show(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => this,
    );
  }
}
