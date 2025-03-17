import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartWidget extends StatefulWidget {
  final Map<String, double> data; 
  final double centerSpaceRadius;
  final List<Color> colors;
  final List<String>? dataPercentage; 
  final bool showPercentage; // Boolean to control percentage display on legend

  const PieChartWidget({
    super.key,
    required this.data,
    required this.colors,
    this.centerSpaceRadius = 30,
    this.dataPercentage, 
    this.showPercentage = false,
  });

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final labels = widget.data.keys.toList();
    final values = widget.data.values.toList();
    final colors = widget.colors;

    final percentages = widget.showPercentage
        ? widget.dataPercentage ??
            values.map((value) => "${(value * 100).toStringAsFixed(1)}%").toList()
        : List.filled(labels.length, "");

    double sumValues = values.fold(0, (prev, val) => prev + val);
    if (sumValues < 1.0) {
      labels.add("Other");
      values.add(1.0 - sumValues);
      colors.add(Colors.grey);
      percentages.add("");
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 140,
              height: 140,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (event, response) {
                      setState(() {
                        if (!event.isInterestedForInteractions || response?.touchedSection == null) {
                          touchedIndex = -1;
                        } else {
                          touchedIndex = response!.touchedSection!.touchedSectionIndex;
                        }
                      });
                    },
                  ),
                  sections: showingSections(labels, values, colors),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 0,
                  centerSpaceRadius: widget.centerSpaceRadius,
                ),
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 120, 
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(labels.length, (index) {
                  final displayText = percentages[index].isNotEmpty 
                    ? "${labels[index]} : ${percentages[index]}" 
                    : labels[index];
                
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Indicator(
                      color: colors[index],
                      text: displayText,
                      isSquare: true,
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }

  List<PieChartSectionData> showingSections(List<String> labels, List<double> values, List<Color> colors) {
    return List.generate(values.length, (index) {
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 16.0 : 12.0;
      final radius = isTouched ? 55.0 : 45.0;
      return PieChartSectionData(
        color: colors[index],
        value: values[index],
        title: values[index] > 0.05 ? "${(values[index] * 100).toStringAsFixed(1)}%" : "", // ✅ Percentage inside chart
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      );
    });
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final bool isSquare;

  const Indicator({
    super.key,
    required this.color,
    required this.text,
    this.isSquare = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }
}
