import 'package:flutter/material.dart';
import 'package:gender_fair_2024/models/filter_data.dart';
import 'package:gender_fair_2024/models/selected_schools.dart';

class ShowOnlySelectedTile extends StatefulWidget {
  const ShowOnlySelectedTile({
    super.key,
  });

  static const filterName = "Show Only Selected";

  static const String selectedSchoolsListListenerName = "Show Only Selected";

  static const ShowOnlySelectedTile instance =
      ShowOnlySelectedTile._privateConstructor();

  const ShowOnlySelectedTile._privateConstructor();

  @override
  State<ShowOnlySelectedTile> createState() => _ShowOnlySelectedTileState();
}

class _ShowOnlySelectedTileState extends State<ShowOnlySelectedTile> {
  @override
  void initState() {
    super.initState();
    SelectedSchools.instance.addSelectedSchoolsListListener(
      name: ShowOnlySelectedTile.selectedSchoolsListListenerName,
      callback: () {
        setState(() {});
      },
    );
		
    FilterData.instance.registerFilter(
        name: ShowOnlySelectedTile.filterName,
        filterFunction: (scores) {
          if (FilterData.instance.showOnlySelected) {
            return scores
                .where((s) =>
                    SelectedSchools.instance.selectedSchools.contains(s.uid))
                .toList();
          } else {
            return scores;
          }
        });
  }

  @override
  void dispose() {
    SelectedSchools.instance.removeSelectedSchoolsListListener(
      name: ShowOnlySelectedTile.selectedSchoolsListListenerName,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          value: FilterData.instance.showOnlySelected,
          onChanged: (newValue) {
            if (newValue != null) {
              setState(() {
                FilterData.instance.showOnlySelected = newValue;
                FilterData.instance.applyFilters();
              });
            }
          },
        ),
        Text(
          "Compare ${SelectedSchools.instance.selectedSchools.length} Selected Schools",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: SelectedSchools.instance.selectedSchools.length >= 2
                ? Colors.green
                : Colors.grey,
          ),
        ),
      ],
    );
  }
}
