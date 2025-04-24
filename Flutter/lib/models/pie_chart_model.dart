import 'dart:ui';

import 'package:flutter/material.dart';

// PieChartsData is meant for use with multiple pie charts that share the exact same size, labels and colors.
// If pie charts with different appearances are needed, please separately construct a Row() of pie charts
// each accepting a PieChartData

class RowOfPieChartsUsingTheSameMetadata {
  final List<PieChartRowPiece> pieCharts;
  final double size;
  final List<String> labelText;
  final List<Color> labelColors;
  final bool labelsAtBottom;
  final bool showTitle;
  final TextAlign titleTextAlign;

  RowOfPieChartsUsingTheSameMetadata({
    required this.pieCharts,
    required this.size,
    required this.labelText,
    required this.labelColors,
    this.labelsAtBottom = true,
    this.showTitle = true,
    this.titleTextAlign = TextAlign.center,
  });

  Widget generate() {
    List<Widget> pieChartWidgets = [];
    for (PieChartRowPiece element in pieCharts) {}
    if (labelsAtBottom) {
      pieChartWidgets.add(const Text("This text blahblah pie chart model"));
      return SizedBox(
        width: size,
        child: Wrap(
          spacing: 20,
          runSpacing: 20,
          alignment: WrapAlignment.center,
          children: pieChartWidgets,
        ),
      );
    } else {
      return SizedBox(
        width: size,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: pieChartWidgets,
            ),
            const Text("This text blahblah pie chart model"),
          ],
        ),
      );
    }
  }
}

class PieChartRowPiece {
  final String title;
  final List<double> values;
  PieChartRowPiece({
    required this.title,
    required this.values,
  });
}
