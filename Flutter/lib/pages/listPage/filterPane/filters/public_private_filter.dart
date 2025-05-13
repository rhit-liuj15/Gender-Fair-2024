import 'package:flutter/material.dart';
import 'package:gender_fair_2024/models/filter_data.dart';
import 'package:gender_fair_2024/models/school_score.dart';

class PublicPrivateFilter extends StatefulWidget {
  static const filterName = "Public/Private";

  static List<SchoolScore> Function(List<SchoolScore>) filterLogic =
      (List<SchoolScore> scores) {
    if (!FilterData.instance.showSchoolCategories.values.any((v) => v)) {
      return scores;
    } else {
      return scores.where((s) {
        return FilterData.instance.showSchoolCategories.entries
            .where((e) => e.value)
            .map((e) => e.key)
            .toList()
            .contains(s.schoolType);
      }).toList();
    }
  };

  static const PublicPrivateFilter instance =
      PublicPrivateFilter._privateConstructor();

  const PublicPrivateFilter._privateConstructor();

  @override
  State<PublicPrivateFilter> createState() => _PublicPrivateFilterState();
}

class _PublicPrivateFilterState extends State<PublicPrivateFilter> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    FilterData.instance.registerFilter(
        name: PublicPrivateFilter.filterName,
        filterFunction: PublicPrivateFilter.filterLogic);
    FilterData.instance.registerResetCallback(
      name: PublicPrivateFilter.filterName,
      resetCallback: () {
        FilterData.instance.showSchoolCategories.updateAll(
          (key, value) => false
        );
      },
    );
    FilterData.instance.addRebuildCallback(
      name: PublicPrivateFilter.filterName,
      rebuildCallback: () {
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    FilterData.instance.removeRebuildCallback(
      name: PublicPrivateFilter.filterName,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (MapEntry<String, bool> entry
            in FilterData.instance.showSchoolCategories.entries)
          Row(
            children: [
              const SizedBox(width: 15),
              Checkbox(
                value: entry.value,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      FilterData.instance.showSchoolCategories[entry.key] =
                          value;
                    });
                    FilterData.instance.applyFilters();
                  }
                },
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  FilterData.instance.schoolCategories[entry.key]!,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
