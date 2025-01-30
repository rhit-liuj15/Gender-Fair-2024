import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartWidget extends StatefulWidget {
  final Map<String, double> data;          // e.g. {"Women Professors": 0.3, "Men": 0.7}
  final double centerSpaceRadius;

  const PieChartWidget({
    Key? key,
    required this.data,
    this.centerSpaceRadius = 40,
  }) : super(key: key);

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final labels = widget.data.keys.toList();
    final values = widget.data.values.toList();

    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (event, response) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  response == null ||
                  response.touchedSection == null) {
                touchedIndex = -1;
              } else {
                touchedIndex = response.touchedSection!.touchedSectionIndex;
              }
            });
          },
        ),
        sections: List.generate(values.length, (index) {
          final isTouched = index == touchedIndex;
          return PieChartSectionData(
            color: Colors.primaries[index % Colors.primaries.length],
            value: values[index],
            title: labels[index],
            titleStyle: TextStyle(
              fontSize: isTouched ? 18 : 14,
              fontWeight: FontWeight.bold,
            ),
            radius: isTouched ? 70 : 60,
          );
        }),
        centerSpaceRadius: widget.centerSpaceRadius,
        borderData: FlBorderData(show: false),
      ),
    );
  }
}
