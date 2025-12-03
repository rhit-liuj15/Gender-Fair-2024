import 'package:flutter/material.dart';
import 'package:gender_fair_2024/pages/listPane/components/school_name_filter.dart';
import 'package:gender_fair_2024/pages/listPane/components/school_data_table.dart';
/// The pane on the list page that has the list of schools as filtered for by the user (or all schools if filters are absent)
class SchoolListPanel extends StatelessWidget {
  static const SchoolListPanel instance = SchoolListPanel._privateConstructor();
  const SchoolListPanel._privateConstructor();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        border: Border.all(color: const Color(0xFFFF4713), width: 2),
      ),
      child: const Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
								Text(
									"Gender Fair College Details Catalog",
									style: TextStyle(
										fontSize: 28,
										fontWeight: FontWeight.bold,
									),
								),
                Expanded(child: SizedBox()),
                SizedBox(
                  width: 500,
                  child: SchoolNameFilter.instance,
                ),
              ],
            ),
          ),
          Expanded(child: SchoolDataTable.instance),
        ],
      ),
    );
  }
}
