import 'package:flutter/material.dart';
import 'package:gender_fair_2024/pages/listPage/filterPane/filters/filter_widget.dart';
import 'package:gender_fair_2024/models/data_loader.dart';
import 'package:gender_fair_2024/models/metadata.dart';
import 'package:gender_fair_2024/models/school_academic_offerings.dart';
import 'package:gender_fair_2024/models/school_score.dart';
import 'package:gender_fair_2024/pages/listPage/filterPane/filters/majorLeveFilter/major_options_block.dart';

class MajorLevelFilter extends StatefulWidget implements FilterWidget {
  @override
  final void Function({
    required List<SchoolScore> Function(List<SchoolScore>) filterFunction,
    required String name,
    required dynamic Function() resetCallback,
  }) updateFilterCallback;

  @override
  final Function({required String name}) removeFilterCallback;

  const MajorLevelFilter({
    super.key,
    required this.updateFilterCallback,
    required this.removeFilterCallback,
  });

  @override
  MajorLevelFilterState createState() => MajorLevelFilterState();
}

class MajorLevelFilterState extends State<MajorLevelFilter> {
  final TextEditingController controller = TextEditingController();
  Map<String, String> majors =
      Metadata.instance.getMetadataCategory(3).metadataPairs;
  List<MapEntry<String, String>> autocompleteMajors = [];
  Map<String, Set<int>> selectedMajors = <String, Set<int>>{};

  void _updateAutocomplete(String inputString) {
    setState(() {
      if (inputString.isEmpty) {
        autocompleteMajors = [];
      } else {
        String inputStringLower = inputString.toLowerCase();
        autocompleteMajors = majors.entries
            .where((entry) =>
                (entry.key.toLowerCase().contains(inputStringLower) ||
                    entry.value.toLowerCase().contains(inputStringLower)) &&
                !selectedMajors.keys.contains(entry.key))
            .map((e) => e)
            .toList();
      }
    });
  }

  void _addMajor(String major) {
		// By default, every available major is selected
		selectedMajors[major] = DataLoader.instance.allSchoolOfferings[major]!.levelsAvailableForMajor();
		setState(() {
			autocompleteMajors = [];
		});
		controller.clear();
		onMajorChange();
  }

  void _updateMajor(String major) {
    onMajorChange();
  }

  void onMajorChange() {
    if (selectedMajors.isEmpty) {
      widget.removeFilterCallback(
        name: 'Majors',
      );
    } else {
      widget.updateFilterCallback(
        name: "Majors",
        filterFunction: (List<SchoolScore> scores) {
          Set<int> allUIDsMatchingSelection = <int>{};
          for (MapEntry<String, Set<int>> item in selectedMajors.entries) {
            SchoolAcademicOfferings offeringWithCIPCODE =
                DataLoader.instance.allSchoolOfferings[item.key]!;
            for (int level in item.value) {
              allUIDsMatchingSelection = allUIDsMatchingSelection.union(
                  offeringWithCIPCODE.schoolsOfferingCourseAtLevel(
                      level: level));
            }
          }
          // print(allUIDsMatchingSelection);
          return scores
              .where(
                (element) => allUIDsMatchingSelection.contains(element.uid),
              )
              .toList();
        },
        resetCallback: () {
          selectedMajors.clear();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Filter By Major',
            hintText: 'Enter Major Here',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: const Icon(Icons.filter_alt_sharp),
          ),
          onChanged: _updateAutocomplete,
        ),
        if (autocompleteMajors.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 400),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: autocompleteMajors.length,
                itemBuilder: (context, index) {
									// print("Length of array is ${autocompleteMajors.length}. $index: $autocompleteMajors");
                  return ListTile(
                    title: Text(autocompleteMajors[index].value),
                    onTap: () {
											// print("My index is $index");
                      _addMajor(autocompleteMajors[index].key);
                      autocompleteMajors = [];
                    },
                  );
                },
              ),
            ),
          ),
        Visibility(
          visible: selectedMajors.isNotEmpty,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: selectedMajors.entries.map(
                  (entry) {
                    return MajorOptionsBlock(
                      offerings: DataLoader.instance.allSchoolOfferings[entry.key]!,
                      selectedLevels: entry.value,
                      updateLevelsCallback: () => _updateMajor(entry.key),
                    );
                  },
                ).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
