import 'package:flutter/material.dart';
import 'package:gender_fair_2024/components/sortable_table.dart';

class AllSchoolsPage extends StatefulWidget {
  const AllSchoolsPage({super.key});

  @override
  State<AllSchoolsPage> createState() => _AllSchoolsPageState();
}

class _AllSchoolsPageState extends State<AllSchoolsPage> {
  // late final Map<int, SchoolScore> allSchools = SchoolScoreLoader.instance.allScores;
  // late final List<bool> selected =
  //     List<bool>.generate(allSchools.length, (int index) => false);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("School Ranking List"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const Center(
				child: Padding(
					padding: EdgeInsets.all(40.0),
					child: SortableTable(),
        )
      ),
    );
  }
}
