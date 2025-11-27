import 'package:flutter/material.dart';
import 'package:gender_fair_2024/models/list_page_column_attributes.dart';
import 'package:gender_fair_2024/models/school_data.dart';
import 'package:go_router/go_router.dart';

class SchoolDataRow extends StatefulWidget {
	/// A component that makes 1 row for [SchoolListPanel]

  static List<int> flexValues = ListPageColumnAttributes.flexValues;
  static List<String> columnNames = ListPageColumnAttributes.colNames;

  static Map<ListPageColumnAttributes, bool> defaultSortOrder =
      ListPageColumnAttributes.sortOrder;

  static int get numColumns {
    if (flexValues.length != columnNames.length) {
      throw StateError("flexValues and columnNames must have the same length");
    }
    return flexValues.length;
  }

  final SchoolData school;
  const SchoolDataRow(
      {super.key, required this.school});

  @override
  State<SchoolDataRow> createState() => _SchoolDataRowState();
}

class _SchoolDataRowState extends State<SchoolDataRow> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = ListPageColumnAttributes.values.map((item) {
      switch (item) {
        case ListPageColumnAttributes.instName:
          return RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: widget.school.getName(),
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
                const TextSpan(text: "  "),
                TextSpan(
                  text: getSchoolTypeShort(widget.school.getString("INSTFUNDINGTYPE")),
                  style: TextStyle(
                    fontSize: 14,
                    color: getSchoolTypeColor(widget.school.getString("INSTFUNDINGTYPE")),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          );
        // case ListPageColumnAttributes.populationTotal:
				// 	return Text(
				// 		widget.school.getString("ENROLLTOT"),
				// 		textAlign: TextAlign.center,
				// 		style: const TextStyle(
				// 			fontSize: 18
				// 		),
				// 	);
        // case ListPageColumnAttributes.state:
				// 	return Text(
				// 		widget.school.getString("STATE"),
				// 		textAlign: TextAlign.center,
				// 		style: const TextStyle(
				// 			fontSize: 18
				// 		),
				// 	);
      }
    }).toList();

    return InkWell(
			child: Padding(
				padding: const EdgeInsets.fromLTRB(20.0,10.0,20.0,10.0),
				child: Row(
					children: List.generate(SchoolDataRow.numColumns, (index) {
						return Expanded(
							flex: SchoolDataRow.flexValues[index],
							child: widgets[index],
						);
					}),
				),
			),
			onTap: () => context.go(Uri(path:'/details/${widget.school.getUID()}').toString()),
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

String getSchoolTypeShort(String type) {
  switch (type) {
    case '1':
      return '• Public';
    case '3':
      return '• Private';
    case '4':
      return '• Private, Religious';
    default:
      return '';
  }
}

Color getSchoolTypeColor(String type) {
  switch (type) {
    case '1':
      return Colors.blue;
    case '3':
      return Colors.deepPurple;
    case '4':
      return Colors.orange;
    default:
      return Colors.grey;
  }
}
