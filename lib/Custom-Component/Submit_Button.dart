import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;
  final Color backgroundColor;
  final Color foregroundColor;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.height = 50,
    this.backgroundColor = const Color.fromARGB(255, 35, 59, 201),
    this.foregroundColor = Colors.white,
    this.borderRadius = 50,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double buttonWidth;
    if (screenWidth < 600) {
      buttonWidth = screenWidth * 0.9;
    } else if (screenWidth < 1024) {
      buttonWidth = screenWidth * 0.6;
    } else {
      buttonWidth = 400;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: widget.onPressed != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: buttonWidth,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: isHovered
              ? [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: ElevatedButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.backgroundColor,
            foregroundColor: widget.foregroundColor,
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
          ),
          child: widget.isLoading
              ? SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: widget.foregroundColor,
                  ),
                )
              : Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: screenWidth < 600 ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
        ),
      ),
    );
  }
}
