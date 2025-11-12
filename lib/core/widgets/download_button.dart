import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DownloadButton extends StatefulWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String? label;
  final Color backgroundColor;
  final Color iconColor;
  final double size;
  final double iconSize;

  const DownloadButton({
    super.key,
    required this.onPressed,
    this.icon = Icons.file_download_rounded,
    this.label,
    this.backgroundColor = const Color(0xFFD1D3DD),
    this.iconColor = Colors.black,
    this.size = 50,
    this.iconSize = 20,
  });

  @override
  State<DownloadButton> createState() => _CustomFABState();
}

class _CustomFABState extends State<DownloadButton> {
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final showLabel = widget.label != null && widget.label!.isNotEmpty;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Listener(
        onPointerDown: (_) => setState(() => _isPressed = true),
        onPointerUp: (_) => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.92 : 1.0,
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeInOutCirc,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeIn,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (widget.backgroundColor)
                      .withOpacity(_isPressed ? 0.4 : (_isHovered ? 0.5 : 0.6)),
                  blurRadius: _isPressed ? 6 : (_isHovered ? 18 : 16),
                  spreadRadius: _isPressed ? 0 : (_isHovered ? 3 : 2),
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: widget.label ?? widget.icon.codePoint,
                  backgroundColor: widget.backgroundColor,
                  elevation: _isPressed ? 3 : (_isHovered ? 8 : 5),
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    setState(() => _isPressed = false);
                    Future.delayed(const Duration(milliseconds: 120), widget.onPressed);
                  },
                  child: Icon(
                    widget.icon,
                    color: widget.iconColor,
                    size: widget.iconSize,
                  ),
                ),
                if (showLabel) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.label!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
