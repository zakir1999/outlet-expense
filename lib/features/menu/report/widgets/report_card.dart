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

class _ReportCardState extends State<ReportCard> {
  bool _isHovering = false;

  void _setHovering(bool value) {
    setState(() => _isHovering = value);
  }

  @override
  Widget build(BuildContext context) {
    final double scale = _isHovering ? 1.07 : 1.0;
    final double tilt = _isHovering ? 0.04 : 0.0;

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
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(-tilt)
              ..rotateY(tilt),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(_isHovering ? 0.45 : 0.2),
                  blurRadius: _isHovering ? 22 : 12,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24.r),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 🟦 Frosted blur background
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.color.withOpacity(1.0),
                            Colors.white.withOpacity(0.5),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.2,
                        ),
                      ),
                    ),
                  ),

                  // ✨ Light reflection overlay (top-right)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 120.w,
                      height: 120.w,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [Colors.white.withOpacity(0.2),
                            Colors.transparent
                          ],
                          center: Alignment.topRight,
                          radius: 1.0,
                        ),
                      ),
                    ),
                  ),

                  // 📈 Trend line (bottom-right)
                  Positioned(
                    bottom: 10.h,
                    right: 10.w,
                    child: CustomPaint(
                      size: Size(60.w, 25.h),
                      painter: _UpwardTrendLinePainter(widget.color),
                    ),
                  ),

                  // 🧩 Main content
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 54.w,
                        height: 54.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: widget.color.withOpacity(0.9),
                              blurRadius: 12,
                              offset: const Offset(0, 9),
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.icon,
                          size: 28.sp,
                          color: widget.color,
                        ),
                      ),
                      SizedBox(height: 14.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black.withOpacity(0.85),
                            height: 1.3,
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

class _UpwardTrendLinePainter extends CustomPainter {
  final Color _color;
  _UpwardTrendLinePainter(this._color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();

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