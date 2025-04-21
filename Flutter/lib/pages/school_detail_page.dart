import 'package:flutter/material.dart';
import 'package:gender_fair_2024/components/pie_chart_widget.dart';
import 'package:gender_fair_2024/components/pie_chart_widget_with_labels.dart';
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
      schoolData = DataLoader.instance.allSchoolData[widget.uid] ??
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

    return Scaffold(
      appBar: AppBar(
        title: Text(schoolData.getName()),
      ),
      body: schoolData.data.isEmpty
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
										PieChartWidgetWithLabels(
											title: "Academic Staff Gender Ratio",
											dataset: {
												"Women": schoolData.data["ACDWOMENPCT"] ?? 0.0,
												"Men":
														1.0 - (schoolData.data["ACDWOMENPCT"] ?? 0.0),
											},
											colors: const [Colors.pink, Colors.blue],
										),
										PieChartWidgetWithLabels(
											title: "Academic Staff Race Ratio",
											dataset: {
												"Black": schoolData.data["ACDBLKPCT"] ?? 0.0,
												"Hispanic": schoolData.data["ACDHSPPCT"] ?? 0.0,
												"Asian": schoolData.data["ACDASIAPCT"] ?? 0.0,
												"White": 1.0 -
														(schoolData.data["ACDBLKPCT"] ?? 0.0) -
														(schoolData.data["ACDHSPPCT"] ?? 0.0) -
														(schoolData.data["ACDASIAPCT"] ?? 0.0),
											},
											colors: const [
												Colors.brown,
												Colors.orange,
												Colors.green,
												Colors.blue
											],
										),
									],
								),
							),
							const SizedBox(height: 10),
							Center(
								child: Wrap(
									spacing: 20,
									runSpacing: 20,
									alignment: WrapAlignment.center,
									children: [
										PieChartWidget(
											title: "Professors",
											dataset: {
												"Women": schoolData.data["NONACDWOMENPCT"] ?? 0.0,
												"Men": 1.0 -
														(schoolData.data["NONACDWOMENPCT"] ?? 0.0),
											},
											size: 120,
											colors: const [Colors.pink, Colors.blue],
										),
										PieChartWidget(
											title: "Associate Professors",
											dataset: {
												"Women": schoolData.data["NONACDWOMENPCT"] ?? 0.0,
												"Men": 1.0 -
														(schoolData.data["NONACDWOMENPCT"] ?? 0.0),
											},
											size: 120,
											colors: const [Colors.pink, Colors.blue],
										),
										PieChartWidget(
											title: "Assistant Professors",
											dataset: {
												"Women": schoolData.data["NONACDWOMENPCT"] ?? 0.0,
												"Men": 1.0 -
														(schoolData.data["NONACDWOMENPCT"] ?? 0.0),
											},
											size: 120,
											colors: const [Colors.pink, Colors.blue],
										),
										PieChartWidget(
											title: "Instructors",
											dataset: {
												"Women": schoolData.data["NONACDWOMENPCT"] ?? 0.0,
												"Men": 1.0 -
														(schoolData.data["NONACDWOMENPCT"] ?? 0.0),
											},
											size: 120,
											colors: const [Colors.pink, Colors.blue],
										),
										PieChartWidgetWithLabels(
											title: "Lecturers",
											dataset: {
												"Women": schoolData.data["NONACDWOMENPCT"] ?? 0.0,
												"Men": 1.0 -
														(schoolData.data["NONACDWOMENPCT"] ?? 0.0),
											},
											size: 120, 	
											colors: const [Colors.pink, Colors.blue],
										),
									],
								),
							),
							const SizedBox(height: 10),
							Center(
								child: Wrap(
									spacing: 20,
									runSpacing: 20,
									alignment: WrapAlignment.center,
									children: [
										PieChartWidget(
											title: "Professors",
											dataset: {
												"Black": schoolData.data["ACDBLKPCT"] ?? 0.0,
												"Hispanic": schoolData.data["ACDHSPPCT"] ?? 0.0,
												"Asian": schoolData.data["ACDASIAPCT"] ?? 0.0,
												"White": 1.0 -
														(schoolData.data["ACDBLKPCT"] ?? 0.0) -
														(schoolData.data["ACDHSPPCT"] ?? 0.0) -
														(schoolData.data["ACDASIAPCT"] ?? 0.0),
											},
											size: 120,
											showTitle: false,
											colors: const [
												Colors.brown,
												Colors.orange,
												Colors.green,
												Colors.blue
											],
										),
										PieChartWidget(
											title: "Associate Professors",
											dataset: {
												"Black": schoolData.data["ACDBLKPCT"] ?? 0.0,
												"Hispanic": schoolData.data["ACDHSPPCT"] ?? 0.0,
												"Asian": schoolData.data["ACDASIAPCT"] ?? 0.0,
												"White": 1.0 -
														(schoolData.data["ACDBLKPCT"] ?? 0.0) -
														(schoolData.data["ACDHSPPCT"] ?? 0.0) -
														(schoolData.data["ACDASIAPCT"] ?? 0.0),
											},
											size: 120,
											showTitle: false,
											colors: const [
												Colors.brown,
												Colors.orange,
												Colors.green,
												Colors.blue
											],
										),
										PieChartWidget(
											title: "Assistant Professors",
											dataset: {
												"Black": schoolData.data["ACDBLKPCT"] ?? 0.0,
												"Hispanic": schoolData.data["ACDHSPPCT"] ?? 0.0,
												"Asian": schoolData.data["ACDASIAPCT"] ?? 0.0,
												"White": 1.0 -
														(schoolData.data["ACDBLKPCT"] ?? 0.0) -
														(schoolData.data["ACDHSPPCT"] ?? 0.0) -
														(schoolData.data["ACDASIAPCT"] ?? 0.0),
											},
											size: 120,
											showTitle: false,
											colors: const [
												Colors.brown,
												Colors.orange,
												Colors.green,
												Colors.blue
											],
										),
										PieChartWidget(
											title: "Instructors",
											dataset: {
												"Black": schoolData.data["ACDBLKPCT"] ?? 0.0,
												"Hispanic": schoolData.data["ACDHSPPCT"] ?? 0.0,
												"Asian": schoolData.data["ACDASIAPCT"] ?? 0.0,
												"White": 1.0 -
														(schoolData.data["ACDBLKPCT"] ?? 0.0) -
														(schoolData.data["ACDHSPPCT"] ?? 0.0) -
														(schoolData.data["ACDASIAPCT"] ?? 0.0),
											},
											size: 120,
											showTitle: false,
											colors: const [
												Colors.brown,
												Colors.orange,
												Colors.green,
												Colors.blue
											],
										),
										PieChartWidgetWithLabels(
											title: "Lecturers",
											dataset: {
												"Black": schoolData.data["ACDBLKPCT"] ?? 0.0,
												"Hispanic": schoolData.data["ACDHSPPCT"] ?? 0.0,
												"Asian": schoolData.data["ACDASIAPCT"] ?? 0.0,
												"White": 1.0 -
														(schoolData.data["ACDBLKPCT"] ?? 0.0) -
														(schoolData.data["ACDHSPPCT"] ?? 0.0) -
														(schoolData.data["ACDASIAPCT"] ?? 0.0),
											},
											size: 120,
											showTitle: false,
											colors: const [
												Colors.brown,
												Colors.orange,
												Colors.green,
												Colors.blue
											],
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
								child: Wrap(
									spacing: 20,
									runSpacing: 20,
									alignment: WrapAlignment.center,
									children: [
										PieChartWidgetWithLabels(
											title: "Non-academic Staff Gender Ratio",
											dataset: {
												"Women": schoolData.data["NONACDWOMENPCT"] ?? 0.0,
												"Men": 1.0 -
														(schoolData.data["NONACDWOMENPCT"] ?? 0.0),
											},
											colors: const [Colors.pink, Colors.blue],
										),
										PieChartWidgetWithLabels(
											title: "Non-academic Staff Race Ratio",
											dataset: {
												"Black": schoolData.data["NONACDBLKPCT"] ?? 0.0,
												"Hispanic":
														schoolData.data["NONACDHSPPCT"] ?? 0.0,
												"Asian": schoolData.data["NONACDASIAPCT"] ?? 0.0,
												"White": 1.0 -
														(schoolData.data["NONACDBLKPCT"] ?? 0.0) -
														(schoolData.data["NONACDHSPPCT"] ?? 0.0) -
														(schoolData.data["NONACDASIAPCT"] ?? 0.0),
											},
											colors: const [
												Colors.brown,
												Colors.orange,
												Colors.green,
												Colors.blue
											],
										),
									],
								),
							),
							const SizedBox(height: 30),
							// Separate Financials and Safety Titles
							// const Text(
							//   "Financials",
							//   style:
							//       TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
							//   textAlign: TextAlign.center,
							// ),
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
														"Men": schoolData.data["SALARYPPM"] ?? 0.0,
														"Women": schoolData.data["SALARYPPF"] ?? 0.0,
													},
													colors: const [Colors.blue, Colors.pink],
													yAxisDescription: "Mean Annual Salary (USD)",
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
																schoolData.data["YEARLYHATECRIME1K"]
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
																schoolData.data["YEARLYVAWA1K"]
													},
													colors: const [Colors.orange],
													yAxisDescription: "Cases per Year",
												),
											),
										],
									),
								],
							),

							const SizedBox(height: 30),
						],
					),
				),
			),
    );
  }
}
