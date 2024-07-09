import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:neumorphic_calculator/service/preference_service.dart';
import 'package:neumorphic_calculator/utils/enum.dart';

class ResultWidget extends StatelessWidget {
  final String result;

  const ResultWidget(this.result, {super.key});
  bool get formatError => result == 'Format Error';

  @override
  Widget build(BuildContext context) {
    final themeType = PreferencesService.instance.themeType;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      alignment: Alignment.centerRight,
      child: AutoSizeText(
        result,
        style: TextStyle(
            fontSize: 80,
            color: formatError
                ? Colors.red
                : themeType == ThemeType.pink
                    ? Theme.of(context).iconTheme.color
                    : Theme.of(context).colorScheme.primary),
        minFontSize: 20,
        maxFontSize: 80,
        maxLines: 1,
      ),
    );
  }
}
