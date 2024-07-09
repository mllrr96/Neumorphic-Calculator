import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neumorphic_calculator/utils/extensions/string_extension.dart';

class InputWidget extends StatefulWidget {
  final TextEditingController controller;
  const InputWidget(this.controller, {super.key});

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {
  TextEditingController get controller => widget.controller;
  final NumberFormat formatter = NumberFormat();

  @override
  void initState() {
    controller.addListener(_listener);
    super.initState();
  }

  int _length = 0;

  void _listener() {
    if (controller.text.isEmpty ||
        controller.text.length < 3 ||
        _length == controller.text.length) return;
    _length = controller.text.length;
    controller.text = controller.text.formatExpression(formatter);
  }

  @override
  void dispose() {
    controller.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: AutoSizeTextField(
        controller: controller,
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
