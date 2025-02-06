import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:gender_fair_2024/components/school_score_row.dart';
import 'package:gender_fair_2024/models/data_loader.dart';
import 'package:gender_fair_2024/models/school_score.dart';

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

  double maxColumnWidth = 100;
  
  Future<void> loadData() async {
    await DataLoader.instance.requestSchoolData(SchoolScoreRow.selectedSchools);
    setState(() {
      schoolScores = SchoolScoreRow.selectedSchools
          .map((uid) => DataLoader.instance.allScores[uid])
          .where((score) => score != null)
          .toList()
          .cast<SchoolScore>();

      final textPainter = TextPainter(
        textDirection: TextDirection.ltr,
      );

      for (var school in schoolScores) {
        textPainter.text = TextSpan(
          text: school.schoolName,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        );
        textPainter.layout();
        maxColumnWidth = maxColumnWidth > textPainter.width
            ? maxColumnWidth
            : textPainter.width + 20;
      }
    });
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
                  SizedBox(
                    height: 350,
                    child: ScrollConfiguration(
                      behavior: MyCustomScrollBehavior(),
                      child: Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        interactive: true,
                        child: Listener(
                          onPointerSignal: (pointerSignal) {
                            if (pointerSignal is PointerScrollEvent) {
                              final newOffset =
                                  _scrollController.offset +
                                      pointerSignal.scrollDelta.dy;
                              if (_scrollController.hasClients) {
                                _scrollController.jumpTo(newOffset);
                              }
                            }
                          },
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            controller: _scrollController,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    metricTitle(""),
                                    metricTitle("Leadership"),
                                    metricTitle("Policies"),
                                    metricTitle("Safety"),
                                    metricTitle("Diversity"),
                                    metricTitle("Total Score"),
                                  ],
                                ),
                                ...schoolScores.map(
                                  (school) => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      schoolTitle(school.schoolName),
                                      metricValue("${school.subscores[SchoolScoreAttributes.leadership]}"),
                                      metricValue("${school.subscores[SchoolScoreAttributes.polnpay]}"),
                                      metricValue("${school.subscores[SchoolScoreAttributes.safety]}"),
                                      metricValue("${school.subscores[SchoolScoreAttributes.diversity]}"),
                                      metricValue("${school.score}",
                                          isTotal: true),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
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


  Widget metricTitle(String title) {
    return Container(
      width: maxColumnWidth,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.black, width: 1),
          bottom: BorderSide(color: Colors.black, width: 1),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget schoolTitle(String name) {
    return Container(
      width: maxColumnWidth,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.black, width: 1),
          bottom: BorderSide(color: Colors.black, width: 1),
        ),
      ),
      child: Text(
        name,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget metricValue(String value, {bool isTotal = false}) {
    return Container(
      width: maxColumnWidth,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(color: Colors.black, width: 1),
          bottom: BorderSide(color: Colors.black, width: 1),
        ),
      ),
      child: Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          color: isTotal ? Colors.green : Colors.black,
        ),
      ),
    );
  }
}
