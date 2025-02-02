import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BarChartWidget extends StatelessWidget {
  final Map<String, double> data;
  final List<String> labels;
  final List<Color> colors;
  final String unit;
  final String yAxisDescription;

  const BarChartWidget({
    Key? key,
    required this.data,
    required this.labels,
    required this.colors,
    required this.yAxisDescription,
    this.unit = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final values = data.values.toList();
    // Calculate the maxY value, ensuring it's at least 10
    final maxY = values.isEmpty ? 10.0 : (values.reduce((a, b) => a > b ? a : b) < 10 ? 10.0 : values.reduce((a, b) => a > b ? a : b));

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
                return BarChartGroupData(
                  x: index,
                  barsSpace: 8,
                  barRods: [
                    BarChartRodData(
                      toY: values[index],
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
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.grey,
                  strokeWidth: 1,
                ),
                getDrawingVerticalLine: (value) => FlLine(
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
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
