import 'package:flutter/material.dart';
import 'package:gender_fair_2024/models/school_score.dart';

class SchoolScoreRow extends StatelessWidget {
  static List<int> flexValues = List.unmodifiable([7,2,2,2,2,3]);
  static List<String> columnNames = List.unmodifiable([
		"Institution Name", 
		"Safety", 
		"Employee Policy", 
		"Diversity", 
		"I Made This Up", 
		"Add To List"
	]);
  static List<bool> defaultSortOrder = List.unmodifiable([
		true,
		false,
		false,
		false,
		false,
		false,
	]);
	static int get numColumns {
		if (flexValues.length != columnNames.length) {
			throw StateError("flexValues and columnNames must have the same length");
		}
		return flexValues.length;
	}

  static TextStyle textStyle = const TextStyle(fontSize: 16.0);

  final SchoolScore school;
	
  const SchoolScoreRow({
		super.key,
		required this.school
	});

  @override
  Widget build(BuildContext context) {
		
		// Change this 
    final List<Widget> widgets = [
      Text(school.schoolName),
      Text("${school.subscores[0]}", textAlign: TextAlign.center,),
      Text("${school.subscores[1]}", textAlign: TextAlign.center,),
      Text("${school.subscores[2]}", textAlign: TextAlign.center,),
      Text("${school.subscores[3]}", textAlign: TextAlign.center,),
      Text(
				"${school.score}",
				style: const TextStyle(fontWeight: FontWeight.bold),
				textAlign: TextAlign.center,
			),
			Checkbox(
				value: false,
				onChanged: (bool? newValue) {
					print("School ${school.uid} ${school.schoolName} has been ${newValue!?"":"de"}selected");
				},
			)
    ];

    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: List.generate(
					numColumns,
					(index) {
						return Expanded(
							flex: flexValues[index],
							child: widgets[index],
						);
					}
				),
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