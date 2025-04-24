import 'package:flutter/material.dart';
import 'package:gender_fair_2024/components/pie_chart_widget.dart';

class PieChartRowWidget extends StatefulWidget {
  final String rowTitle;
  final bool showTitle;
  final List<String> chartTitles;
  final List<String> dataLabels;
  final List<List<num>> datasets;
  final List<Color> colors;
  final double size;
  final bool showTitleOnBottom;
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
    this.showTitleOnBottom = false,
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
          "Pie chart row '${widget.rowTitle}' observed a length mismatch between the number of chart titles and chart datasets supplied.\n\fNumber of chart titles: ${widget.chartTitles.length}\n\fNumber of chart datasets: ${widget.datasets.length}");
    }

    List<Widget> pieCharts = [];

    for (int i = 0; i < widget.chartTitles.length; i++) {
      pieCharts.add(PieChartWidget(
        title: widget.chartTitles[i],
        labels: widget.dataLabels,
        values: widget.datasets[i],
        colors: widget.colors,
        size: widget.size,
				showLabels: widget.chartTitles.length-i == 1,
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
      },
    );
  }
}