import 'package:flutter/material.dart';
import 'package:gender_fair_2024/models/school_score.dart';
import 'package:gender_fair_2024/pages/school_detail_page.dart';

class SchoolScoreRow extends StatefulWidget {
  static List<int> flexValues = List.unmodifiable([2, 7, 2, 2, 2, 2, 2]);
  static List<String> columnNames = List.unmodifiable([
    "Add To List",
    "Institution Name",
    "Safety",
    "Employee Policy",
    "Diversity",
    "I Made This Up",
    "Total",
  ]);
  static List<bool> defaultSortOrder = List.unmodifiable([
    true,
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

  static Set<int> selectedSchools = <int>{};

  final SchoolScore school;

  const SchoolScoreRow({super.key, required this.school});

  @override
  State<SchoolScoreRow> createState() => _SchoolScoreRowState();
}

class _SchoolScoreRowState extends State<SchoolScoreRow> {
  @override
  Widget build(BuildContext context) {
    // Change this
    final List<Widget> widgets = [
      Checkbox(
        value: SchoolScoreRow.selectedSchools.contains(widget.school.uid),
        onChanged: (bool? newValue) {
          print(
              "School ${widget.school.uid} ${widget.school.schoolName} has been ${newValue! ? "" : "de"}selected");
          setState(() {
            if (newValue) {
              SchoolScoreRow.selectedSchools.add(widget.school.uid);
            } else {
              SchoolScoreRow.selectedSchools.remove(widget.school.uid);
            }
          });
        },
      ),
      InkWell(
        child: Text(widget.school.schoolName,
            style: const TextStyle(fontSize: 18)),
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
      ),
      Text("${widget.school.subscores[0]}",
          textAlign: TextAlign.center, style: const TextStyle(fontSize: 26)),
      Text("${widget.school.subscores[1]}",
          textAlign: TextAlign.center, style: const TextStyle(fontSize: 26)),
      Text("${widget.school.subscores[2]}",
          textAlign: TextAlign.center, style: const TextStyle(fontSize: 26)),
      Text("${widget.school.subscores[3]}",
          textAlign: TextAlign.center, style: const TextStyle(fontSize: 26)),
      Text(
        "${widget.school.score}",
        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
        textAlign: TextAlign.center,
      ),
    ];

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
