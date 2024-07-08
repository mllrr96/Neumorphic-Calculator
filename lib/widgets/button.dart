import 'package:flutter/material.dart';

class NeumorphicButton extends StatefulWidget {
  const NeumorphicButton(
      {super.key,
      this.onPressed,
      this.width,
      this.height,
      this.duration,
      required this.child,
      this.borderRadius,
      this.onLongPress,
      this.boxShadow});
  final void Function()? onPressed;
  final void Function()? onLongPress;
  final double? width, height;
  final Duration? duration;
  final Widget child;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  @override
  State<NeumorphicButton> createState() => NeumorphicButtonState();
}

class NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isElevated = true;

  void setElevated(bool value) => setState(() => _isElevated = value);

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTapDown: (_) => setElevated(false),
      onTapUp: (_) => setElevated(true),
      onTapCancel: () => setElevated(true),
      onLongPress: widget.onLongPress,
      onTap: () {
        setElevated(!_isElevated);
        Future.delayed(
            const Duration(milliseconds: 200), () => setElevated(true));
        widget.onPressed?.call();
      },
      child: AnimatedContainer(
        alignment: Alignment.center,
        duration: widget.duration ?? const Duration(milliseconds: 200),
        height: widget.height,
        width: widget.width,
        constraints: const BoxConstraints(
          minHeight: 75,
          minWidth: 75,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(25),
          boxShadow: _isElevated
              ? widget.boxShadow ??
                  [
                    BoxShadow(
                      color: isDark ? const Color(0xff23262A) : Colors.grey,
                      offset: const Offset(4, 4),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: isDark ? const Color(0xff35393F) : Colors.white,
                      offset: const Offset(-4, -4),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                  ]
              : null,
        ),
        child: widget.child,
      ),
    );
  }
}
