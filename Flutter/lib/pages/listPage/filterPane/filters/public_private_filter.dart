import 'package:flutter/material.dart';
import 'package:gender_fair_2024/pages/listPage/filterPane/filters/filter_widget.dart';
import 'package:gender_fair_2024/models/metadata.dart';
import 'package:gender_fair_2024/models/school_score.dart';

class PublicPrivateFilter extends StatefulWidget implements FilterWidget {
  @override
  final void Function({
    required List<SchoolScore> Function(List<SchoolScore>) filterFunction,
    required String name,
    required dynamic Function() resetCallback,
  }) updateFilterCallback;
  @override
  final Function({required String name}) removeFilterCallback;

  const PublicPrivateFilter({
    super.key,
    required this.updateFilterCallback,
    required this.removeFilterCallback,
  });

  @override
  PublicPrivateFilterState createState() => PublicPrivateFilterState();
}

class PublicPrivateFilterState extends State<PublicPrivateFilter> {
  final TextEditingController controller = TextEditingController();
  Map<String, String> states =
      Metadata.instance.getMetadataCategory(1).metadataPairs;

  List<MapEntry<String, String>> autocompleteStates = [];
  Set<String> selectedStates = <String>{};

  void onStatesSelectedChange() {
    if (selectedStates.isEmpty) {
      widget.removeFilterCallback(
        name: 'States',
      );
    } else {
      widget.updateFilterCallback(
        name: "States",
        filterFunction: (List<SchoolScore> scores) {
          return scores
              .where((school) => selectedStates.contains(school.schoolState))
              .toList();
        },
        resetCallback: () {
          selectedStates.clear();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<MapEntry<String, String>> schoolCategories =
        Metadata.instance.getMetadataCategory(2).metadataPairs.entries.toList();
    List<bool> showSchoolCategories = List.generate(
      Metadata.instance.getMetadataCategory(2).metadataPairs.length,
      (index) => false,
    );
    return ListView.builder(
      shrinkWrap: true,
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
                        widget.updateFilterCallback(
                          name: 'School Type',
                          filterFunction: (scores) => scores
                              .where((s) => [
                                    for (int i = 0;
                                        i < showSchoolCategories.length;
                                        i++)
                                      if (showSchoolCategories[i])
                                        schoolCategories[i].key
                                  ].contains(s.schoolType))
                              .toList(),
                          resetCallback: () {
                            showSchoolCategories = List.filled(
                                showSchoolCategories.length, false,
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
    );
  }
}
