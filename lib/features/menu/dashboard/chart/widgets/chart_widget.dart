import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ChartWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const ChartWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final labels = (data['labels'] as List).cast<String>();
    final values = (data['values'] as List)
        .map((e) =>
    e is num ? e.toDouble() : double.tryParse(e.toString()) ?? 0.0)
        .toList();

    final spots = List<FlSpot>.generate(
      values.length,
          (i) => FlSpot(i.toDouble(), values[i]),
    );

    double computedMax = values.isEmpty
        ? 10.0
        : values.reduce((a, b) => a > b ? a : b).toDouble();
    double computedMin = values.isEmpty
        ? 0.0
        : values.reduce((a, b) => a < b ? a : b).toDouble();

    final paddingTop = (computedMax.abs() * 0.1).clamp(5.0, 1000000.0);
    final paddingBottom = (computedMin.abs() * 0.1).clamp(5.0, 1000000.0);

    double maxY = computedMax + paddingTop;
    double minY = computedMin - paddingBottom;

    if (maxY <= minY) {
      maxY = computedMax + 10.0;
      minY = computedMin - 10.0;
    }

    final screenSize = MediaQuery.of(context).size;
    final chartWidth = values.length > 8
        ? screenSize.width * (values.length / 8)
        : screenSize.width * 0.9;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: chartWidth,
          height: screenSize.height * 0.28,
          child: LineChart(
            LineChartData(
              backgroundColor: Colors.transparent,
              minX: 0,
              maxX: (labels.length - 1).toDouble().clamp(0.0, double.infinity),
              minY: minY,
              maxY: maxY,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                drawHorizontalLine: false,
                getDrawingVerticalLine: (value) => FlLine(
                  color: Colors.white24,
                  strokeWidth: 1.2,
                ),
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (value == index.toDouble() &&
                          index >= 0 &&
                          index < labels.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            labels[index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFA500), Color(0xFFFFE066)],
                  ),
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) =>
                        FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 0,
                        ),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFFFA500).withOpacity(0.25),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
