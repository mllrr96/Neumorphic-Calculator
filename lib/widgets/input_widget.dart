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
  // late Timer timer;
  bool showCursor = true;
  // TextEditingController controller = TextEditingController();

  Timer get curserTimer => Timer.periodic(const Duration(milliseconds: 500),
      (_) => setState(() => showCursor = !showCursor));

  @override
  void initState() {
    // controller.text = widget.input;
    super.initState();
  }

  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    // if (widget.input.isEmpty) {
    //   return Container(
    //       padding: const EdgeInsets.symmetric(horizontal: 18.0),
    //       alignment: Alignment.centerRight,
    //       child: Visibility(
    //         visible: showCursor,
    //         child: Container(
    //           width: 4,
    //           color: primaryColor,
    //           margin: const EdgeInsets.symmetric(vertical: 25.0),
    //         ),
    //       ));
    // }
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
    // return Container(
    //   padding: const EdgeInsets.symmetric(horizontal: 18.0),
    //   alignment: Alignment.centerRight,
    //   child: AutoSizeText(
    //     widget.input.isEmpty ? '0' : widget.input,
    //     minFontSize: 12,
    //     // maxFontSize: 60,
    //     style:
    //         TextStyle(fontSize: 150, color: Theme.of(context).iconTheme.color),
    //     maxLines: 1,
    //   ),
    // );
  }
}
