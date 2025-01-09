import 'package:flutter/material.dart';
import 'package:gender_fair_2024/components/school_score_row.dart';

class SchoolComparisonPage extends StatefulWidget {

  const SchoolComparisonPage({
		super.key,
	});

  @override
  State<SchoolComparisonPage> createState() => _SchoolComparisonPageState();
}

class _SchoolComparisonPageState extends State<SchoolComparisonPage> {


  @override
  void initState() {
    super.initState();
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
					child: Text("Comparing Schools ${SchoolScoreRow.selectedSchools.toString()}"),
        )
      ),
    );
  }
}
