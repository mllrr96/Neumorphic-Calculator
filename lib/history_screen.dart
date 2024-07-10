import 'dart:ffi' hide Size;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:neumorphic_calculator/settings_screen.dart';
import 'package:neumorphic_calculator/utils/extensions/date_time_extension.dart';
import 'package:neumorphic_calculator/utils/extensions/widget_extension.dart';
import 'package:neumorphic_calculator/widgets/history_app_bar.dart';

import 'service/preference_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final results = PreferencesService.instance.results;
    return Scaffold(
      appBar: const HistoryAppBar(),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final result = results[index];
          return ListTile(
            title: Text(result.expression),
            subtitle: Text(result.output),
            trailing: Text(result.dateTime.timeAgo),
            onTap: () {
              // TODO: Copy the expression and result to the main screen
            },
            onLongPress: () async {
              // copy the result to the clipboard
              await Clipboard.setData(ClipboardData(text: result.output));
              HapticFeedback.heavyImpact();
            },
          );
        },
      ),
    );
  }
}
