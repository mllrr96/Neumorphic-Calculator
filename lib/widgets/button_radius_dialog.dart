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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // When showing dialog in dark mode the text remians black, this is a workaround
    final titleTextStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
          color: isDark ? Colors.white : Colors.black,
        );
    final contentTextStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: isDark ? Colors.white : Colors.black,
        );
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text('Button radius', style: titleTextStyle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Change the radius of the buttons', style: contentTextStyle),
          const SizedBox(height: 16),
          NeumorphicButton(
            border:
                Border.all(color: Theme.of(context).splashColor, width: 0.5),
            borderRadius: buttonRadius,
            child: Text('Demo', style: contentTextStyle),
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
            max: 45,
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
