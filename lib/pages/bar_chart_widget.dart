import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BarChartWidget extends StatelessWidget {
  final Map<String, double> data; 
  final List<String> labels;
  final List<Color> colors;

  const BarChartWidget({
    Key? key,
    required this.data,
    required this.labels,
    required this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titles = data.keys.toList();
    final values = data.values.toList();
    final maxY = values.isEmpty ? 0.0 : ((values.reduce((a, b) => a > b ? a : b) / 10).ceil() * 10).toDouble();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: BarChart(
            BarChartData(
              barGroups: List.generate(titles.length, (index) {
                return BarChartGroupData(
                  x: index,
                  barsSpace: 12,
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
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      if (i >= 0 && i < titles.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            titles[i],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
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
                      return Text(
                        '${value.toInt()}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      );
                    },
                  ),
                ),
                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              alignment: BarChartAlignment.center,
              maxY: maxY,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(labels.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Indicator(
                color: colors[index],
                text: labels[index],
                isSquare: true,
              ),
            );
          }),
        ),
      ],
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;

  const Indicator({
    Key? key,
    required this.color,
    required this.text,
    this.isSquare = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
