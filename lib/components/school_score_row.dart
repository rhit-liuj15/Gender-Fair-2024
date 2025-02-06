import 'package:flutter/material.dart';
import 'package:gender_fair_2024/models/school_score.dart';
import 'package:gender_fair_2024/models/school_score_column_attributes.dart';
import 'package:gender_fair_2024/pages/school_detail_page.dart';

class SchoolScoreRow extends StatefulWidget {
  final void Function(int) onUpdateSelectedCount; 
  static List<int> flexValues = SchoolScoreColumnAttributes.flexValues;
  static List<String> columnNames = SchoolScoreColumnAttributes.colNames;
  static Map<SchoolScoreColumnAttributes,bool> defaultSortOrder = SchoolScoreColumnAttributes.sortOrder;

  static int get numColumns {
    if (flexValues.length != columnNames.length) {
      throw StateError("flexValues and columnNames must have the same length");
    }
    return flexValues.length;
  }
  static Set<int> selectedSchools = <int>{};
  final SchoolScore school;
  const SchoolScoreRow({super.key, required this.school, required this.onUpdateSelectedCount});

  @override
  State<SchoolScoreRow> createState() => _SchoolScoreRowState();
}

class _SchoolScoreRowState extends State<SchoolScoreRow> {

	static TextStyle subscoreStyle = const TextStyle(fontSize: 26, fontWeight: FontWeight.bold);
	static TextStyle totalScoreStyle = const TextStyle(fontSize: 26, fontWeight: FontWeight.bold);
	static TextStyle rankingStyle = const TextStyle(
		fontSize: 26,
		fontWeight: FontWeight.bold,
		color: Color.fromARGB(255, 221, 174, 47)
	);
	
  @override
  Widget build(BuildContext context) {
		
    final List<Widget> widgets = SchoolScoreColumnAttributes.values.map((item) {
			switch(item) {
				case SchoolScoreColumnAttributes.addToList:
					return Checkbox(
						value: SchoolScoreRow.selectedSchools.contains(widget.school.uid),
						onChanged: (bool? newValue) {
							setState(() {
								if (newValue!) {
									SchoolScoreRow.selectedSchools.add(widget.school.uid);
								} else {
									SchoolScoreRow.selectedSchools.remove(widget.school.uid);
								}
								widget.onUpdateSelectedCount(SchoolScoreRow.selectedSchools.length); 
							});
						},
					);
				case SchoolScoreColumnAttributes.instName:
					return InkWell(
						child: Text(widget.school.schoolName, style: const TextStyle(fontSize: 18)),
						onTap: () {
							showDialog(
								context: context,
								builder: (BuildContext context) {
									return Dialog(
										child: SchoolDetailPage(uid: widget.school.uid),
									);
								},
							);
						},
					);
				case SchoolScoreColumnAttributes.leadership:
				case SchoolScoreColumnAttributes.polnpay:
				case SchoolScoreColumnAttributes.safety:
				case SchoolScoreColumnAttributes.diversity:
					return Text("${widget.school.subscores[item]}", 
						textAlign: TextAlign.center,
						style: subscoreStyle
					);
				case SchoolScoreColumnAttributes.ranking:
					return Text("#${widget.school.rank}", 
						textAlign: TextAlign.center,
						style: rankingStyle
					);
				case SchoolScoreColumnAttributes.total:
					return Text("${widget.school.score}", 
						textAlign: TextAlign.center,
						style: totalScoreStyle
					);
				default:
					return Text("Unknown item '${item.name}'!"); // Consider this a return nothing
			}
		}).toList();

    // final List<Widget> widgets2 = [
		// 	Checkbox(
		// 		value: SchoolScoreRow.selectedSchools.contains(widget.school.uid),
		// 		onChanged: (bool? newValue) {
		// 			setState(() {
		// 				if (newValue!) {
		// 					SchoolScoreRow.selectedSchools.add(widget.school.uid);
		// 				} else {
		// 					SchoolScoreRow.selectedSchools.remove(widget.school.uid);
		// 				}
		// 				widget.onUpdateSelectedCount(SchoolScoreRow.selectedSchools.length); 
		// 			});
		// 		},
		// 	),

		// 	InkWell(
		// 		child: Text(widget.school.schoolName, style: const TextStyle(fontSize: 18)),
		// 		onTap: () {
		// 			showDialog(
		// 				context: context,
		// 				builder: (BuildContext context) {
		// 					return Dialog(
		// 						child: SchoolDetailPage(uid: widget.school.uid),
		// 					);
		// 				},
		// 			);
		// 		},
		// 	),
		// 	Text("#${widget.school.rank}", textAlign: TextAlign.center, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 221, 174, 47))),
		// 	Text("${widget.school.subscores[0]}", textAlign: TextAlign.center, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
		// 	Text("${widget.school.subscores[1]}", textAlign: TextAlign.center, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
		// 	Text("${widget.school.subscores[2]}", textAlign: TextAlign.center, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
		// 	Text("${widget.school.subscores[3]}", textAlign: TextAlign.center, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
		// 	Text("${widget.school.score}", textAlign: TextAlign.center, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.green)),
		// ];

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: List.generate(SchoolScoreRow.numColumns, (index) {
          return Expanded(
            flex: SchoolScoreRow.flexValues[index],
            child: widgets[index],
          );
        }),
      ),
    );
  }
}

class ColumnContentSpec {
  final int flex;
  final Widget content;

  ColumnContentSpec({
    required this.flex,
    required this.content,
  });
}
