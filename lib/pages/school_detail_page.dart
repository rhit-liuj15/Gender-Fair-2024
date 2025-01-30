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

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await DataLoader.instance.requestSchoolData({widget.uid});
    setState(() {
      schoolData = DataLoader.instance.allSchools[widget.uid]!;
    });
  }

  double toDouble(dynamic v) {
    return (v is num) ? v.toDouble() : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final academic = schoolData.categories.firstWhere(
      (c) => c.categoryName == "Academic Staff Composition",
      orElse: () => schoolData.categories.first,
    );
    final nonAcademic = schoolData.categories.firstWhere(
      (c) => c.categoryName == "Non-Academic Staff Composition",
      orElse: () => schoolData.categories.first,
    );
    final financials = schoolData.categories.firstWhere(
      (c) => c.categoryName == "Financials",
      orElse: () => schoolData.categories.first,
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
    final avgSalaryWomen = toDouble(financials.data["Average Salary For Women"]);
    final financialData = {
      "Avg Salary Men": avgSalaryMen,
      "Avg Salary Women": avgSalaryWomen,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(schoolData.schoolName),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(schoolData.toString()),
            const SizedBox(height: 20),

            const Text(
              "Academic Staff Composition",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),

            // Horizontal Row with Centered Pie Charts
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: PieChartWidget(
                      data: {
                        "Women Professors": wProf,
                        "Men Professors": profMen,
                      },
                    ),
                  ),
                  const SizedBox(width: 40),
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: PieChartWidget(
                      data: {
                        "Women Assoc. Professors": wAssoc,
                        "Men Assoc. Professors": assocMen,
                      },
                    ),
                  ),
                  const SizedBox(width: 40),
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: PieChartWidget(
                      data: {
                        "Tenured Women": wTenure,
                        "Tenured Men": tenureMen,
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              "Non-Academic Staff Composition",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 200,
              height: 200,
              child: PieChartWidget(data: nonAcademicChartData),
            ),
            const SizedBox(height: 30),

            const Text(
              "Financials",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              width: 400,
              child: BarChartWidget(data: financialData),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
