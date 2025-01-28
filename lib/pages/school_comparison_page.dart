import 'package:flutter/material.dart';
import 'package:gender_fair_2024/components/school_score_row.dart';
import 'package:gender_fair_2024/models/data_loader.dart';
import 'package:gender_fair_2024/models/school_data.dart';

class SchoolComparisonPage extends StatefulWidget {

  const SchoolComparisonPage({
		super.key,
	});

  @override
  State<SchoolComparisonPage> createState() => _SchoolComparisonPageState();
}

class _SchoolComparisonPageState extends State<SchoolComparisonPage> {

  late Set<SchoolData> schoolDatas = {};

  @override
  void initState() {
    super.initState();
		loadData();
  }

  // Asynchronously load data from the singleton instance
  Future<void> loadData() async {
    await DataLoader.instance.requestSchoolData(SchoolScoreRow.selectedSchools);
    setState(() {
    	schoolDatas = SchoolScoreRow.selectedSchools.map((key) => DataLoader.instance.allSchools[key]!).toSet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comparing ${SchoolScoreRow.selectedSchools.length} Schools"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
				child: Padding(
					padding: const EdgeInsets.all(40.0),
					child: Text("Comparing Schools ${schoolDatas.toString()}"),
        )
      ),
    );
  }
}
