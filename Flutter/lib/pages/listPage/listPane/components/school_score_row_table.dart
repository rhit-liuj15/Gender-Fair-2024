import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gender_fair_2024/models/data_loader.dart';
import 'package:gender_fair_2024/models/filter_data.dart';
import 'package:gender_fair_2024/models/selected_schools.dart';
import 'package:gender_fair_2024/models/sort_metric.dart';
import 'package:gender_fair_2024/pages/listPage/listPane/components/school_score_row.dart';
import 'package:gender_fair_2024/models/school_score.dart';

/// The pane on the list page that has the list of schools as filtered for by the user (or all schools if filters are absent)
class SchoolScoreRowTable extends StatefulWidget {
  static const String schoolListListenerName = "List Panel";
  static const String selectedSchoolsListListenerName = "List Panel";

  static const SchoolScoreRowTable instance =
      SchoolScoreRowTable._privateConstructor();
  const SchoolScoreRowTable._privateConstructor();

  @override
  State<SchoolScoreRowTable> createState() => _SchoolScoreRowTableState();
}

class _SchoolScoreRowTableState extends State<SchoolScoreRowTable> {
  int currentPage = 1;
  int get numSchoolsOnPage => max<int>(
      min<int>(filteredSchools.length - schoolsPerPage * (currentPage - 1),
          schoolsPerPage),
      0);
  int get totalPages => (filteredSchools.length - 1) ~/ schoolsPerPage + 1;

  static final List<SchoolScore> allSchoolScoresList =
      List.unmodifiable(DataLoader.instance.allSchoolScores.values.toList());
  late List<SchoolScore> filteredSchools;

  final int schoolsPerPage = 20;

  @override
  void initState() {
    super.initState();
    FilterData.instance.addSchoolListListener(
        name: SchoolScoreRowTable.schoolListListenerName,
        callback: onSchoolListRequiringUpdate);
    SelectedSchools.instance.addSelectedSchoolsListListener(
        name: SchoolScoreRowTable.schoolListListenerName,
        callback: onSchoolListRequiringUpdate);
    SortMetric.instance.addSortMetricChangeCallback(
        name: SchoolScoreRowTable.schoolListListenerName,
        callback: onSchoolListRequiringUpdate);
    updateFilteredSchools();
  }

  @override
  void dispose() {
    FilterData.instance.removeSchoolListListener(
        name: SchoolScoreRowTable.schoolListListenerName);
    super.dispose();
  }

  List<SchoolScore> get schoolOnCurrentPage {
    if (filteredSchools.isEmpty) {
      return [];
    }

    currentPage = currentPage.clamp(1, totalPages);

    final startIndex = (currentPage - 1) * schoolsPerPage;
    final endIndex =
        (startIndex + schoolsPerPage).clamp(0, filteredSchools.length);

    return startIndex < filteredSchools.length
        ? filteredSchools.sublist(startIndex, endIndex)
        : [];
  }

  void updateFilteredSchools() {
    filteredSchools = SortMetric.instance.sortSchools(
        FilterData.instance.filterSchools(List.of(allSchoolScoresList)));
  }

  void onSchoolListRequiringUpdate() {
    print("Update required");
    updateFilteredSchools();
    final lastPage = totalPages > 0 ? totalPages : 1;
    if (currentPage > lastPage) {
      currentPage = lastPage;
    }
    setState(() {});
  }

  void onPageChange(int newPage) {
    setState(() {
      currentPage = newPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
          child: Row(
            children: List.generate(
              SchoolScoreRow.numColumns,
              (index) => Expanded(
                flex: SchoolScoreRow.flexValues[index],
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      SchoolScoreRow.columnNames[index],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: filteredSchools.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Your selection matched no schools",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          FilterData.instance.resetFilters();
                        },
                        child: const Text("Reset Filters"),
                      ),
                      if (FilterData.instance.showOnlySelected)
                        const Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: Text(
                            "You may also deselect [Show Only Selected Schools] at the bottom of the filter panel.",
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: ListView.builder(
                    itemCount: numSchoolsOnPage,
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromARGB(255, 185, 182, 174),
                              width: 1.0,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: SchoolScoreRow(
                            school: schoolOnCurrentPage[index],
                            onUpdateSelected: SelectedSchools
                                .instance.applySelectedSchoolChange,
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: currentPage > 1
                  ? () {
                      onPageChange(1);
                    }
                  : null,
              child: const Text("First"),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: currentPage > 1
                  ? () => onPageChange((currentPage - 1).clamp(1, totalPages))
                  : null,
              child: const Text("Previous"),
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: 50,
              child: TextField(
                controller: TextEditingController(text: currentPage.toString()),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  int? newPage = int.tryParse(value);
                  if (newPage != null) {
                    newPage = newPage.clamp(1, totalPages);
                    onPageChange(newPage);
                  }
                },
              ),
            ),
            Text(
              " of $totalPages",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: currentPage < totalPages
                  ? () => onPageChange((currentPage + 1).clamp(1, totalPages))
                  : null,
              child: const Text("Next"),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: currentPage < totalPages
                  ? () {
                      onPageChange(totalPages);
                    }
                  : null,
              child: const Text("Last"),
            ),
          ],
        ),
      ],
    );
  }
}
