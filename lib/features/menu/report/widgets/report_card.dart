import 'dart:ui';
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
  bool _isHovering = false;

  void _setHovering(bool value) {
    setState(() => _isHovering = value);
  }

  @override
  Widget build(BuildContext context) {
    final double scale = _isHovering ? 1.05 : 1.0;
    final double tilt = _isHovering ? 0.03 : 0.0;

    // Automatically adjust gradient based on base color
    final hsl = HSLColor.fromColor(widget.color);
    final lighter = hsl.withLightness((hsl.lightness + 0.25).clamp(0.0, 1.0)).toColor();
    final darker = hsl.withLightness((hsl.lightness - 0.2).clamp(0.0, 1.0)).toColor();

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => _setHovering(true),
      onTapUp: (_) => _setHovering(false),
      onTapCancel: () => _setHovering(false),
      child: MouseRegion(
        onEnter: (_) => _setHovering(true),
        onExit: (_) => _setHovering(false),
        child: AnimatedScale(
          scale: scale,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(-tilt)
              ..rotateY(tilt),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22.r),

              gradient: LinearGradient(
                colors: [lighter, widget.color, darker],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(_isHovering ? 0.25 : 0.15),
                  blurRadius: _isHovering ? 18 : 10,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22.r),


              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Minimal translucent blur for depth


                  // Trend Line (subtle white tone)
                  Positioned(
                    bottom: 2.h,
                    right: 10.w,
                    child: CustomPaint(
                      size: Size(60.w, 25.h),
                      painter: _UpwardTrendLinePainter(Colors.white),
                    ),
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 50.w,
                        height: 50.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.25),
                            width: 1.2,
                          ),
                        ),
                        child: Icon(
                          widget.icon,
                          size: 28.sp,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            height: 1.3,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Minimal trend line painter
class _UpwardTrendLinePainter extends CustomPainter {
  final Color color;
  _UpwardTrendLinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(0, size.height * 0.8)
      ..cubicTo(
        size.width * 0.25, size.height * 0.4,
        size.width * 0.5, size.height * 1.0,
        size.width * 0.75, size.height * 0.2,
      )
      ..cubicTo(
        size.width * 0.85, size.height * 0.0,
        size.width * 0.95, size.height * 0.5,
        size.width, size.height * 0.3,
      );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
