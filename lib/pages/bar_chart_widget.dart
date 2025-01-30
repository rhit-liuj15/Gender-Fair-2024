import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BarChartWidget extends StatelessWidget {
  final Map<String, double> data; 
  final Color barColor;

  const BarChartWidget({
    Key? key,
    required this.data,
    this.barColor = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titles = data.keys.toList();
    final values = data.values.toList();
    final maxY = values.isEmpty
        ? 0.0
        : (values.reduce((a, b) => a > b ? a : b) * 1.1);

    return BarChart(
      BarChartData(
        rotationQuarterTurns: 0, // Keep bars vertical
        barGroups: List.generate(titles.length, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: values[index],
                color: barColor,
                width: 20,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          );
        }),
        barTouchData: BarTouchData(enabled: false),
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                final i = value.toInt();
                if (i >= 0 && i < titles.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      titles[i],
                      textAlign: TextAlign.center,
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
              reservedSize: 50,
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString());
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
      ),
    );
  }
}
