import 'package:flutter/material.dart';
import 'package:neumorphic_calculator/utils/extensions/theme_extension.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog(
      {super.key,
      required this.onConfirm,
      required this.title,
      required this.content,
      required this.confirmText});

  final String content, confirmText;
  final Widget title;

  final void Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.isDarkMode;

    // When showing dialog in dark mode the text remians black, this is a workaround
    final titleTextStyle = theme.textTheme.headlineSmall?.copyWith(
      color: isDark ? Colors.white : Colors.black,
    );
    final contentTextStyle = theme.textTheme.bodyMedium?.copyWith(
      color: isDark ? Colors.white : Colors.black,
    );
    return AlertDialog(
      title: title,
      titleTextStyle: titleTextStyle,
      contentTextStyle: contentTextStyle,
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: Text(confirmText),
        ),
      ],
    );
  }
}
