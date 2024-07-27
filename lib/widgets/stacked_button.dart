import 'package:flutter/material.dart';

class StackedButton extends StatefulWidget {
  const StackedButton({
    super.key,
    this.width,
    this.height,
    this.duration,
    this.onLongPress,
    this.boxShadow,
    this.constraints,
    required this.firstChild,
    required this.secondChild,
    this.onFirstChildPressed,
    this.onSecondChildPressed,
    this.borderRadius = 12.0,
  }) : _isVertical = false;

  const StackedButton.vertical({
    super.key,
    this.width,
    this.height,
    this.duration,
    this.onLongPress,
    this.boxShadow,
    this.constraints,
    required this.firstChild,
    required this.secondChild,
    this.onFirstChildPressed,
    this.onSecondChildPressed,
    this.borderRadius = 12.0,
  }) : _isVertical = true;

  final bool _isVertical;
  final void Function()? onLongPress;
  final double? width, height;
  final double borderRadius;
  final Duration? duration;
  final List<BoxShadow>? boxShadow;
  final BoxConstraints? constraints;
  final Widget firstChild;
  final Widget secondChild;
  final void Function()? onFirstChildPressed;
  final void Function()? onSecondChildPressed;
  @override
  State<StackedButton> createState() => StackedButtonState();
}

class StackedButtonState extends State<StackedButton> {
  bool _isElevated = true;
  bool _isElevated2 = true;

  void setElevated(bool value) => setState(() => _isElevated = value);
  void setElevated2(bool value) => setState(() => _isElevated2 = value);

  Widget _orientation({required List<Widget> children}) {
    if (widget._isVertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final borderRadius1 = widget._isVertical
        ? BorderRadius.only(
            topRight: Radius.circular(widget.borderRadius),
            topLeft: Radius.circular(widget.borderRadius),
          )
        : BorderRadius.only(
            bottomLeft: Radius.circular(widget.borderRadius),
            topLeft: Radius.circular(widget.borderRadius),
          );
    final borderRadius2 = widget._isVertical
        ? BorderRadius.only(
            bottomRight: Radius.circular(widget.borderRadius),
            bottomLeft: Radius.circular(widget.borderRadius),
          )
        : BorderRadius.only(
            bottomRight: Radius.circular(widget.borderRadius),
            topRight: Radius.circular(widget.borderRadius),
          );
    final margin1 = widget._isVertical
        ? const EdgeInsets.only(bottom: 3)
        : const EdgeInsets.only(right: 3);
    final margin2 = widget._isVertical
        ? const EdgeInsets.only(top: 3)
        : const EdgeInsets.only(left: 3);

    return ConstrainedBox(
      constraints: widget.constraints ??
          const BoxConstraints(
            minHeight: 55,
            minWidth: 55,
            maxHeight: 75,
            maxWidth: 75,
          ),
      child: _orientation(
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
                widget.onFirstChildPressed?.call();
              },
              child: AnimatedContainer(
                alignment: Alignment.center,
                duration: widget.duration ?? const Duration(milliseconds: 200),
                height: widget.height,
                width: widget.width,
                margin: margin1,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: borderRadius1,
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
                child: widget.firstChild,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTapDown: (_) => setElevated2(false),
              onTapUp: (_) => setElevated2(true),
              onTapCancel: () => setElevated2(true),
              onLongPress: widget.onLongPress,
              onTap: () {
                setElevated2(!_isElevated2);
                Future.delayed(const Duration(milliseconds: 200),
                    () => setElevated2(true));
                widget.onSecondChildPressed?.call();
              },
              child: AnimatedContainer(
                alignment: Alignment.center,
                duration: widget.duration ?? const Duration(milliseconds: 200),
                height: widget.height,
                width: widget.width,
                margin: margin2,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: borderRadius2,
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
                child: widget.secondChild,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
