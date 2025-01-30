import 'package:flutter/material.dart';
import 'package:gender_fair_2024/components/school_score_row.dart';
import 'package:gender_fair_2024/models/school_score.dart';

class SchoolListPane extends StatelessWidget {
  final int sortingBy;
  final VoidCallback onSortByMethod;
  final ValueChanged<int> onUpdateSortingBy;
  final Function(int) onSortData;
  final List<SchoolScore> schoolsFilteredFor;
  final List<SchoolScore> paginatedSchools;
  final int currentPage;
  final int schoolsPerPage;
  final ValueChanged<int> onPageChange;

  const SchoolListPane({
    Key? key,
    required this.sortingBy,
    required this.onSortByMethod,
    required this.onUpdateSortingBy,
    required this.onSortData,
    required this.schoolsFilteredFor,
    required this.paginatedSchools,
    required this.currentPage,
    required this.schoolsPerPage,
    required this.onPageChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalPages =
        ((schoolsFilteredFor.length + schoolsPerPage - 1) / schoolsPerPage).ceil();

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 52, 52, 52).withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          // Sorting row
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                const Text(
                  "Sort by:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8.0),
                DropdownButton<int>(
                  value: sortingBy,
                  onChanged: (int? newValue) {
                    if (newValue != null) {
                      onUpdateSortingBy(newValue);
                    }
                  },
                  items: List.generate(
                    SchoolScoreRow.columnNames.length,
                    (index) {
                      if (SchoolScoreRow.columnNames[index] == "Add To List") {
                        return null;
                      }
                      return DropdownMenuItem<int>(
                        value: index,
                        child: Text(
                          SchoolScoreRow.columnNames[index],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ).whereType<DropdownMenuItem<int>>().toList(),
                  isExpanded: false,
                  hint: const Text("Select column"),
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
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      SchoolScoreRow.columnNames[index],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(210, 229, 229, 228)
                          .withOpacity(0.9),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: const Color.fromARGB(255, 145, 148, 153),
                        width: 2.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 36, 34, 34)
                              .withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: paginatedSchools.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: const Color.fromARGB(255, 185, 182, 174),
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: SchoolScoreRow(
                                school: paginatedSchools[index],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                // Pagination controls
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: currentPage > 1
                            ? () => onPageChange(currentPage - 1)
                            : null,
                        child: const Text("Previous"),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        "Page $currentPage of $totalPages",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: currentPage < totalPages
                            ? () => onPageChange(currentPage + 1)
                            : null,
                        child: const Text("Next"),
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
