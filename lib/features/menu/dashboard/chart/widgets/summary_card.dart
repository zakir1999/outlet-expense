import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final Color color;
  final String title;
  final String value;
  final IconData icon;
  final String? customer_percentage;

  const SummaryCard({
    Key? key,
    required this.color,
    required this.title,
    required this.value,
    required this.icon,
    this.customer_percentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;

    // Responsive card width & height
    final cardWidth = screenW < 600 ? screenW * 0.42 : screenW * 0.28;
    final cardHeight = screenH * 0.16; // scales with screen height

    return Container(
      width: cardWidth,
      margin: const EdgeInsets.only(right: 12),
      child: Stack(
        children: [
          // Card Background
          Container(
            height: cardHeight,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),

          // Upward Trending Flow Line (Bottom-Right)
          Positioned(
            bottom: 8,
            right: 8,
            child: CustomPaint(
              size: const Size(60, 30),
              painter: _UpwardTrendLinePainter(color),
            ),
          ),

          // Income Percentage (Top Right)
          if (customer_percentage != null)
            Positioned(
              top: 12,
              right: 16,
              child: Text(
                customer_percentage!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenW < 400 ? 14 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          // Main Card Content
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    mainAxisSize: MainAxisSize.min, // ✅ prevents overflow
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(icon, color: Colors.white, size: constraints.maxHeight * 0.25),
                      const SizedBox(height: 8),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            value,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenW < 400 ? 18 : 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Flexible(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: screenW < 400 ? 12 : 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for upward trending line (smoother wave)
class _UpwardTrendLinePainter extends CustomPainter {
  final Color color;

  _UpwardTrendLinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();

    path.moveTo(-size.width * 0.1, size.height * 0.8);

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
