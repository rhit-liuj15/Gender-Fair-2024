import 'package:flutter/material.dart';
import 'package:gender_fair_2024/models/data_loader.dart';
import 'package:gender_fair_2024/models/school_score.dart';
import 'package:gender_fair_2024/models/list_page_column_attributes.dart';
import 'package:gender_fair_2024/pages/detailPage/school_detail_page.dart';

class SchoolScoreRow extends StatefulWidget {
	/// A component that makes 1 row for [SchoolListPanel]

  final void Function() onUpdateSelected;
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

  final SchoolScore school;
  const SchoolScoreRow(
      {super.key, required this.school, required this.onUpdateSelected});

  @override
  State<SchoolScoreRow> createState() => _SchoolScoreRowState();
}

class _SchoolScoreRowState extends State<SchoolScoreRow> {
  static TextStyle totalScoreStyle =
      const TextStyle(fontSize: 26, fontWeight: FontWeight.bold);
	
  @override
  Widget build(BuildContext context) {
    final List<Widget> widgets = ListPageColumnAttributes.values.map((item) {
      switch (item) {
        case ListPageColumnAttributes.instName:
          return InkWell(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: widget.school.schoolName,
                    style: const TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  const TextSpan(text: "  "),
                  TextSpan(
                    text: getSchoolTypeShort(widget.school.schoolType),
                    style: TextStyle(
                      fontSize: 14,
                      color: getSchoolTypeColor(widget.school.schoolType),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1600),
                      child: SchoolDetailPage(uid: widget.school.uid),
                    ),
                  );
                },
              );
            },
          );
        case ListPageColumnAttributes.populationTotal:
          return Text("${DataLoader.instance.allSchoolData[widget.school.uid]!.getInt("ENROLLTOT")}",
              textAlign: TextAlign.center, style: totalScoreStyle);
        default:
        	return Text("Unknown item '${item.name}'!"); // Consider this a return nothing
      }
    }).toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0,10.0,20.0,10.0),
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

String getSchoolTypeShort(String type) {
  switch (type) {
    case '1':
      return '• Public';
    case '3':
      return '• Private W/out rel';
    case '4':
      return '• Private W/ Rel';
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
