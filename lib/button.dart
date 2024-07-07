import 'package:flutter/material.dart';

class NeumorphicCustomButton extends StatefulWidget {
  const NeumorphicCustomButton(
      {super.key,
      this.onPressed,
      this.width,
      this.height,
      this.duration,
      required this.child,
      this.borderRadius});
  final void Function()? onPressed;
  final double? width, height;
  final Duration? duration;
  final Widget child;
  final BorderRadiusGeometry? borderRadius;
  @override
  State<NeumorphicCustomButton> createState() => NeumorphicCustomButtonState();
}

class NeumorphicCustomButtonState extends State<NeumorphicCustomButton> {
  bool _isElevated = true;

  void setElevated(bool value) => setState(() => _isElevated = value);

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTapDown: (_) => setElevated(false),
      onTapUp: (_) => setElevated(true),
      onTapCancel: () => setElevated(true),
      onTap: () {
        setElevated(!_isElevated);
        Future.delayed(
            const Duration(milliseconds: 200), () => setElevated(true));
        widget.onPressed?.call();
      },
      child: AnimatedContainer(
        duration: widget.duration ?? const Duration(milliseconds: 200),
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(25),
          boxShadow: _isElevated
              ? [
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
