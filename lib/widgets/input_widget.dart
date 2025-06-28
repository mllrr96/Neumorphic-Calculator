import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:neumorphic_calculator/utils/extensions/theme_extension.dart';

class InputWidget extends StatelessWidget {
  final TextEditingController controller;

  const InputWidget(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final isDark = theme.isDarkMode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: AutoSizeTextField(
        controller: controller,
        autofocus: true,
        textAlign: TextAlign.right,
        style: TextStyle(
            fontSize: 90, color: isDark ? primaryColor : theme.iconTheme.color),
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
