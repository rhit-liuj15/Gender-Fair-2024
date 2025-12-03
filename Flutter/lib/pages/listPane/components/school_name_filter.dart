import 'package:flutter/material.dart';
import 'package:gender_fair_2024/models/filter_data.dart';
import 'package:gender_fair_2024/models/school_data.dart';

class SchoolNameFilter extends StatefulWidget {
  static const filterName = "School Name";

  static const SchoolNameFilter instance = SchoolNameFilter._privateConstructor();

  const SchoolNameFilter._privateConstructor();

  @override
  State<SchoolNameFilter> createState() => _SchoolNameFilterState();
}

class _SchoolNameFilterState extends State<SchoolNameFilter> {
  final TextEditingController filterTextEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    FilterData.instance.registerFilter(
      name: 'School Name',
      filterFunction: (List<SchoolData> scores) {
        if (FilterData.instance.schoolNameInput.isEmpty) {
          return scores;
        } else {
          return scores
              .where((school) => school.getName()
                  .toLowerCase()
                  .contains(FilterData.instance.schoolNameInput.toLowerCase()))
              .toList();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: filterTextEditingController,
      decoration: InputDecoration(
        labelText: 'Search Schools',
        hintText: 'Enter School Name Here',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: const Icon(Icons.search),
      ),
      onChanged: (value) {
        FilterData.instance.schoolNameInput = value;
        FilterData.instance.applyFilters();
      },
    );
  }
}
