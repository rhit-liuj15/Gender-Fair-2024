import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartWidget extends StatefulWidget {
  final Map<String, double> dataset;
	final String title;
  final double size;
  final double pieChartShowPercentageSliceSizeCutoff;
  final List<Color> colors;

  const PieChartWidget({
    super.key,
    required this.dataset,
		required this.title,
    required this.colors,
    this.size = 200,
    this.pieChartShowPercentageSliceSizeCutoff = 0.1,
  });

  @override
  State<PieChartWidget> createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {

		if (widget.dataset.length != widget.colors.length) {
			throw Exception("Pie chart '${widget.title}' has ${widget.dataset.length} data entries and ${widget.colors.length} color entries supplied, which does not match up");
		}

    final labels = widget.dataset.keys.toList();
    final values = widget.dataset.values.toList();
    final colors = widget.colors;

    return LayoutBuilder(
      builder: (context, constraints) {
				return SizedBox(
					width: widget.size,
					height: widget.size*1.3,
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
							centerSpaceRadius: widget.size*0.15,
						),
					),
        );
      },
    );
  }

  List<PieChartSectionData> showingSections(List<String> labels, List<double> values, List<Color> colors) {
    return List.generate(values.length, (index) {
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? widget.size*0.099 : widget.size*0.09;
      final radius = isTouched ? widget.size*0.33 : widget.size*0.3;
      return PieChartSectionData(
        color: colors[index],
        value: values[index],
        title: "${(values[index] * 100).toStringAsFixed(1)}%", // ✅ Percentage inside chart
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: (values[index] >= widget.pieChartShowPercentageSliceSizeCutoff) ? Colors.white : Colors.black,
        ),
				showTitle:  (values[index] >= widget.pieChartShowPercentageSliceSizeCutoff) ? true : (index == touchedIndex),
				titlePositionPercentageOffset: (values[index] >= widget.pieChartShowPercentageSliceSizeCutoff) ? 0.5 : 1.4,
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
