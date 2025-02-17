import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:gender_fair_2024/components/school_score_row.dart';
import 'package:gender_fair_2024/models/data_loader.dart';
import 'package:gender_fair_2024/models/school_score.dart';
import 'package:gender_fair_2024/components/metric_bar_chart.dart'; // Import the new widget

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.unknown,
      };
}

class SchoolComparisonPage extends StatefulWidget {
  const SchoolComparisonPage({super.key});

  @override
  State<SchoolComparisonPage> createState() => _SchoolComparisonPageState();
}

class _SchoolComparisonPageState extends State<SchoolComparisonPage> {
  List<SchoolScore> schoolScores = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> loadData() async {
    await DataLoader.instance.requestSchoolData(SchoolScoreRow.selectedSchools);
    setState(() {
      schoolScores = SchoolScoreRow.selectedSchools
          .map((uid) => DataLoader.instance.allScores[uid])
          .where((score) => score != null)
          .toList()
          .cast<SchoolScore>();
    });
  }

  Widget _buildColorIndicatorSection(List<SchoolScore> schools) {
  final List<Color> assignedColors = List.generate(
    schools.length,
    (index) {
      final hue = (360.0 / schools.length) * index;
      return HSLColor.fromAHSL(1.0, hue, 0.6, 0.6).toColor();
    },
  );
  return Wrap(
    spacing: 8,
    runSpacing: 8,
    alignment: WrapAlignment.center,
    children: List.generate(schools.length, (index) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            color: assignedColors[index],
          ),
          const SizedBox(width: 4),
          Text(
            schools[index].schoolName,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      );
    }),
  );
}


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            color: Colors.black.withOpacity(0.5),
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Center(
          child: Container(
            width: 1000,
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Comparing ${schoolScores.length} Schools",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const Divider(),
                if (schoolScores.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text("No schools selected for comparison."),
                    ),
                  )
                else
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: MetricBarChart(
                                  schools: schoolScores,
                                  metric: SchoolScoreAttributes.leadership,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: MetricBarChart(
                                  schools: schoolScores,
                                  metric: SchoolScoreAttributes.polnpay,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              Expanded(
                                child: MetricBarChart(
                                  schools: schoolScores,
                                  metric: SchoolScoreAttributes.safety,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: MetricBarChart(
                                  schools: schoolScores,
                                  metric: SchoolScoreAttributes.diversity,
                                ),
                              ),
                            ],
                          ),
                          _buildColorIndicatorSection(schoolScores),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
