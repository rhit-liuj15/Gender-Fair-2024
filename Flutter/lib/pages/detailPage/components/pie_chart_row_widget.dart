import 'package:flutter/material.dart';
import 'package:gender_fair_2024/pages/detailPage/components/pie_chart_widget.dart';

class PieChartRowWidget extends StatefulWidget {
	/// A widget that creates a row of pie charts
	/// 
	/// The pie chart row has its own [rowTitle], separate from the [chartTitles] which are passed to the pie charts.
	/// 
	/// the pie chart requires [chartTitles] and [datasets] of equal length at first index.
	
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
    this.pieChartShowPercentageSliceSizeCutoff = 0.18,
    this.titleTextAlign = TextAlign.center,
    this.textSizeRatio = 0.10,
  });

  @override
  State<PieChartRowWidget> createState() => _PieChartRowWidgetState();
}

class _PieChartRowWidgetState extends State<PieChartRowWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.chartTitles.length != widget.datasets.length) {
      throw Exception(
        "Pie chart row '${widget.rowTitle}' observed a length mismatch between chartTitles and datasets."
      );
    }

    final pieCharts = List<Widget>.generate(widget.chartTitles.length, (i) {
      return PieChartWidget(
        title: widget.chartTitles[i],
        labels: widget.dataLabels,
        values: widget.datasets[i],
        colors: widget.colors,
        size: widget.size,
        showLabels: !widget.showTitleOnBottom && (i == widget.chartTitles.length - 1),
        pieChartShowPercentageSliceSizeCutoff: widget.pieChartShowPercentageSliceSizeCutoff,
        titleTextAlign: widget.titleTextAlign,
        textSizeRatio: widget.textSizeRatio,
      );
    });

    final legend = Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 8,
      children: List<Widget>.generate(widget.dataLabels.length, (j) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: widget.size * 0.07,
              height: widget.size * 0.07,
              color: widget.colors[j],
            ),
            const SizedBox(width: 4),
            Text(
              widget.dataLabels[j],
              style: TextStyle(
                fontSize: widget.size * widget.textSizeRatio,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      }),
    );

    final header = widget.showTitle && !widget.showTitleOnBottom
        ? Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.rowTitle,
              style: TextStyle(
                fontSize: widget.size * 0.12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          )
        : const SizedBox.shrink();

    final footer = widget.showTitle && widget.showTitleOnBottom
        ? Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              widget.rowTitle,
              style: TextStyle(
                fontSize: widget.size * 0.12,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          )
        : const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        header,
        Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: pieCharts,
        ),
        if (widget.showTitleOnBottom) ...[
          const SizedBox(height: 12),
          legend,
          footer,
        ],
      ],
    );
  }
}
