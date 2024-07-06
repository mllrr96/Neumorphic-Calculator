import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class InputWidget extends StatefulWidget {
  final String input;
  const InputWidget(this.input, {super.key});

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  late Timer timer;
  bool showCursor = true;

  Timer get curserTimer => Timer.periodic(const Duration(milliseconds: 500),
      (_) => setState(() => showCursor = !showCursor));

  @override
  void didUpdateWidget(covariant InputWidget oldWidget) {
    if (oldWidget.input == widget.input) {
      return;
    }
    if (widget.input.isEmpty) {
      if (!timer.isActive) timer = curserTimer;
    } else {
      if (timer.isActive) timer.cancel();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    timer = curserTimer;
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    if (widget.input.isEmpty) {
      return Container(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          alignment: Alignment.centerRight,
          child: Visibility(
            visible: showCursor,
            child: Container(
              width: 4,
              color: primaryColor,
              margin: const EdgeInsets.symmetric(vertical: 25.0),
            ),
          ));
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      alignment: Alignment.centerRight,
      child: AutoSizeText(
        widget.input.isEmpty ? '0' : widget.input,
        minFontSize: 12,
        // maxFontSize: 60,
        style:
            TextStyle(fontSize: 150, color: Theme.of(context).iconTheme.color),
        maxLines: 1,
      ),
    );
  }
}
