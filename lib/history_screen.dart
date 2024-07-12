import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neumorphic_calculator/bloc/calculator_bloc.dart';

import 'package:neumorphic_calculator/utils/extensions/extensions.dart';
import 'package:neumorphic_calculator/widgets/confirm_dialog.dart';

import 'service/preference_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = Tween<double>(begin: 56, end: 0).animate(_controller);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = PreferencesService.instance.results;
    final prefs = PreferencesService.instance;
    final showTip = prefs.settingsModel.showHistoryTip;
    final textStyle = Theme.of(context)
        .textTheme
        .bodyLarge
        ?.copyWith(color: Theme.of(context).colorScheme.onSurface);
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('History'),
              bottom: showTip && results.isNotEmpty
                  ? PreferredSize(
                      preferredSize: Size.fromHeight(_animation.value),
                      child: SizedBox(
                        height: _animation.value,
                        child: ClipRect(
                          child: ListTile(
                              leading: Icon(Icons.info_outline,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                              title:
                                  const Text('Press and hold to copy result'),
                              tileColor: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.1),
                              trailing: IconButton(
                                padding: const EdgeInsets.all(16.0),
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  _controller.forward();
                                  prefs.updateSettings(prefs.settingsModel
                                      .copyWith(showHistoryTip: false));
                                },
                              )),
                        ),
                      ))
                  : null,
              actions: [
                if (results.isNotEmpty)
                  IconButton(
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                      ),
                      padding: const EdgeInsets.all(16.0),
                      onPressed: () {
                        ConfirmDialog(
                            title: 'Clear History',
                            content:
                                'Are you sure you want to clear the history?',
                            confirmText: 'Clear',
                            onConfirm: () {
                              PreferencesService.instance.clearResults();
                              setState(() {});
                            }).show(context);
                      }),
              ],
            ),
            body: results.isEmpty
                ? Center(
                    child: Text('Expression history = 0', style: textStyle),
                  )
                : ListView.builder(
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      final result = results[index];
                      return ListTile(
                        title: Text(result.expression),
                        subtitle: Text(result.output),
                        trailing: Text(result.dateTime.timeAgo),
                        onTap: () {
                          context
                              .read<CalculatorBloc>()
                              .add(LoadHistory(result));
                          // TODO: Navigate back to calculator screen using page controller
                        },
                        onLongPress: () async {
                          // copy the result to the clipboard
                          await Clipboard.setData(
                              ClipboardData(text: result.output));
                          HapticFeedback.heavyImpact();
                        },
                      );
                    },
                  ),
          );
        });
  }
}
