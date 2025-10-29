import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReportCard extends StatelessWidget {
  final String title;
  final Color color;
  final String percentText;
  final bool isLeftCard;
  final VoidCallback? onTap;

  const ReportCard({
    super.key,
    required this.title,
    required this.color,
    required this.percentText,
    required this.isLeftCard,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        // Use explicit parameter name.
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: BoxDecoration(
              color: color,
              // Use explicit parameter name.
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 8,
                  // Use const for fixed Offset.
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      // Prefer 1.3 over 1.30 for conciseness.
                      height: 1.3,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    CustomPaint(
                      // Use explicit parameter name.
                      size: Size(50.w, 22.h),
                      // Use a concise name for the painter, e.g., _TrendLinePainter.
                      painter: _UpwardTrendLinePainter(color),
                    ),
                    const Spacer(),
                    Text(
                      percentText,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 0.h,
            // Use positional arguments (right: null, left: null) explicitly for clarity.
            right: isLeftCard ? -12.w : null,
            left: isLeftCard ? null : -12.w,
            // Use a descriptive name for the private method.
            child: _buildCircleDecoration(),
          ),
        ],
      ),
    );
  }

  // Use _build prefix for private methods that return widgets.
  Widget _buildCircleDecoration() => Container(
    // Use an explicit type for dimension.
    width: 25.w,
    height: 25.w,
    decoration: const BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
    ),
  );
}



class _UpwardTrendLinePainter extends CustomPainter {
  final Color _color;

  _UpwardTrendLinePainter(this._color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
    // Use explicit parameter name.
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();

    // Use a factor instead of a magic number for better readability if possible,
    // but keeping the current structure as per request.
    path.moveTo(-size.width * 0.2, size.height * 0.8);

    path.cubicTo(
      size.width * 0.2, size.height * 0.4,
      size.width * 0.4, size.height * 1.0,
      size.width * 0.7, size.height * 0.2,
    );

    path.cubicTo(
      size.width * 0.8, size.height * 0.0,
      size.width * 0.9, size.height * 0.5,
      size.width * 1.1, size.height * 0.3,
    );

    canvas.drawPath(path, paint);
  }

  @override
  // Explicitly use the type for oldDelegate.
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// -------------------- DETAIL PAGE --------------------

class DetailPage extends StatelessWidget {
  final String title;
  const DetailPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Text(
          '$title - detail page',
          style: TextStyle(fontSize: 18.sp),
        ),
      ),
    );
  }
}