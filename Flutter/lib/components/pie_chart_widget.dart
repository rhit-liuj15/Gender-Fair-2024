import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartWidget extends StatefulWidget {
  final String title;
  final bool showTitle;
  final bool showLabels;
  final List<String> labels;
  final List<num> values;
  final List<Color> colors;
  final double size;
  final double pieChartShowPercentageSliceSizeCutoff;
  final TextAlign titleTextAlign;
  final double textSizeRatio;

  const PieChartWidget({
    super.key,
    required this.title,
    required this.labels,
    required this.values,
    required this.colors,
    this.showTitle = true,
    this.showLabels = true,
    this.size = 200,
    this.pieChartShowPercentageSliceSizeCutoff = 0.1,
    this.titleTextAlign = TextAlign.center,
    this.textSizeRatio = 0.10,
  });

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {		
    if (widget.labels.length != widget.colors.length) {
      throw Exception(
          "Pie chart '${widget.title}' observed a length mismatch between the number of labels, values, and colors supplied.\n\fNumber of labels: ${widget.labels.length}\n\fNumber of values: ${widget.values.length}\n\fNumber of colors: ${widget.colors.length}");
    }

    final labels = widget.labels;
    final values = widget.values;
    final colors = widget.colors;
		
		final num chartSliceCutoff = widget.values.reduce((a, b) => a + b) * widget.pieChartShowPercentageSliceSizeCutoff;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: widget.size,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.showTitle) ...[
                    SizedBox(
                      width: widget.size,
                      height: widget.size * 0.4,
                      child: Center(
                        child: Text(
                          widget.title,
                          textAlign: widget.titleTextAlign,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: widget.textSizeRatio * widget.size),
                        ),
                      ),
                    ),
                  ],
                  SizedBox(
                    width: widget.size,
                    height: widget.size * 1.3,
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (event, response) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  response?.touchedSection == null) {
                                touchedIndex = -1;
                              } else {
                                touchedIndex = response!
                                    .touchedSection!.touchedSectionIndex;
                              }
                            });
                          },
                        ),
                        sections: showingSections(labels, values, colors, chartSliceCutoff),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 0,
                        centerSpaceRadius: widget.size * 0.15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.showLabels) ...[
              SizedBox(width: widget.size * 0.4),
              SizedBox(
                width: 120,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(labels.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Indicator(
                        color: colors[index],
                        text: labels[index],
                        isSquare: true,
                        size: widget.size,
                        colorBoxSizeRatio: 0.07,
                        textSizeRatio: widget.textSizeRatio,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  List<PieChartSectionData> showingSections(
      List<String> labels, List<num> values, List<Color> colors, num chartSliceCutoff) {
    return List.generate(values.length, (index) {
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? widget.size * 0.099 : widget.size * 0.09;
      final radius = isTouched ? widget.size * 0.33 : widget.size * 0.3;
      return PieChartSectionData(
        color: colors[index],
        value: values[index].toDouble(),
        title:
            // "${(values[index] * 100).toStringAsFixed(1)}%", // ✅ Percentage inside chart
            "${values[index]}", // ✅ Percentage inside chart
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: (values[index] >= chartSliceCutoff)
              ? Colors.white
              : Colors.black,
        ),
        showTitle:
            (values[index] >= chartSliceCutoff)
                ? true
                : (index == touchedIndex),
        titlePositionPercentageOffset:
            (values[index] >= chartSliceCutoff)
                ? 0.5
                : 1.4,
      );
    });
  }
}



class Indicator extends StatelessWidget {
  final Color color;
  final String text;
  final double size;
  final bool isSquare;
  final double colorBoxSizeRatio;
  final double textSizeRatio;

  const Indicator({
    super.key,
    required this.color,
    required this.text,
    this.isSquare = false,
    required this.size,
    required this.colorBoxSizeRatio,
    required this.textSizeRatio,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size * colorBoxSizeRatio,
          height: size * colorBoxSizeRatio,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
                fontSize: size * textSizeRatio, fontWeight: FontWeight.w500),
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }
}
