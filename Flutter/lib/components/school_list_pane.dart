import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gender_fair_2024/components/school_score_row.dart';
import 'package:gender_fair_2024/models/school_score.dart';
import 'package:gender_fair_2024/models/list_page_column_attributes.dart';

class SchoolListPane extends StatefulWidget {
	/// The pane on the list page that has the list of schools as filtered for by the user (or all schools if filters are absent)
  
	final ValueChanged<ListPageColumnAttributes> updateSortingMetricCallback;
  final Function() invertSortCallback;
  final ListPageColumnAttributes sortingMetric;
  final Function() updateSortCallback;
  final List<SchoolScore> schoolsFilteredFor;
  final int schoolsPerPage;
  final Function() onUpdateSelected;

  const SchoolListPane({
    super.key,
    required this.updateSortingMetricCallback,
    required this.invertSortCallback,
    required this.sortingMetric,
    required this.updateSortCallback,
    required this.schoolsFilteredFor,
    required this.schoolsPerPage,
    required this.onUpdateSelected,
  });

  @override
  State<SchoolListPane> createState() => _SchoolListPaneState();
}

class _SchoolListPaneState extends State<SchoolListPane> {
  int currentPage = 1;
  int get numSchoolsOnPage => max<int>(
      min<int>(
          widget.schoolsFilteredFor.length -
              widget.schoolsPerPage * (currentPage - 1),
          widget.schoolsPerPage),
      0);
  int get totalPages =>
      (widget.schoolsFilteredFor.length - 1) ~/ widget.schoolsPerPage + 1;
  // ((widget.schoolsFilteredFor.length + widget.schoolsPerPage - 1) / widget.schoolsPerPage)
  // 		.ceil();

  List<SchoolScore> get schoolOnCurrentPage {
    if (widget.schoolsFilteredFor.isEmpty) {
      return [];
    }

    currentPage = currentPage.clamp(1, totalPages);

    final startIndex = (currentPage - 1) * widget.schoolsPerPage;
    final endIndex = (startIndex + widget.schoolsPerPage)
        .clamp(0, widget.schoolsFilteredFor.length);

    return startIndex < widget.schoolsFilteredFor.length
        ? widget.schoolsFilteredFor.sublist(startIndex, endIndex)
        : [];
  }

  void onPageChange(int newPage) {
    setState(() {
      currentPage = newPage;
    });
  }

  @override
  void didUpdateWidget(covariant SchoolListPane oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newTotalPages =
        (widget.schoolsFilteredFor.length - 1) ~/ widget.schoolsPerPage + 1;
    if (currentPage > newTotalPages) {
      setState(() {
        currentPage = newTotalPages;
      });
    }
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
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                const Text(
                  "Sort by:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8.0),
                DropdownButton<ListPageColumnAttributes>(
                  value: widget.sortingMetric,
                  onChanged: (ListPageColumnAttributes? newValue) {
                    if (newValue != null) {
                      widget.updateSortingMetricCallback(newValue);
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
									child: Text("Invert Sort"),
									onPressed: widget.invertSortCallback,
								)
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
                              onUpdateSelected: widget.onUpdateSelected,
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
