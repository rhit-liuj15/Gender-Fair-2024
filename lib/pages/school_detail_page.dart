import 'package:flutter/material.dart';
import 'package:gender_fair_2024/models/data_loader.dart';
import 'package:gender_fair_2024/models/school_data.dart';
import 'pie_chart_widget.dart';
import 'bar_chart_widget.dart';

class SchoolDetailPage extends StatefulWidget {
  final int uid;
  const SchoolDetailPage({Key? key, required this.uid}) : super(key: key);

  @override
  State<SchoolDetailPage> createState() => _SchoolDetailPageState();
}

class _SchoolDetailPageState extends State<SchoolDetailPage> {
  SchoolData schoolData = SchoolData.unknownUID(0);
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await DataLoader.instance.requestSchoolData({widget.uid});
    setState(() {
      schoolData = DataLoader.instance.allSchools[widget.uid] ??
          SchoolData.unknownUID(widget.uid);
      isLoading = false;
    });
  }

  double toDouble(dynamic v) {
    return (v is num) ? v.toDouble() : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Loading...")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final academic = schoolData.categories.firstWhere(
      (c) => c.categoryName == "Academic Staff Composition",
      orElse: () => SchoolDataCategory(categoryName: "Unknown", data: {}),
    );

    final nonAcademic = schoolData.categories.firstWhere(
      (c) => c.categoryName == "Non-Academic Staff Composition",
      orElse: () => SchoolDataCategory(categoryName: "Unknown", data: {}),
    );

    final financials = schoolData.categories.firstWhere(
      (c) => c.categoryName == "Financials",
      orElse: () => SchoolDataCategory(categoryName: "Unknown", data: {}),
    );

    final safety = schoolData.categories.firstWhere(
      (c) => c.categoryName == "Safety",
      orElse: () => SchoolDataCategory(categoryName: "Unknown", data: {}),
    );

    final wProf = toDouble(academic.data["Women Professors"]);
    final wAssoc = toDouble(academic.data["Women Associate Professors"]);
    final wTenure = toDouble(academic.data["Tenured Women Academic Staff"]);
    final profMen = 1.0 - wProf;
    final assocMen = 1.0 - wAssoc;
    final tenureMen = 1.0 - wTenure;

    final black = toDouble(nonAcademic.data["Black"]);
    final hispanic = toDouble(nonAcademic.data["Hispanic"]);
    final asian = toDouble(nonAcademic.data["Asian"]);
    final sumRace = black + hispanic + asian;
    final white = (sumRace < 1.0) ? (1.0 - sumRace) : 0.0;

    final nonAcademicChartData = {
      "Black": black,
      "Hispanic": hispanic,
      "Asian": asian,
      "White": white,
    };

    final avgSalaryMen = toDouble(financials.data["Average Salary For Men"]);
    final avgSalaryWomen =
        toDouble(financials.data["Average Salary For Women"]);

    final financialData = {
      "Avg Salary Men": avgSalaryMen,
      "Avg Salary Women": avgSalaryWomen,
    };

    final hateCrimes = toDouble(safety.data["Hate Crimes Per Year 2020-2022"]);
    final vawaIncidents = toDouble(safety.data["VAWA Per Year 2020-2022"]);

    final safetyData = {
      "Hate Crimes": hateCrimes,
      "VAWA Cases": vawaIncidents,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(schoolData.schoolName),
      ),
      body: schoolData.categories.isEmpty
          ? const Center(child: Text("No data available for this school."))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    //Text(schoolData.toString()),  //remove the text for data for now
                    const SizedBox(height: 20),

                    // Academic Pie Charts
                    const Text(
                      "Academic Staff Composition",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment: WrapAlignment.center,
                        children: [
                          PieChartWidget(
                            data: {
                              "Women Professors": wProf,
                              "Men Professors": profMen,
                            },
                          ),
                          PieChartWidget(
                            data: {
                              "Women Assoc. Professors": wAssoc,
                              "Men Assoc. Professors": assocMen,
                            },
                          ),
                          PieChartWidget(
                            data: {
                              "Tenured Women": wTenure,
                              "Tenured Men": tenureMen,
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Non-Academic Pie Chart
                    const Text(
                      "Non-Academic Staff Composition",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: PieChartWidget(data: nonAcademicChartData),
                    ),
                    const SizedBox(height: 30),

                    // Financials & Safety Charts (Side-by-Side)
                    const Text(
                      "Financials & Safety",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 300,
                            width: 400,
                            child: BarChartWidget(
                              data: financialData,
                              colors: [
                                Colors.blue,
                                Colors.pink
                              ], // Financial chart colors
                              labels: [
                                "Men's Avg Salary",
                                "Women's Avg Salary"
                              ], // Custom Labels
                            ),
                          ),
                          const SizedBox(width: 30),
                          SizedBox(
                            height: 300,
                            width: 400,
                            child: BarChartWidget(
                              data: safetyData,
                              colors: [
                                Colors.red,
                                Colors.orange
                              ], // Safety chart colors
                              labels: [
                                "Hate ",
                                "VAWA"
                              ], // Custom Labels
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
    );
  }
}
