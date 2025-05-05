import 'package:flutter/material.dart';
import 'package:gender_fair_2024/components/state_filter.dart';
import 'package:gender_fair_2024/models/metadata.dart';
import 'package:gender_fair_2024/models/school_score.dart';

class FilterAndComparePane extends StatefulWidget {
	/// The pane on the list page which contains the filters
	/// 
	/// Takes in a reference to the list of [filterFunctions] and a callback for [updateShownSchools] to update the filters
  
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
                  "",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 30),
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
                    },
                  ),
                ),
                const SizedBox(height: 10),
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
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                  child: StateFilter(
                    filterFunctions: widget.filterFunctions,
                    updateShownSchools: widget.updateShownSchools,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: schoolCategories.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          children: [
                            const SizedBox(width: 15),
                            Checkbox(
                              value: showSchoolCategories[index],
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    showSchoolCategories[index] = value;
                                    if (showSchoolCategories.any((v) => v)) {
                                      final selectedKeys = [
                                        for (int i = 0;
                                            i < showSchoolCategories.length;
                                            i++)
                                          if (showSchoolCategories[i])
                                            schoolCategories[i].key
                                      ];
                                      widget.filterFunctions['School Type'] =
                                          (scores) => scores
                                              .where((s) => selectedKeys
                                                  .contains(s.schoolType))
                                              .toList();
                                    } else {
                                      widget.filterFunctions
                                          .remove('School Type');
                                    }
                                    widget.updateShownSchools();
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
                const SizedBox(height: 10),
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
                                widget.filterFunctions['Only Selected'] =
                                    (scores) => scores
                                        .where((s) => SchoolScore
                                            .selectedSchools
                                            .contains(s.uid))
                                        .toList();
                              } else {
                                widget.filterFunctions.remove('Only Selected');
                              }
                              widget.updateShownSchools();
                            });
                          }
                        },
                      ),
                      const Text(
                        "Show Only Selected",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
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
        ),
      ],
    );
  }
}
