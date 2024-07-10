import 'package:equatable/equatable.dart';
import 'enum.dart';

class SettingsModel extends Equatable {
  final bool hapticEnabled;
  final bool splashEnabled;
  final double buttonRadius;
  final Fonts font;
  final bool showHistoryTip;
  const SettingsModel({
    required this.hapticEnabled,
    required this.splashEnabled,
    required this.buttonRadius,
    required this.font,
    required this.showHistoryTip,
  });

  factory SettingsModel.normal() {
    return const SettingsModel(
        hapticEnabled: true,
        splashEnabled: true,
        buttonRadius: 12.0,
        showHistoryTip: true,
        font: Fonts.cabin);
  }

  SettingsModel copyWith(
      {bool? hapticEnabled,
      bool? splashEnabled,
      double? buttonRadius,
      bool? showHistoryTip,
      Fonts? font}) {
    return SettingsModel(
        hapticEnabled: hapticEnabled ?? this.hapticEnabled,
        splashEnabled: splashEnabled ?? this.splashEnabled,
        buttonRadius: buttonRadius ?? this.buttonRadius,
        font: font ?? this.font,
        showHistoryTip: showHistoryTip ?? this.showHistoryTip);
  }

  Map<String, dynamic> toMap() {
    return {
      'hapticEnabled': hapticEnabled,
      'splashEnabled': splashEnabled,
      'buttonRadius': buttonRadius,
      'font': font.index,
      'showHistoryTip': showHistoryTip,
    };
  }

  factory SettingsModel.fromMap(Map<String, dynamic> map) {
    return SettingsModel(
        hapticEnabled: map['hapticEnabled'] ?? true,
        splashEnabled: map['splashEnabled'] ?? true,
        buttonRadius: map['buttonRadius'] ?? 12.0,
        font: Fonts.values[map['font'] ?? 0],
        showHistoryTip: map['showHistoryTip'] ?? true);
  }

  @override
  List<Object?> get props => [
        hapticEnabled,
        splashEnabled,
        buttonRadius,
      ];
}
