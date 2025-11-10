import 'dart:ui';
import 'package:flutter/material.dart';

class SummaryCard extends StatefulWidget {
  final Color color;
  final String title;
  final String value;
  final IconData icon;
  final String? customerPercentage;

  const SummaryCard({
    super.key,
    required this.color,
    required this.title,
    required this.value,
    required this.icon,
    this.customerPercentage,
  });

  @override
  State<SummaryCard> createState() => _SummaryCardState();
}

class _SummaryCardState extends State<SummaryCard> {
  bool _isHovering = false;

  void _setHovering(bool value) {
    setState(() => _isHovering = value);
  }

  @override
  Widget build(BuildContext context) {
    final screenW = MediaQuery.of(context).size.width;
    final screenH = MediaQuery.of(context).size.height;

    final cardWidth = screenW < 600 ? screenW * 0.42 : screenW * 0.28;
    final cardHeight = screenH * 0.16;

    final double scale = _isHovering ? 1.07 : 1.0;
    final double tilt = _isHovering ? 0.04 : 0.0;

    return GestureDetector(
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
            width: cardWidth,
            height: cardHeight,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(_isHovering ? 0.45 : 0.25),
                  blurRadius: _isHovering ? 22 : 12,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // 🌫️ Frosted Blur Background
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.color.withOpacity(1.0),
                            Colors.white.withOpacity(1.0),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.8),
                          width: 1.2,
                        ),
                      ),
                    ),
                  ),

                  // 💡 Reflection Overlay (top-right)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.transparent
                          ],
                          center: Alignment.topRight,
                          radius: 1.0,
                        ),
                      ),
                    ),
                  ),

                  // 📈 Trend Line (bottom-right)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: CustomPaint(
                      size: const Size(60, 30),
                      painter: _UpwardTrendLinePainter(widget.color),
                    ),
                  ),

                  // 📊 Main Content
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Top Row: Icon + Percentage
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: constraints.maxHeight * 0.3,
                                    height: constraints.maxHeight * 0.3,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.9),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: widget.color.withOpacity(0.7),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      widget.icon,
                                      size: constraints.maxHeight * 0.18,
                                      color: widget.color,
                                    ),
                                  ),
                                  if (widget.customerPercentage != null)
                                    Text(
                                      widget.customerPercentage!,
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                        screenW < 400 ? 12 : 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                ],
                              ),
                              // Bottom Info
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      widget.value,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenW < 400 ? 18 : 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.title,
                                    style: TextStyle(
                                      color: Colors.grey.shade900,
                                      fontSize:
                                      screenW < 400 ? 12 : 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
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

// 📈 Custom Trend Line Painter
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
