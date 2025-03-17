import 'package:flutter/material.dart';
import 'package:gender_fair_2024/models/school_score.dart';
import 'package:gender_fair_2024/components/bar_chart_widget.dart';

class MetricBarChart extends StatelessWidget {
  final List<SchoolScore> schools;
  final SchoolScoreAttributes metric;

  const MetricBarChart({
    super.key,
    required this.schools,
    required this.metric,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, double> data = {
      for (var school in schools)
        school.schoolName: (school.subscores[metric]?.toDouble()  ?? 0.0 ),
    };

    final List<Color> assignedColors = List.generate(
      schools.length,
      (index) {
        final hue = (360.0 / schools.length) * index;
        return HSLColor.fromAHSL(1.0, hue, 0.6, 0.6).toColor();
      },
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        double chartWidth = constraints.maxWidth;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              metric.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: chartWidth,
              height: 190,
              child: BarChartWidget(
                data: data,
                colors: assignedColors,
                labels: List.generate(schools.length, (index) => ''),
                yAxisDescription: '',
              ),
            ),
          ],
        );
      },
    );
  }
}
