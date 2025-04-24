import 'package:flutter/material.dart';
import 'package:gender_fair_2024/components/state_filter.dart';
import 'package:gender_fair_2024/models/metadata.dart';
import 'package:gender_fair_2024/models/school_score.dart';

class FilterAndComparePane extends StatefulWidget {
  final Map<String, List<SchoolScore> Function(List<SchoolScore>)>
      filterFunctions;
  final Function() updateShownSchools;
  final int selectedSchoolsCount;

  const FilterAndComparePane({
    super.key,
    required this.filterFunctions,
    required this.updateShownSchools,
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
      (index) => false);

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
                  "",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
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
                          widget.filterFunctions.remove('School Name');
                        } else {
                          widget.filterFunctions['School Name'] =
                              (List<SchoolScore> scores) {
                            return scores
                                .where((school) => school.schoolName
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          };
                        }
                        widget.updateShownSchools();
                      }),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: widget.selectedSchoolsCount >= 2
                        ? const Color(0xFFFF4713)
                        : const Color.fromARGB(255, 255, 255, 255),
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
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                  child: StateFilter(
                    filterFunctions: widget.filterFunctions,
                    updateShownSchools: widget.updateShownSchools,
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                    child: SizedBox(
                  height: 400,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: schoolCategories.length,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: showSchoolCategories[index],
                            onChanged: (value) {
                              if (value != null) {
                                showSchoolCategories[index] = value;
                                List<String> categoriesToMatch = [];
                                if (showSchoolCategories
                                    .any((value) => value)) {
                                  for (var i = 0;
                                      i < showSchoolCategories.length;
                                      i++) {
                                    if (showSchoolCategories[i]) {
                                      categoriesToMatch
                                          .add(schoolCategories[i].key);
                                    }
                                  }
                                  widget.filterFunctions['School Type'] =
                                      (List<SchoolScore> scores) {
                                    return scores
                                        .where((school) => categoriesToMatch
                                            .contains(school.schoolType))
                                        .toList();
                                  };
                                } else {
                                  widget.filterFunctions.remove('School Type');
                                }
                                widget.updateShownSchools();
                              }
                            },
                          ),
                          Text(schoolCategories[index].value),
                        ],
                      );
                    },
                  ),
                )),
                const SizedBox(height: 4),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: showOnlySelected,
                        onChanged: (bool? newValue) {
                          if (newValue != null) {
                            showOnlySelected = newValue;
                            if (newValue) {
                              widget.filterFunctions['Only Selected'] =
                                  (List<SchoolScore> scores) {
                                return scores
                                    .where((school) => SchoolScore
                                        .selectedSchools
                                        .contains(school.uid))
                                    .toList();
                              };
                            } else {
                              widget.filterFunctions.remove('Only Selected');
                            }
                            widget.updateShownSchools();
                          }
                        },
                      ),
                      const Text("Show Only Selected"),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Compare ${widget.selectedSchoolsCount} Selected Schools",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: widget.selectedSchoolsCount >= 2
                        ? Colors.green
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
