import 'package:flutter/material.dart';
import 'package:neumorphic_calculator/utils/extensions/theme_extension.dart';

class NeumorphicButton extends StatefulWidget {
  const NeumorphicButton({
    super.key,
    this.onPressed,
    this.onLongPress,
    required this.child,
    this.width,
    this.height,
    this.borderRadius,
    this.duration,
    this.boxShadow,
    this.constraints,
    this.border,
    this.semanticLabel,
  });

  final void Function()? onPressed;
  final void Function()? onLongPress;
  final double? width, height;
  final Duration? duration;
  final Widget child;
  final double? borderRadius;
  final List<BoxShadow>? boxShadow;
  final BoxConstraints? constraints;
  final BoxBorder? border;
  final String? semanticLabel;

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isElevated = true;

  void setElevated(bool value) {
    if (mounted) setState(() => _isElevated = value);
  }

  void _handleTap() {
    widget.onPressed?.call();
    Future.delayed(const Duration(milliseconds: 200), () => setElevated(true));
  }

  List<BoxShadow>? _buildShadows(bool isDark) {
    if (!_isElevated) return null;
    return widget.boxShadow ??
        [
          BoxShadow(
            color: isDark ? const Color(0xff313D4E) : const Color(0xffEBEFFF),
            offset: const Offset(5, 5),
            blurRadius: 10,
          ),
          BoxShadow(
            color: isDark ? const Color(0xff394656) : const Color(0xffFFFFFF),
            offset: const Offset(-5, -5),
            blurRadius: 10,
          ),
        ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.isDarkMode;

    return GestureDetector(
      onTapDown: (_) => setElevated(false),
      onTapUp: (_) => _handleTap(),
      onTapCancel: () => setElevated(true),
      onLongPress: widget.onLongPress,
      child: AnimatedContainer(
        alignment: Alignment.center,
        duration: widget.duration ?? const Duration(milliseconds: 200),
        height: widget.height,
        width: widget.width,
        constraints: widget.constraints ??
            const BoxConstraints(
                minHeight: 55, maxHeight: 75, minWidth: 55, maxWidth: 75),
        transform: Matrix4.identity()..scale(_isElevated ? 1.0 : 0.96),
        decoration: BoxDecoration(
          border: widget.border,
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 18.0),
          boxShadow: _buildShadows(isDark),
        ),
        child: widget.child,
      ),
    );
  }
}
