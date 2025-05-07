import 'package:flutter/material.dart';
import 'package:gender_fair_2024/components/filter_block_with_header.dart';
import 'package:gender_fair_2024/components/major_level_filter.dart';
import 'package:gender_fair_2024/components/state_filter.dart';
import 'package:gender_fair_2024/models/metadata.dart';
import 'package:gender_fair_2024/models/school_score.dart';

class FilterAndComparePane extends StatefulWidget {
  /// The pane on the list page which contains the filters
  ///
  /// Takes in a reference to the list of [filterFunctions] and a callback for [updateShownSchools] to update the filters

  final void Function({
		required List<SchoolScore> Function(List<SchoolScore>) filterFunction,
		required String name,
		required dynamic Function() resetCallback,
	}) updateFilterCallback;
	final Function({required String name}) removeFilterCallback;
  final Function() clearAllCallback;
  final Function() clearSchoolSelection;
  final int selectedSchoolsCount;

  const FilterAndComparePane({
    super.key,
		required this.updateFilterCallback,
    required this.removeFilterCallback,
    required this.clearAllCallback,
    required this.clearSchoolSelection,
    required this.selectedSchoolsCount, 
  });

  @override
  State<FilterAndComparePane> createState() => _FilterAndComparePaneState();
}

class _FilterAndComparePaneState extends State<FilterAndComparePane> {
  final TextEditingController filterTextEditingController =
      TextEditingController();
  bool showOnlySelected = false;

  List<MapEntry<String, String>> schoolCategories =
      Metadata.instance.getMetadataCategory(2).metadataPairs.entries.toList();
  List<bool> showSchoolCategories = List.generate(
    Metadata.instance.getMetadataCategory(2).metadataPairs.length,
    (index) => false,
  );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
        ),
        Card(
          elevation: 0,
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  "Filters",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
                ),
                Expanded(
                  child: ListView(
                    children: [
                      FilterBlockWithHeader(
                        title: 'Search By School Name',
                        child: TextField(
                          controller: filterTextEditingController,
                          decoration: InputDecoration(
                            labelText: 'Search Schools',
                            hintText: 'Type School Name Here',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefixIcon: const Icon(Icons.search),
                          ),
                          onChanged: (value) {
                            if (value.isEmpty) {
                              widget.removeFilterCallback(
                                name: 'School Name',
                              );
                            } else {
                              widget.updateFilterCallback(
                                name: 'School Name',
                                filterFunction: (List<SchoolScore> scores) {
                                  return scores
                                      .where((school) => school.schoolName
                                          .toLowerCase()
                                          .contains(value.toLowerCase()))
                                      .toList();
                                },
                                resetCallback: () {
                                  filterTextEditingController.clear();
                                },
                              );
                            }
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: widget.selectedSchoolsCount >= 2
                              ? const Color(0xFFFF4713)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: widget.selectedSchoolsCount >= 2
                              ? const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ]
                              : [],
                        ),
                      ),
                      FilterBlockWithHeader(
                        title: 'Filter By State',
                        child: StateFilter(
                          updateFilterCallback: widget.updateFilterCallback,
                          removeFilterCallback: widget.removeFilterCallback,
                        ),
                      ),
                      FilterBlockWithHeader(
                        title: 'Filter By Public/Private',
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: schoolCategories.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 12.0),
                              child: Row(
                                children: [
                                  const SizedBox(width: 15),
                                  Checkbox(
                                    value: showSchoolCategories[index],
                                    onChanged: (value) {
                                      if (value != null) {
                                        setState(() {
                                          showSchoolCategories[index] = value;
                                          if (showSchoolCategories
                                              .any((v) => v)) {
                                            widget.updateFilterCallback(
                                              name: 'School Type',
                                              filterFunction: (scores) => scores
                                                  .where((s) => [
                                                        for (int i = 0;
                                                            i <
                                                                showSchoolCategories
                                                                    .length;
                                                            i++)
                                                          if (showSchoolCategories[
                                                              i])
                                                            schoolCategories[i]
                                                                .key
                                                      ].contains(s.schoolType))
                                                  .toList(),
                                              resetCallback: () {
                                                showSchoolCategories =
                                                    List.filled(
                                                        showSchoolCategories
                                                            .length,
                                                        false,
                                                        growable: true);
                                              },
                                            );
                                          } else {
                                            widget.removeFilterCallback(
                                              name: 'School Type',
                                            );
                                          }
                                        });
                                      }
                                    },
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Text(
                                      schoolCategories[index].value,
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      FilterBlockWithHeader(
                        title: 'Filter By Major And Level',
                        child: MajorLevelFilter(
                          updateFilterCallback: widget.updateFilterCallback,
                          removeFilterCallback: widget.removeFilterCallback,
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: showOnlySelected,
                        onChanged: (newValue) {
                          if (newValue != null) {
                            setState(() {
                              showOnlySelected = newValue;
                              if (newValue) {
                                widget.updateFilterCallback(
                                  name: 'Only Selected',
                                  filterFunction: (scores) => scores
                                      .where((s) => SchoolScore.selectedSchools
                                          .contains(s.uid))
                                      .toList(),
                                  resetCallback: () {
                                    showOnlySelected = false;
                                  },
                                );
                              } else {
                                widget.removeFilterCallback(
                                    name: "Only Selected");
                              }
                            });
                          }
                        },
                      ),
                      Text(
                        "Compare ${widget.selectedSchoolsCount} Selected Schools",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: widget.selectedSchoolsCount >= 2
                              ? Colors.green
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: widget.clearAllCallback,
                      child: const Text("Clear All Filters"),
                    ),
                    const SizedBox(
                      width: 50.0,
                    ),
                    TextButton(
                      onPressed: widget.clearSchoolSelection,
                      child: const Text("Clear Selected Schools"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
