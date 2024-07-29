import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neumorphic_calculator/bloc/preference_cubit/preference_cubit.dart';
import 'package:neumorphic_calculator/bloc/preference_cubit/preference_state.dart';

class QuickSettings extends StatelessWidget {
  const QuickSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreferenceCubit, PreferenceState>(
      builder: (context, state) {
        bool scientific = state.settings.scientific;
        bool hapticEnabled = state.settings.hapticEnabled;
        return Material(
          color: Theme.of(context).bottomAppBarTheme.color,
          child: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchListTile(
                    title: const Text('Scientific'),
                    value: scientific,
                    onChanged: (value) {
                      context.read<PreferenceCubit>().updateSettings(
                          state.settings.copyWith(scientific: !scientific));
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Haptic feedback'),
                    value: hapticEnabled,
                    onChanged: (val) {
                      if (val) {
                        HapticFeedback.heavyImpact();
                      }
                      context.read<PreferenceCubit>().updateSettings(state
                          .settings
                          .copyWith(hapticEnabled: !hapticEnabled));
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
