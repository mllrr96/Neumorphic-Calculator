import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neumorphic_calculator/utils/extensions/extensions.dart';

enum CalculatorButton {
  allClear('AC'),
  openParenthesis('('),
  closeParenthesis(')'),
  percent('%'),
  divide('÷'),
  //
  seven('7'),
  eight('8'),
  nine('9'),
  multiply('x'),
  //
  four('4'),
  five('5'),
  six('6'),
  subtract('-'),
  //
  one('1'),
  two('2'),
  three('3'),
  add('+'),
  //
  zero('0'),
  decimal('.'),
  clear('C'),
  equal('=');

  final String value;
  const CalculatorButton(this.value);

  bool get isNumber => int.tryParse(value) != null;
}

enum ScientificButton {
  sin('sin('),
  asin('asin('),
  cos('cos('),
  acos('acos('),
  tan('tan('),
  atan('atan('),
  log('log('),
  ln('ln('),
  sqrt('√('),
  pow('^'),
  fact('!'),
  pi('π'),
  e('e'),
  exp('exp('),
  rad('rad'),
  deg('deg');

  final String value;
  const ScientificButton(this.value);
}

enum Fonts {
  rubik,
  roboto,
  arsenal,
  montserrat,
  merriweather,
  ptSans,
  margarine,
  dancingScript,
  kodeMono,
  cabin,
  pacifico;

  TextTheme get textTheme {
    switch (this) {
      case Fonts.rubik:
        return GoogleFonts.rubikTextTheme();
      case Fonts.roboto:
        return GoogleFonts.robotoTextTheme();
      case Fonts.montserrat:
        return GoogleFonts.montserratTextTheme();
      case Fonts.arsenal:
        return GoogleFonts.arsenalTextTheme();
      case Fonts.merriweather:
        return GoogleFonts.merriweatherTextTheme();
      case Fonts.ptSans:
        return GoogleFonts.ptSansTextTheme();
      case Fonts.margarine:
        return GoogleFonts.margarineTextTheme();
      case Fonts.dancingScript:
        return GoogleFonts.dancingScriptTextTheme();
      case Fonts.kodeMono:
        return GoogleFonts.kodeMonoTextTheme();
      case Fonts.cabin:
        return GoogleFonts.cabinTextTheme();
      case Fonts.pacifico:
        return GoogleFonts.pacificoTextTheme();
    }
  }

  Future<String> license() async {
    switch (this) {
      case Fonts.rubik:
      case Fonts.arsenal:
      case Fonts.montserrat:
      case Fonts.merriweather:
      case Fonts.ptSans:
      case Fonts.margarine:
      case Fonts.dancingScript:
      case Fonts.kodeMono:
      case Fonts.cabin:
      case Fonts.pacifico:
        return await rootBundle.loadString(
            'assets/google_fonts/OFL-${name.toLowerCase().removeSpaces}.txt');

      case Fonts.roboto:
        return await rootBundle.loadString('assets/google_fonts/LICENSE.txt');
    }
  }

  ThemeData setToTheme(ThemeData theme) {
    switch (this) {
      case Fonts.rubik:
        return theme.copyWith(
          textTheme: GoogleFonts.rubikTextTheme(),
        );
      case Fonts.roboto:
        return theme.copyWith(
          textTheme: GoogleFonts.robotoTextTheme(),
        );
      case Fonts.montserrat:
        return theme.copyWith(
          textTheme: GoogleFonts.montserratTextTheme(),
        );
      case Fonts.arsenal:
        return theme.copyWith(
          textTheme: GoogleFonts.arsenalTextTheme(),
        );
      case Fonts.merriweather:
        return theme.copyWith(
          textTheme: GoogleFonts.merriweatherTextTheme(),
        );

      case Fonts.ptSans:
        return theme.copyWith(
          textTheme: GoogleFonts.ptSansTextTheme(),
        );
      case Fonts.margarine:
        return theme.copyWith(
          textTheme: GoogleFonts.margarineTextTheme(),
        );
      case Fonts.dancingScript:
        return theme.copyWith(
          textTheme: GoogleFonts.dancingScriptTextTheme(),
        );

      case Fonts.kodeMono:
        return theme.copyWith(
          textTheme: GoogleFonts.kodeMonoTextTheme(),
        );

      case Fonts.cabin:
        return theme.copyWith(
          textTheme: GoogleFonts.cabinTextTheme(),
        );
      case Fonts.pacifico:
        return theme.copyWith(
          textTheme: GoogleFonts.pacificoTextTheme(),
        );
    }
  }
}

enum ThemeColor {
  sunsetOrange(Color(0xFFFF5E5B)),
  oceanBlue(Color(0xFF0077B6)),
  forestGreen(Color(0xFF2A9D8F)),
  lavenderPurple(Color(0xFF9D4EDD)),
  sunshineYellow(Color(0xFFFFD166)),
  coralPink(Color(0xFFFF6F61)),
  skyBlue(Color(0xFF00B4D8)),
  mintGreen(Color(0xFF3DDC97)),
  royalPurple(Color(0xFF7209B7)),
  goldenYellow(Color(0xFFFFC300)),
  blushRed(Color(0xFFE63946)),
  tealBlue(Color(0xFF008080)),
  peachOrange(Color(0xFFFFA07A)),
  emeraldGreen(Color(0xFF50C878)),
  midnightBlue(Color(0xFF191970));

  final Color color;
  const ThemeColor(this.color);
}
