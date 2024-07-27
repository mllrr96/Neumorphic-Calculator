import 'package:flutter/material.dart';
import 'package:neumorphic_calculator/widgets/neumorphic_button.dart';

class ButtonRadiusDialog extends StatefulWidget {
  const ButtonRadiusDialog({super.key, required this.buttonRadius});
  final double buttonRadius;

  @override
  State<ButtonRadiusDialog> createState() => _ButtonRadiusDialogState();
}

class _ButtonRadiusDialogState extends State<ButtonRadiusDialog> {
  late double buttonRadius;

  @override
  void initState() {
    buttonRadius = widget.buttonRadius;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Button radius'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Change the radius of the buttons'),
          // demo button
          NeumorphicButton(
            border:
                Border.all(color: Theme.of(context).splashColor, width: 0.5),
            borderRadius: buttonRadius,
            child: const Text('Demo'),
          ),
          const SizedBox(height: 16),
          Slider(
            divisions: 20,
            label: buttonRadius.toString(),
            value: buttonRadius,
            onChanged: (val) {
              setState(() {
                buttonRadius = val;
              });
            },
            max: 25,
            min: 5,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(12.0),
          child: const Text('Reset to default'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context)
              .pop(buttonRadius == widget.buttonRadius ? null : buttonRadius),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
