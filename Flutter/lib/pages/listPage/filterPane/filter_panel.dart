import 'package:flutter/material.dart';
import 'package:gender_fair_2024/models/filter_data.dart';
import 'package:gender_fair_2024/models/selected_schools.dart';
import 'package:gender_fair_2024/pages/listPage/filterPane/filter_block_with_header.dart';
import 'package:gender_fair_2024/pages/listPage/filterPane/filters/major_level_filter.dart';
import 'package:gender_fair_2024/pages/listPage/filterPane/filters/public_private_filter.dart';
import 'package:gender_fair_2024/pages/listPage/filterPane/filters/show_only_selected_tile.dart';
import 'package:gender_fair_2024/pages/listPage/filterPane/filters/state_filter.dart';

class FilterPanel extends StatefulWidget {
  const FilterPanel({
    super.key,
  });

  @override
  State<FilterPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends State<FilterPanel> {
	
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
                    children: const [
                      FilterBlockWithHeader(
                        title: 'Filter By State',
                        child: StateFilter.instance,
                      ),
                      FilterBlockWithHeader(
                        title: 'Filter By Public/Private',
                        child: PublicPrivateFilter.instance,
                      ),
                      FilterBlockWithHeader(
                        title: 'Filter By Major And Level',
                        child: MajorLevelFilter.instance,
                      ),
                    ],
                  ),
                ),
								ShowOnlySelectedTile.instance,
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: FilterData.instance.clearFilters,
                      child: const Text("Clear All Filters"),
                    ),
                    const SizedBox(
                      width: 50.0,
                    ),
                    TextButton(
                      onPressed: SelectedSchools.instance.clearSchoolSelection,
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
