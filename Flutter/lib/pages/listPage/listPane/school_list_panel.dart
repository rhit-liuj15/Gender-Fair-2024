import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gender_fair_2024/models/data_loader.dart';
import 'package:gender_fair_2024/models/filter_data.dart';
import 'package:gender_fair_2024/models/selected_schools.dart';
import 'package:gender_fair_2024/pages/listPage/filterPane/filters/school_name_filter.dart';
import 'package:gender_fair_2024/pages/listPage/listPane/school_score_row.dart';
import 'package:gender_fair_2024/models/school_score.dart';
import 'package:gender_fair_2024/models/list_page_column_attributes.dart';

/// The pane on the list page that has the list of schools as filtered for by the user (or all schools if filters are absent)
class SchoolListPanel extends StatefulWidget {
  static const SchoolListPanel instance = SchoolListPanel._privateConstructor();

  static const String schoolListListenerName = "List Panel";
  static const String selectedSchoolsListListenerName = "List Panel";

  const SchoolListPanel._privateConstructor();

  @override
  State<SchoolListPanel> createState() => _SchoolListPanelState();
}

class _SchoolListPanelState extends State<SchoolListPanel> {
  int currentPage = 1;
  int get numSchoolsOnPage => max<int>(
      min<int>(schoolsFilteredFor.length - schoolsPerPage * (currentPage - 1),
          schoolsPerPage),
      0);
  int get totalPages => (schoolsFilteredFor.length - 1) ~/ schoolsPerPage + 1;

  static final List<SchoolScore> scoreList =
      DataLoader.instance.allSchoolScores.values.toList();
  static List<SchoolScore> schoolsFilteredFor = scoreList;

  ListPageColumnAttributes sortingBy = ListPageColumnAttributes.total;
  bool sortDescending = ListPageColumnAttributes.total.sortDescending;

  final int schoolsPerPage = 20;

  ListPageColumnAttributes sortingMetric = ListPageColumnAttributes.total;

  @override
  void initState() {
    super.initState();
    FilterData.instance.addSchoolListListener(
        name: SchoolListPanel.schoolListListenerName, callback: onSchoolListChange);
    SelectedSchools.instance.addSelectedSchoolsListListener(
        name: SchoolListPanel.schoolListListenerName, callback: onSchoolListChange);
    sortData();
  }

  void updateSortMetric(ListPageColumnAttributes column) {
    if (sortingBy != column) {
      sortingBy = column;
      sortDescending = SchoolScoreRow.defaultSortOrder[column]!;
      updateShownSchools();
    }
    // Otherwise, the same element has been selected. The website won't need to respond in that case.
  }

  void invertSort() {
    sortDescending = !sortDescending;
    updateShownSchools();
  }

  void updateShownSchools() {
    schoolsFilteredFor = FilterData.instance.filterSchools(scoreList);
    sortData();
  }

  void sortData() {
    Comparator<SchoolScore> comparator;
    switch (sortingBy) {
      case ListPageColumnAttributes.instName:
        comparator = (a, b) => a.schoolName.compareTo(b.schoolName);
        break;

      case ListPageColumnAttributes.ranking:
      case ListPageColumnAttributes.total:
        comparator = (a, b) => a.score.compareTo(b.score);
        break;

      case ListPageColumnAttributes.leadership:
      case ListPageColumnAttributes.polnpay:
      case ListPageColumnAttributes.safety:
      case ListPageColumnAttributes.diversity:
        comparator = (a, b) => a.subscores[ListPageColumnAttributes
                .listPageToSchoolScoreMapping[sortingBy]]!
            .compareTo(b.subscores[ListPageColumnAttributes
                .listPageToSchoolScoreMapping[sortingBy]]!);
        break;
      default:
        if (sortingBy.sortable) {
          comparator = (a, b) => 0; // No sorting needed
        } else {
          throw ("Sort column '$sortingBy' is not supported");
        }
    }
    schoolsFilteredFor.sort((a, b) {
      int compareResult = comparator(a, b);
      if (compareResult == 0) {
        compareResult = a.score.compareTo(b.score);
      }
      return sortDescending ? -compareResult : compareResult;
    });
  }

  @override
  void dispose() {
    FilterData.instance
        .removeSchoolListListener(name: SchoolListPanel.schoolListListenerName);
    super.dispose();
  }

  List<SchoolScore> get schoolOnCurrentPage {
    if (schoolsFilteredFor.isEmpty) {
      return [];
    }

    currentPage = currentPage.clamp(1, totalPages);

    final startIndex = (currentPage - 1) * schoolsPerPage;
    final endIndex =
        (startIndex + schoolsPerPage).clamp(0, schoolsFilteredFor.length);

    return startIndex < schoolsFilteredFor.length
        ? schoolsFilteredFor.sublist(startIndex, endIndex)
        : [];
  }

  void onSchoolListChange() {
    setState(() {
      updateShownSchools();
    });
  }

  void onPageChange(int newPage) {
    setState(() {
      currentPage = newPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        border: Border.all(color: const Color(0xFFFF4713), width: 2),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                const Text(
                  "Sort by:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8.0),
                DropdownButton<ListPageColumnAttributes>(
                  value: sortingMetric,
                  onChanged: (ListPageColumnAttributes? newValue) {
                    if (newValue != null) {
                      updateSortMetric(newValue);
                    }
                  },
                  // Generate dropdown entry for all sortable columns
                  items: ListPageColumnAttributes.values
                      .where((item) => item.sortable)
                      .map((item) => DropdownMenuItem<ListPageColumnAttributes>(
                            value: item,
                            child: Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ))
                      .toList(),
                  isExpanded: false,
                  hint: const Text("Select column"),
                ),
                const SizedBox(width: 8.0),
                TextButton(
                  onPressed: invertSort,
                  child: const Text("Invert Sort"),
                ),
                const Expanded(child: SizedBox()),
                const SizedBox(
                  width: 500,
                  child: SchoolNameFilter.instance,
                ),
              ],
            ),
          ),

          // Column headers
          Row(
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

          // List & Pagination
          Expanded(
            child: Column(
              children: [
                // The scrolling list of schools
                Expanded(
                  child: ClipRRect(
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

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
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
                            ? () => onPageChange(
                                (currentPage - 1).clamp(1, totalPages))
                            : null,
                        child: const Text("Previous"),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 50,
                        child: TextField(
                          controller: TextEditingController(
                              text: currentPage.toString()),
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
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: currentPage < totalPages
                            ? () => onPageChange(
                                (currentPage + 1).clamp(1, totalPages))
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
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
