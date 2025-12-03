import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gender_fair_2024/models/data_loader.dart';
import 'package:gender_fair_2024/models/filter_data.dart';
import 'package:gender_fair_2024/models/school_data.dart';
import 'package:gender_fair_2024/models/sort_metric.dart';
import 'package:gender_fair_2024/pages/listPane/components/school_data_row.dart';

/// The pane on the list page that has the list of schools as filtered for by the user (or all schools if filters are absent)
class SchoolDataTable extends StatefulWidget {
  static const String schoolListListenerName = "List Panel";
  static const String selectedSchoolsListListenerName = "List Panel";

  static const SchoolDataTable instance =
      SchoolDataTable._privateConstructor();
  const SchoolDataTable._privateConstructor();

  @override
  State<SchoolDataTable> createState() => _SchoolDataTableState();
}

class _SchoolDataTableState extends State<SchoolDataTable> {
  int currentPage = 1;
  int get numSchoolsOnPage => max<int>(
      min<int>(filteredSchools.length - schoolsPerPage * (currentPage - 1),
          schoolsPerPage),
      0);
  int get totalPages => (filteredSchools.length - 1) ~/ schoolsPerPage + 1;

  static final List<SchoolData> allSchoolDatasList =
      List.unmodifiable(DataLoader.instance.allSchoolData.values.toList());
  late List<SchoolData> filteredSchools;

  final int schoolsPerPage = 20;

  @override
  void initState() {
    super.initState();
    FilterData.instance.addSchoolListListener(
        name: SchoolDataTable.schoolListListenerName,
        callback: onSchoolListRequiringUpdate);
    SortMetric.instance.addSortMetricChangeCallback(
        name: SchoolDataTable.schoolListListenerName,
        callback: onSchoolListRequiringUpdate);
    updateFilteredSchools();
  }

  @override
  void dispose() {
    FilterData.instance.removeSchoolListListener(
        name: SchoolDataTable.schoolListListenerName);
    super.dispose();
  }

  List<SchoolData> get schoolOnCurrentPage {
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
        FilterData.instance.filterSchools(List.of(allSchoolDatasList)));
  }

  void onSchoolListRequiringUpdate() {
    setState(() {
			updateFilteredSchools();
			final lastPage = totalPages > 0 ? totalPages : 1;
			if (currentPage > lastPage) {
				currentPage = lastPage;
			}
		});
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
          padding: const EdgeInsets.fromLTRB(20.0,10.0,20.0,10.0),
          child: Row(
            children: List.generate(
              SchoolDataRow.numColumns,
              (index) => Expanded(
                flex: SchoolDataRow.flexValues[index],
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      SchoolDataRow.columnNames[index],
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
                          FilterData.instance.clearFilters();
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
                          child: SchoolDataRow(
                            school: schoolOnCurrentPage[index],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
				
        Padding(
          padding: const EdgeInsets.fromLTRB(20.0,10.0,20.0,10.0),
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
        ),
      ],
    );
  }
}
