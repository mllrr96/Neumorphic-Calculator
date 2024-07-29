import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:neumorphic_calculator/bloc/calculator_bloc/calculator_bloc.dart';
import 'package:neumorphic_calculator/bloc/page_cubit/page_cubit.dart';
import 'package:neumorphic_calculator/utils/const.dart';
import 'package:neumorphic_calculator/utils/extensions/extensions.dart';
import 'package:neumorphic_calculator/widgets/confirm_dialog.dart';

import 'bloc/history_bloc/history_bloc.dart';
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
    // final results = PreferencesService.instance.results;
    final prefs = PreferencesService.instance;
    final showTip = prefs.settingsModel.showHistoryTip;
    final textStyle = Theme.of(context)
        .textTheme
        .bodyLarge
        ?.copyWith(color: Theme.of(context).colorScheme.onSurface);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return BlocBuilder<HistoryBloc, HistoryState>(
          builder: (context, state) {
            final resultNotEmpty =
                state is HistoryLoaded && state.results.isNotEmpty;
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Scaffold(
                appBar: AppBar(
                  systemOverlayStyle: Theme.of(context)
                      .appBarTheme
                      .systemOverlayStyle
                      ?.copyWith(
                        systemNavigationBarColor:
                            Theme.of(context).scaffoldBackgroundColor,
                      ),
                  title: const Text('History'),
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  bottom: showTip && resultNotEmpty
                      ? PreferredSize(
                          preferredSize: Size.fromHeight(_animation.value),
                          child: SizedBox(
                            height: _animation.value,
                            child: ClipRect(
                              child: ListTile(
                                  leading: Icon(Icons.info_outline,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                  title: const Text(
                                      'Press and hold to copy result'),
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
                    if (resultNotEmpty)
                      IconButton(
                          icon: const Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                          ),
                          padding: const EdgeInsets.all(16.0),
                          onPressed: () {
                            ConfirmDialog(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Clear History'),
                                    Lottie.asset(
                                      !isDark
                                          ? AppConst.deleteDark
                                          : AppConst.deleteLight,
                                      height: 50,
                                      width: 50,
                                      repeat: false,
                                    ),
                                  ],
                                ),
                                content:
                                    'Are you sure you want to clear the history?',
                                confirmText: 'Clear',
                                onConfirm: () {
                                  context
                                      .read<HistoryBloc>()
                                      .add(const ClearHistory());
                                }).show(context);
                          }),
                  ],
                ),
                body: switch (state) {
                  HistoryInitial() => Center(
                      child: Text('Expression history = 0', style: textStyle),
                    ),
                  HistoryLoading() =>
                    const Center(child: CircularProgressIndicator()),
                  HistoryEmpty() => Center(
                      child: Text('Expression history = 0', style: textStyle),
                    ),
                  HistoryLoaded() => ListView.builder(
                      itemCount: state.results.length,
                      itemBuilder: (context, index) {
                        final result = state.results[index];
                        return ListTile(
                          title: Text(result.expression),
                          subtitle: Text(result.output),
                          trailing: Text(result.dateTime.timeAgo),
                          onTap: () {
                            context
                                .read<CalculatorBloc>()
                                .add(LoadCalculation(result));
                            context.read<PageCubit>().updateIndex(1);
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
                  HistoryFailure() => Center(
                      child: Text(state.error, style: textStyle),
                    ),
                });
          },
        );
      },
    );
  }
}
