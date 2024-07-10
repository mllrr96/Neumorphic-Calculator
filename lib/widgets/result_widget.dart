import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ResultWidget extends StatelessWidget {
  final String result;
  const ResultWidget(this.result, {super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final formatError = result == 'Format Error';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      alignment: Alignment.centerRight,
      child: AutoSizeText(
        result,
        style: TextStyle(
            fontSize: 80,
            color: formatError
                ? Colors.red
                : isDark
                    ? Theme.of(context).iconTheme.color
                    : primaryColor),
        minFontSize: 20,
        maxFontSize: 80,
        maxLines: 1,
      ),
    );
  }
}
