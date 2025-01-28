import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gender_fair_2024/models/data_loader.dart';
import 'package:gender_fair_2024/models/school_data.dart';


class SchoolDetailPage extends StatefulWidget {
  final int uid;

  const SchoolDetailPage({
    super.key,
    required this.uid,
  });

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


  // Asynchronously load data from the singleton instance
  Future<void> loadData() async {
    await DataLoader.instance.requestSchoolData({widget.uid});
    setState(() {
    	schoolData = DataLoader.instance.allSchools[widget.uid]!;
    });
  }

  Widget buildPieChart(List<double> values, List<Color> colors, List<String> titles) {
  int touchedIndex = -1;

  return StatefulBuilder(
    builder: (context, setState) {
      return PieChart(
        PieChartData(
          pieTouchData: PieTouchData(
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          sections: List.generate(values.length, (index) {
            final isTouched = index == touchedIndex;
            final fontSize = isTouched ? 25.0 : 16.0;
            final radius = isTouched ? 70.0 : 60.0;

            return PieChartSectionData(
              color: colors[index],
              value: values[index],
              title: titles[index],
              titleStyle: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
              radius: radius,
            );
          }),
          centerSpaceRadius: 40,
          borderData: FlBorderData(show: false),
        ),
      );
    },
  );
}


Widget buildHorizontalBarGraph(List<double> values, List<String> titles, Color barColor) {
  return BarChart(
    BarChartData(
      rotationQuarterTurns: 1, // This sets the chart to horizontal
      barGroups: List.generate(values.length, (index) {
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: values[index], 
              color: barColor,
              width: 20,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        );
      }),
      barTouchData: BarTouchData(enabled: false),
      gridData: FlGridData(show: false), // No grid lines
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 80,
            getTitlesWidget: (value, meta) {
              int index = value.toInt();
              if (index >= 0 && index < titles.length) {
                return Text(titles[index]); 
              }
              return const Text('');
            },
          ),
        ),
        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false), // No border
      alignment: BarChartAlignment.center,
      maxY: values.reduce((a, b) => a > b ? a : b) + 5,
    ),
  );
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text(schoolData.schoolName)),
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
					Text(schoolData.toString()),
          const SizedBox(height: 20),
          Text(
            "Diversity Distribution",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: buildPieChart(
                      [25.0, 35.0, 15.0, 25.0],
                      [Colors.red, Colors.green, Colors.blue, Colors.orange],
                      ["A", "B", "C", "D"],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Chart 1 Label",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(width: 40),
              Column(
                children: [
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: buildPieChart(
                      [20.0, 40.0, 40.0],
                      [Colors.orange, Colors.purple, Colors.yellow, Colors.cyan],
                      ["E", "F", "G", "H"],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Chart 2 Label",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              const SizedBox(width: 40),
              Column(
                children: [
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: buildPieChart(
                      [33.0, 33.0, 34.0],
                      [Colors.pink, Colors.cyan, Colors.indigo],
                      ["X", "Y", "Z"],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Chart 3 Label",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          Text(
            "Subscore Breakdown (Vertical)",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: buildHorizontalBarGraph
            (
              [10.0, 20.0, 15.0, 25.0],
              ["1", "2", "3", "4"],
              Colors.blue,
            ),
          ),
        ],
      ),
    ),
  );
}





}
