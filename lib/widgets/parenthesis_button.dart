import 'package:flutter/material.dart';
import 'package:neumorphic_calculator/service/preference_service.dart';

class ParenthesisButton extends StatefulWidget {
  const ParenthesisButton({
    super.key,
    this.onPressed,
    this.width,
    this.height,
    this.duration,
    this.borderRadius,
    this.onLongPress,
    this.boxShadow,
    this.constraints,
  });
  final void Function(String)? onPressed;
  final void Function()? onLongPress;
  final double? width, height;
  final Duration? duration;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final BoxConstraints? constraints;
  @override
  State<ParenthesisButton> createState() => ParenthesisButtonState();
}

class ParenthesisButtonState extends State<ParenthesisButton> {
  bool _isElevated = true;
  bool _isElevated2 = true;

  void setElevated(bool value) => setState(() => _isElevated = value);
  void setElevated2(bool value) => setState(() => _isElevated2 = value);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final borderRadius = PreferencesService.instance.settingsModel.buttonRadius;
    TextStyle operationStyle = TextStyle(
        color: primaryColor, fontSize: 24, fontWeight: FontWeight.w900);
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTapDown: (_) => setElevated(false),
            onTapUp: (_) => setElevated(true),
            onTapCancel: () => setElevated(true),
            onLongPress: widget.onLongPress,
            onTap: () {
              setElevated(!_isElevated);
              Future.delayed(
                  const Duration(milliseconds: 200), () => setElevated(true));
              widget.onPressed?.call('(');
            },
            child: AnimatedContainer(
              alignment: Alignment.center,
              duration: widget.duration ?? const Duration(milliseconds: 200),
              height: widget.height,
              width: widget.width,
              margin: const EdgeInsets.only(right: 3),
              clipBehavior: Clip.antiAlias,
              constraints: widget.constraints ??
                  const BoxConstraints(
                    minHeight: 75,
                    minWidth: 75,
                  ),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: widget.borderRadius ??
                    BorderRadius.only(
                      bottomLeft: Radius.circular(borderRadius),
                      topLeft: Radius.circular(borderRadius),
                    ),
                boxShadow: _isElevated
                    ? widget.boxShadow ??
                        [
                          BoxShadow(
                            color: isDark
                                ? const Color(0xff313D4E)
                                : const Color(0xffEBEFFF),
                            offset: const Offset(5, 5),
                            blurRadius: 10,
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: isDark
                                ? const Color(0xff394656)
                                : const Color(0xffFFFFFF),
                            offset: const Offset(-5, -5),
                            blurRadius: 10,
                            spreadRadius: 0,
                          ),
                        ]
                    : null,
              ),
              child: Text(
                '(',
                style: operationStyle,
              ),
            ),
          ),
        ),
        // const VerticalDivider(width: 8),
        Expanded(
          child: GestureDetector(
            onTapDown: (_) => setElevated2(false),
            onTapUp: (_) => setElevated2(true),
            onTapCancel: () => setElevated2(true),
            onLongPress: widget.onLongPress,
            onTap: () {
              setElevated2(!_isElevated2);
              Future.delayed(
                  const Duration(milliseconds: 200), () => setElevated2(true));
              widget.onPressed?.call(')');
            },
            child: AnimatedContainer(
              clipBehavior: Clip.antiAlias,
              alignment: Alignment.center,
              duration: widget.duration ?? const Duration(milliseconds: 200),
              height: widget.height,
              width: widget.width,
              margin: const EdgeInsets.only(left: 3),
              constraints: widget.constraints ??
                  const BoxConstraints(
                    minHeight: 75,
                    minWidth: 75,
                  ),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: widget.borderRadius ??
                    BorderRadius.only(
                      bottomRight: Radius.circular(borderRadius),
                      topRight: Radius.circular(borderRadius),
                    ),
                boxShadow: _isElevated2
                    ? widget.boxShadow ??
                        [
                          BoxShadow(
                            color: isDark
                                ? const Color(0xff313D4E)
                                : const Color(0xffEBEFFF),
                            offset: const Offset(5, 5),
                            blurRadius: 10,
                            spreadRadius: 0,
                          ),
                          BoxShadow(
                            color: isDark
                                ? const Color(0xff394656)
                                : const Color(0xffFFFFFF),
                            offset: const Offset(-5, -5),
                            blurRadius: 10,
                            spreadRadius: 0,
                          ),
                        ]
                    : null,
              ),
              child: Text(')', style: operationStyle),
            ),
          ),
        ),
      ],
    );
  }
}
