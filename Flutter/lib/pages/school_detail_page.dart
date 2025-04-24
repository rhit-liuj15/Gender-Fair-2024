import 'package:flutter/material.dart';
import 'package:gender_fair_2024/components/pie_chart_row_widget.dart';
import 'package:gender_fair_2024/components/pie_chart_widget.dart';
import 'package:gender_fair_2024/models/data_loader.dart';
import 'package:gender_fair_2024/models/school_data.dart';
import 'package:gender_fair_2024/components/bar_chart_widget.dart';

class SchoolDetailPage extends StatefulWidget {
  final int uid;
  const SchoolDetailPage({super.key, required this.uid});

  @override
  State<SchoolDetailPage> createState() => _SchoolDetailPageState();
}

class _SchoolDetailPageState extends State<SchoolDetailPage> {
  late SchoolData schoolData;
  bool isLoading = true;

	List<String> genderLabels = const ["Women", "Men"];
	List<Color> genderColors = const [Colors.pink, Colors.blue];
	List<String> raceLabels = const [
		"White",
		"Black",
		"Asian",
		"Hispanic",
		"Native Hawaiian/Pacific Islander",
		"Native American/Alaskan Native",
		"Other"
	];
	List<Color> raceColors = [
		Colors.yellow[800]!,
		Colors.brown,
		Colors.blue,
		Colors.green,
		Colors.red,
		Colors.cyan,
		Colors.purple,
	];
	List<String> academicRankLabels = const [
		"Professors",
		"Associate Professors",
		"Assistant Professors",
		"Instructors",
		"Lecturers",
	];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await DataLoader.instance.requestSchoolData({widget.uid});
    setState(() {
      schoolData = DataLoader.instance.allSchoolData[widget.uid] ??
          SchoolData.unknownUID(widget.uid);
      isLoading = false;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Loading...")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(schoolData.getName()),
      ),
      body: schoolData.isInvalid
          ? const Center(child: Text("No data available for this school."))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                            title: "Academic Staff Gender Ratio",
                            labels: genderLabels,
                            values: [
                              schoolData.getInt("ACDTOTWOMEN"),
                              schoolData.getInt("ACDTOTMEN"),
                            ],
                            colors: genderColors,
                          ),
                          PieChartWidget(
                            title: "Academic Staff Race Ratio",
                            labels: raceLabels,
                            values: [
                              schoolData.getInt("ACDTOTWHIT"),
                              schoolData.getInt("ACDTOTBLAK"),
                              schoolData.getInt("ACDTOTASIA"),
                              schoolData.getInt("ACDTOTHISP"),
                              schoolData.getInt("ACDTOTNHPI"),
                              schoolData.getInt("ACDTOTNAMC"),
                              schoolData.getInt("ACDTOTNRES") + 
                              schoolData.getInt("ACDTOTTWOP") + 
                              schoolData.getInt("ACDTOTUNKN"),
                            ],
                            colors: raceColors,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                        child: PieChartRowWidget(
                      rowTitle: "iuahmtchoktiejofwpoeifiwelia",
                      chartTitles: academicRankLabels,
                      dataLabels: genderLabels,
                      datasets: [
                        [
                          schoolData.getInt("PROFWOMEN"),
                          schoolData.getInt("PROFMEN"),
                        ],
                        [
                          schoolData.getInt("ASSOCIATEPROFWOMEN"),
                          schoolData.getInt("ASSOCIATEPROFMEN"),
                        ],
                        [
                          schoolData.getInt("ASSISTANTPROFWOMEN"),
                          schoolData.getInt("ASSISTANTPROFMEN"),
                        ],
                        [
                          schoolData.getInt("INSTRUCTORWOMEN"),
                          schoolData.getInt("INSTRUCTORMEN"),
                        ],
                        [
                          schoolData.getInt("LECTURERWOMEN"),
                          schoolData.getInt("LECTURERMEN"),
                        ],
                      ],
                      size: 120,
                      colors: genderColors
                    )),
                    const SizedBox(height: 10),
                    Center(
                      child: PieChartRowWidget(
                        rowTitle: "nawoeujtnlkuhdfoiauhdw;otihlkjwhaeliuthoiul",
												chartTitles: academicRankLabels,
												dataLabels: raceLabels,
                        datasets: [
                          [
														schoolData.getInt("PROFWHIT"),
														schoolData.getInt("PROFBLAK"),
														schoolData.getInt("PROFASIA"),
														schoolData.getInt("PROFHISP"),
														schoolData.getInt("PROFNHPI"),
														schoolData.getInt("PROFNAMC"),
														schoolData.getInt("PROFNRES") + 
														schoolData.getInt("PROFTWOP") + 
														schoolData.getInt("PROFUNKN"),
                          ],
                          [
														schoolData.getInt("ASSOCIATEPROFWHIT"),
														schoolData.getInt("ASSOCIATEPROFBLAK"),
														schoolData.getInt("ASSOCIATEPROFASIA"),
														schoolData.getInt("ASSOCIATEPROFHISP"),
														schoolData.getInt("ASSOCIATEPROFNHPI"),
														schoolData.getInt("ASSOCIATEPROFNAMC"),
														schoolData.getInt("ASSOCIATEPROFNRES") + 
														schoolData.getInt("ASSOCIATEPROFTWOP") + 
														schoolData.getInt("ASSOCIATEPROFUNKN"),
                          ],
                          [
														schoolData.getInt("ASSISTANTPROFWHIT"),
														schoolData.getInt("ASSISTANTPROFBLAK"),
														schoolData.getInt("ASSISTANTPROFASIA"),
														schoolData.getInt("ASSISTANTPROFHISP"),
														schoolData.getInt("ASSISTANTPROFNHPI"),
														schoolData.getInt("ASSISTANTPROFNAMC"),
														schoolData.getInt("ASSISTANTPROFNRES") + 
														schoolData.getInt("ASSISTANTPROFTWOP") + 
														schoolData.getInt("ASSISTANTPROFUNKN"),
                          ],
                          [
														schoolData.getInt("INSTRUCTORWHIT"),
														schoolData.getInt("INSTRUCTORBLAK"),
														schoolData.getInt("INSTRUCTORASIA"),
														schoolData.getInt("INSTRUCTORHISP"),
														schoolData.getInt("INSTRUCTORNHPI"),
														schoolData.getInt("INSTRUCTORNAMC"),
														schoolData.getInt("INSTRUCTORNRES") + 
														schoolData.getInt("INSTRUCTORTWOP") + 
														schoolData.getInt("INSTRUCTORUNKN"),
                          ],
                          [
														schoolData.getInt("LECTURERWHIT"),
														schoolData.getInt("LECTURERBLAK"),
														schoolData.getInt("LECTURERASIA"),
														schoolData.getInt("LECTURERHISP"),
														schoolData.getInt("LECTURERNHPI"),
														schoolData.getInt("LECTURERNAMC"),
														schoolData.getInt("LECTURERNRES") + 
														schoolData.getInt("LECTURERTWOP") + 
														schoolData.getInt("LECTURERUNKN"),
                          ],
                        ],
                        size: 120,
                        showTitle: false,
                        colors: raceColors
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
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 20,
                        alignment: WrapAlignment.center,
                        children: [
                          PieChartWidget(
                            title: "Non-academic Staff Gender Ratio",
                            labels: genderLabels,
                            values: [
                              schoolData.getInt("NONACDWOMEN"),
                              schoolData.getInt("NONACDMEN"),
                            ],
                            colors: genderColors,
                          ),
                          PieChartWidget(
                            title: "Non-academic Staff Race Ratio",
                            labels: raceLabels,
                            values: [
                              schoolData.getInt("NONACDWHIT"),
                              schoolData.getInt("NONACDBLAK"),
                              schoolData.getInt("NONACDASIA"),
                              schoolData.getInt("NONACDHISP"),
                              schoolData.getInt("NONACDNHPI"),
                              schoolData.getInt("NONACDNAMC"),
                              schoolData.getInt("NONACDNRES") + 
                              schoolData.getInt("NONACDTWOP") + 
                              schoolData.getInt("NONACDUNKN"),
                            ],
                            colors: raceColors,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Align the charts to the top
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 0.0),
                              child: Text(
                                "Average Annual Salary by Gender (USD)",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 300,
                              width: 400,
                              child: BarChartWidget(
                                data: {
                                  "Men": schoolData.getInt("SALARYTOTACDM")/schoolData.getInt("ACDPOPM"),
                                  "Women": schoolData.getInt("SALARYTOTACDF")/schoolData.getInt("ACDPOPF"),
                                },
                                colors: const [Colors.blue, Colors.pink],
                                yAxisDescription: "Academic Staff Average Salary (USD)",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                            width:
                                30), // Space between Financials and the next two charts
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "Hate Crimes per Year",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 300,
                              width: 400,
                              child: BarChartWidget(
                                data: {
                                  "Hate Crimes Per Year Per 1000 Students":
                                      schoolData.getNum("YEARLYHATECRIME1K"),
                                },
                                colors: const [Colors.red],
                                yAxisDescription: "Cases per Year",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                            width: 30), // Space between the two new charts
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "VAWA(Violence Against Women Act) Incidents per Year",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 300,
                              width: 400,
                              child: BarChartWidget(
                                data: {
                                  "VAWA Cases Per Year Per 1000 Students":
                                      schoolData.getNum("YEARLYVAWA1K"),
                                },
                                colors: const [Colors.orange],
                                yAxisDescription: "Cases per Year",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
