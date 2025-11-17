import 'package:flutter/material.dart';

class CustomAnimatedButton extends StatefulWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback onPressed;
  final Color? color;
  final Color? pressedColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final double elevation;
  final Duration duration;
  final bool fullWidth;
  final bool showShadow;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final MainAxisAlignment alignment;
  final double scaleFactor;

  const CustomAnimatedButton({
    super.key,
    this.label,
    required this.onPressed,
    this.icon,
    this.color,
    this.pressedColor,
    this.width,
    this.height,
    this.borderRadius = 24,
    this.fontSize = 16,
    this.fontWeight = FontWeight.bold,
    this.textColor = Colors.white,
    this.elevation = 6,
    this.duration = const Duration(milliseconds: 120),
    this.fullWidth = false,
    this.showShadow = true,
    this.margin = const EdgeInsets.all(5),
    this.padding = const EdgeInsets.all( 5),
    this.alignment = MainAxisAlignment.center,
    this.scaleFactor = 0.95,
  });

  @override
  State<CustomAnimatedButton> createState() => _CustomAnimatedButtonState();
}

class _CustomAnimatedButtonState extends State<CustomAnimatedButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final buttonWidth =
    widget.fullWidth ? double.infinity : (widget.width ?? 160);
    final buttonHeight = widget.height ?? 50.0;

    return Container(
      margin: widget.margin,
      width: buttonWidth,
      height: buttonHeight,
      child: Listener(
        onPointerDown: (_) => setState(() => _isPressed = true),
        onPointerUp: (_) => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? widget.scaleFactor : 1.0,
          duration: widget.duration,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: _isPressed
                  ? (widget.pressedColor ?? (widget.color ?? const Color(0xFF26338A)))
                  : (widget.color ?? const Color(0xFF3240B6)),
              elevation: _isPressed ? 2 : widget.elevation,
              shadowColor: widget.showShadow ? Colors.black45 : Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
              ),
              padding: widget.padding,
            ),
            onPressed: widget.onPressed,
            icon: widget.icon != null
                ? Icon(widget.icon, color: widget.textColor)
                : const SizedBox.shrink(),
            label: Text(
                widget.label??'',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: widget.textColor,
                  fontSize: widget.fontSize,
                  fontWeight: widget.fontWeight,

              ),
            ),
          ),
        ),
      ),
    );
  }
}
