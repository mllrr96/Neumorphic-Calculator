import 'dart:async';
import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputWidget extends StatefulWidget {
  final TextEditingController controller;
  const InputWidget(this.controller, {super.key});

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  bool showCursor = true;

  Timer get curserTimer => Timer.periodic(const Duration(milliseconds: 500),
      (_) => setState(() => showCursor = !showCursor));

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: AutoSizeTextField(
        controller: widget.controller,
        textInputAction: TextInputAction.none,
        textAlign: TextAlign.right,
        style:
            TextStyle(fontSize: 90, color: Theme.of(context).iconTheme.color),
        minFontSize: 12,
        maxFontSize: 90,
        maxLines: 1,
        cursorColor: primaryColor,
        cursorWidth: 4,
        showCursor: true,
        readOnly: true,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          FilteringTextInputFormatter.allow(RegExp(r"[\-,\.,\+,\x,\÷,\%]")),
        ],
        decoration: const InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          focusedErrorBorder: InputBorder.none,
        ),
      ),
    );
  }
}
