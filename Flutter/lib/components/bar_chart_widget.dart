import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BarChartWidget extends StatelessWidget {
  final Map<String, num> data;
  final List<Color> colors;
  final String yAxisDescription;

  const BarChartWidget({
    super.key,
    required this.data,
    required this.colors,
    required this.yAxisDescription,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> labels = data.keys.toList();
    final List<num> values = data.values.toList();

    final bool hasValidData =
        values.isNotEmpty && values.any((v) => v > 0 && v.isFinite);

    if (!hasValidData) {
      return Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                yAxisDescription,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Center(
                child: Text(
                  "N/A",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // fixed crash by forcing maxY to be >= 1.0 mentioned in PR
    final double maxY = values.where((v) => v.isFinite && v >= 0).fold<double>(
        1.0, (prev, curr) => curr.toDouble() > prev ? curr.toDouble() : prev);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RotatedBox(
          quarterTurns: 3,
          child: Text(
            yAxisDescription,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 250,
          child: BarChart(
            BarChartData(
              barGroups: List.generate(labels.length, (index) {
                final double safeY =
                    values[index].isFinite && values[index] >= 0
                        ? values[index].toDouble()
                        : 0.0;
                return BarChartGroupData(
                  x: index,
                  barsSpace: 8,
                  barRods: [
                    BarChartRodData(
                      toY: safeY,
                      color: colors[index % colors.length],
                      width: 20,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                );
              }),
              barTouchData: BarTouchData(enabled: true),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                drawHorizontalLine: true,
                getDrawingHorizontalLine: (value) => const FlLine(
                  color: Colors.grey,
                  strokeWidth: 1,
                ),
                getDrawingVerticalLine: (value) => const FlLine(
                  color: Colors.grey,
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 50,
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      if (i >= 0 && i < labels.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            labels[i],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 60,
                    getTitlesWidget: (value, meta) {
                      if (value == maxY) {
                        return const SizedBox.shrink();
                      }
                      if (value % 1 == 0) {
                        return Text(
                          '${value.toInt()}',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Colors.black, width: 1),
              ),
              alignment: BarChartAlignment.center,
              maxY: maxY,
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}
