import 'package:equatable/equatable.dart';

import 'theme.dart';

class SettingsModel extends Equatable {
  final bool hapticEnabled;
  final bool splashEnabled;
  final double buttonRadius;
  final Fonts font;
  const SettingsModel(
      {required this.hapticEnabled,
      required this.splashEnabled,
      required this.buttonRadius,
      required this.font});

  factory SettingsModel.normal() {
    return const SettingsModel(
        hapticEnabled: true,
        splashEnabled: true,
        buttonRadius: 12.0,
        font: Fonts.cairo);
  }

  SettingsModel copyWith(
      {bool? hapticEnabled,
      bool? splashEnabled,
      double? buttonRadius,
      Fonts? font}) {
    return SettingsModel(
        hapticEnabled: hapticEnabled ?? this.hapticEnabled,
        splashEnabled: splashEnabled ?? this.splashEnabled,
        buttonRadius: buttonRadius ?? this.buttonRadius,
        font: font ?? this.font);
  }

  Map<String, dynamic> toMap() {
    return {
      'hapticEnabled': hapticEnabled,
      'splashEnabled': splashEnabled,
      'buttonRadius': buttonRadius,
      'font': font.index,
    };
  }

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
        hapticEnabled: map['hapticEnabled'],
        splashEnabled: map['splashEnabled'],
        buttonRadius: map['buttonRadius'],
        font: Fonts.values[map['font']]);
  }

  @override
  List<Object?> get props => [
        hapticEnabled,
        splashEnabled,
        buttonRadius,
      ];
}
