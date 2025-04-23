import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gender_fair_2024/components/pie_chart_row_widget.dart';

class PieChartWidget extends StatefulWidget {
	final String title;
	final bool showTitle;
	final bool showLabels;
  final List<String> labels;
  final List<double> values;
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
			throw Exception("Pie chart '${widget.title}' has ${widget.labels.length} data entries and ${widget.colors.length} color entries supplied, which does not match up");
		}

    final labels = widget.labels;
    final values = widget.values;
    final colors = widget.colors;

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
											height: widget.size*0.4,
											child: Center(
												child: Text(
													widget.title,
													textAlign: widget.titleTextAlign,
													style: TextStyle(fontWeight: FontWeight.bold, fontSize: widget.textSizeRatio*widget.size),
												),
											),
										),
									],
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
								],
							),
						),
						if (widget.showLabels) ...[
            SizedBox(width: widget.size*0.4),
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
				// titlePositionPercentageOffset: (values[index] >= widget.pieChartShowPercentageSliceSizeCutoff) ? 0.5 : 1.4,
      );
    });
  }
}