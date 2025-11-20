
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReportCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const ReportCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;

  void _setPressed(bool value) {
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final double scale = _pressed ? 0.95 : 1.0;
    final hsl = HSLColor.fromColor(widget.color);
    final pastel = hsl
        .withSaturation((hsl.saturation * 0.30).clamp(0.0, 1.0))
        .withLightness(0.90)
        .toColor();

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) {
        _setPressed(false);
        if (widget.onTap != null) widget.onTap!();
      },
      onTapCancel: () => _setPressed(false),

      child: AnimatedScale(
        scale: scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,

        child: Container(
          width: 240.w,
          height: 150.h,
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 15.h),

          decoration: BoxDecoration(
            color: pastel,
            borderRadius: BorderRadius.circular(22.r,),
            border: Border.all(
              color: Colors.white70,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.12),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 55.w,
                height: 55.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.7),
                ),
                child: Icon(
                  widget.icon,
                  color: widget.color,
                  size: 32.sp,
                ),
              ),

              SizedBox(height: 8.h),

              Flexible( // Prevents text overflow
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black.withOpacity(0.78),
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

