import 'package:flutter/material.dart';
import 'package:gender_fair_2024/models/data_loader.dart';
import 'package:gender_fair_2024/models/filter_data.dart';
import 'package:gender_fair_2024/models/metadata.dart';
import 'package:gender_fair_2024/models/school_academic_offerings.dart';
import 'package:gender_fair_2024/models/school_score.dart';
import 'package:gender_fair_2024/pages/listPage/filterPane/filters/majorLeveFilter/major_options_block.dart';

class MajorLevelFilter extends StatefulWidget {
  static const filterName = "Major/Level";

  static List<SchoolScore> Function(List<SchoolScore>) filterLogic =
      (List<SchoolScore> scores) {
    if (!FilterData.instance.selectedLevelsByCIPCODE.entries.any((entry) => entry.value.isNotEmpty)) {
      return scores;
    } else {
      Set<int> allUIDsMatchingSelection = <int>{};
      for (MapEntry<String, Set<int>> item
          in FilterData.instance.selectedLevelsByCIPCODE.entries) {
        SchoolAcademicOfferings offeringWithCIPCODE =
            DataLoader.instance.allSchoolOfferings[item.key]!;
        for (int level in item.value) {
          allUIDsMatchingSelection = allUIDsMatchingSelection.union(
              offeringWithCIPCODE.schoolsOfferingCourseAtLevel(level: level));
        }
      }
      return scores
          .where(
            (element) => allUIDsMatchingSelection.contains(element.uid),
          )
          .toList();
    }
  };

  static const MajorLevelFilter instance =
      MajorLevelFilter._privateConstructor();

  const MajorLevelFilter._privateConstructor();

  @override
  State<MajorLevelFilter> createState() => _MajorLevelFilterState();
}

class _MajorLevelFilterState extends State<MajorLevelFilter> {
  final TextEditingController controller = TextEditingController();
  Map<String, String> majors =
      Metadata.instance.getMetadataCategory(3).metadataPairs;
  List<MapEntry<String, String>> autocompleteMajors = [];

  @override
  void initState() {
    super.initState();
    FilterData.instance.registerFilter(
      name: MajorLevelFilter.filterName,
      filterFunction: MajorLevelFilter.filterLogic,
    );
    FilterData.instance.registerResetCallback(
      name: MajorLevelFilter.filterName,
      resetCallback: () {
				FilterData.instance.selectedLevelsByCIPCODE.clear();
      },
    );
    FilterData.instance.addRebuildCallback(
      name: MajorLevelFilter.filterName,
      rebuildCallback: () {
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    FilterData.instance.removeRebuildCallback(
      name: MajorLevelFilter.filterName,
    );
    super.dispose();
  }

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
                !FilterData.instance.selectedLevelsByCIPCODE.keys.contains(entry.key))
            .map((e) => e)
            .toList();
      }
    });
  }

  void _addMajor(String major) {
    // By default, every available major is selected
    setState(() {
      autocompleteMajors = [];
      FilterData.instance.selectedLevelsByCIPCODE[major] = DataLoader.instance.allSchoolOfferings[major]!
          .levelsAvailableForMajor();
      controller.clear();
    });
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
                  return ListTile(
                    title: Text(autocompleteMajors[index].value),
                    onTap: () {
                      _addMajor(autocompleteMajors[index].key);
											FilterData.instance.applyFilters();
                      autocompleteMajors = [];
                    },
                  );
                },
              ),
            ),
          ),
        Visibility(
          visible: FilterData.instance.selectedLevelsByCIPCODE.isNotEmpty,
          child: Column(
            children: [
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                children: FilterData.instance.selectedLevelsByCIPCODE.entries.map(
                  (entry) {
                    return MajorOptionsBlock(
											cipcode: entry.key,
                      updateLevelsCallback: () {
												setState(() {
													FilterData.instance.applyFilters();
												});
											}
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
