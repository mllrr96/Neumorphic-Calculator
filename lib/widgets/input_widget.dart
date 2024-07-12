import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  final TextEditingController controller;
  const InputWidget(this.controller, {super.key});
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: AutoSizeTextField(
        controller: controller,
        textAlign: TextAlign.right,
        style: TextStyle(
            fontSize: 90,
            color: isDark ? primaryColor : Theme.of(context).iconTheme.color),
        minFontSize: 12,
        maxFontSize: 90,
        maxLines: 1,
        cursorColor: primaryColor,
        cursorWidth: 4,
        showCursor: true,
        readOnly: true,
        decoration: const InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
        ),
      ),
    );
  }
}
