import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class PieChartWidgetWithLabels extends StatefulWidget {
  final Map<String, double> dataset;
	final String title;
  final double size;
  final double pieChartShowPercentageSliceSizeCutoff;
  final List<Color> colors;

  const PieChartWidgetWithLabels({
    super.key,
    required this.dataset,
		required this.title,
    required this.colors,
    this.size = 200,
    this.pieChartShowPercentageSliceSizeCutoff = 0.1,
  });

  @override
  State<PieChartWidgetWithLabels> createState() => _PieChartWidgetWithLabelsState();
}

class _PieChartWidgetWithLabelsState extends State<PieChartWidgetWithLabels> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {

		if (widget.dataset.length != widget.colors.length) {
			throw Exception("Pie chart '${widget.title}' has ${widget.dataset.length} data entries and ${widget.colors.length} color entries supplied, which does not match up");
		}

    final labels = widget.dataset.keys.toList();
    final values = widget.dataset.values.toList();
    final colors = widget.colors;

		// There are edge cases in the data which this does not handle well (see for example St. John's College, UID 163976).
		// In principal this is a nice feature, but until the data is properly formed this is not usable.

    // double sumValues = values.fold(0, (prev, val) => prev + val);
    // if (sumValues < 1.0) {
    //   labels.add("Other");
    //   values.add(1.0 - sumValues);
    //   colors.add(Colors.grey);
    //   percentages.add("");
    // }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
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
            ),
            SizedBox(width: widget.size*0.4),
            SizedBox(
              width: 120, 
              child: Column(
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
            ),
          ],
        );
      },
    );
  }

  List<PieChartSectionData> showingSections(List<String> labels, List<double> values, List<Color> colors) {
    return List.generate(values.length, (index) {
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? widget.size*0.12 : widget.size*0.09;
      final radius = isTouched ? widget.size*0.32 : widget.size*0.3;
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
