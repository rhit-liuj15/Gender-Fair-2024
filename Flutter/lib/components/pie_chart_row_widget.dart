import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gender_fair_2024/components/pie_chart_widget.dart';

class PieChartRowWidget extends StatefulWidget {
  final String rowTitle;
  final bool showTitle;
  final List<String> chartTitles;
  final List<String> dataLabels;
  final List<List<double>> datasets;
  final List<Color> colors;
  final double size;
  final double pieChartShowPercentageSliceSizeCutoff;
  final TextAlign titleTextAlign;
  final double textSizeRatio;

  const PieChartRowWidget({
    super.key,
    required this.rowTitle,
    required this.chartTitles,
    required this.dataLabels,
    required this.datasets,
    required this.colors,
    this.size = 200,
    this.showTitle = true,
    this.pieChartShowPercentageSliceSizeCutoff = 0.1,
    this.titleTextAlign = TextAlign.center,
    this.textSizeRatio = 0.10,
  });
  @override
  State<PieChartRowWidget> createState() => _PieChartRowWidgetState();
}

class _PieChartRowWidgetState extends State<PieChartRowWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.chartTitles.length != widget.datasets.length) {
      throw Exception(
          "Pie chart row '${widget.rowTitle}' oobserved a length mismatch between the number of chart titles and chart datasets supplied.\n\fNumber of chart titles: ${widget.chartTitles.length}\n\fNumber of chart datasets: ${widget.datasets.length}");
    }

    List<Widget> pieCharts = [];

    for (int i = 0; i < widget.chartTitles.length; i++) {
      pieCharts.add(PieChartWidget(
        title: widget.chartTitles[i],
        labels: widget.dataLabels,
        values: widget.datasets[i],
        colors: widget.colors,
        size: widget.size,
      ));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: pieCharts,
        );
        // return Row(
        //   mainAxisSize: MainAxisSize.min,
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: pieCharts,
        // );
      },
    );
  }

  List<PieChartSectionData> showingSections(
      List<String> labels, List<double> values, List<Color> colors) {
    return List.generate(values.length, (index) {
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? widget.size * 0.12 : widget.size * 0.09;
      final radius = isTouched ? widget.size * 0.32 : widget.size * 0.3;
      return PieChartSectionData(
        color: colors[index],
        value: values[index],
        title:
            "${(values[index] * 100).toStringAsFixed(1)}%", // ✅ Percentage inside chart
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: (values[index] >= widget.pieChartShowPercentageSliceSizeCutoff)
              ? Colors.white
              : Colors.black,
        ),
        showTitle:
            (values[index] >= widget.pieChartShowPercentageSliceSizeCutoff)
                ? true
                : (index == touchedIndex),
        titlePositionPercentageOffset:
            (values[index] >= widget.pieChartShowPercentageSliceSizeCutoff)
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
