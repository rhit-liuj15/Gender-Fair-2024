import 'package:flutter/material.dart';
import 'package:gender_fair_2024/models/filter_data.dart';
import 'package:gender_fair_2024/models/selected_schools.dart';

import 'filterPane/filter_panel.dart';
import 'listPane/school_list_panel.dart';

class SchoolListPage extends StatefulWidget {
  const SchoolListPage({super.key});

  @override
  State<SchoolListPage> createState() => _SchoolListPageState();
}

class _SchoolListPageState extends State<SchoolListPage> {

  final FocusNode filterTextFocusNode = FocusNode();

  void clearSchoolSelection() {
		SelectedSchools.instance.selectedSchools.clear();
    FilterData.instance.applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 10.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: FilterPanel(),
                    ),
                    SizedBox(width: 30.0),
                    Expanded(
                      flex: 5,
                      child: SchoolListPanel.instance,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}