import 'package:flutter/material.dart';
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

	late SchoolData schoolData;

  @override
  void initState() {
    super.initState();
		DataLoader.instance.requestSchoolData(widget.uid);
		schoolData = DataLoader.instance.allSchools[widget.uid]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(schoolData.schoolName),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
				child: Padding(
					padding: const EdgeInsets.all(40.0),
					child: Text("Name of school ${schoolData.uid} is ${schoolData.schoolName}, its data is ${schoolData.categories.keys.toString()}"),
        )
      ),
    );
  }
}
