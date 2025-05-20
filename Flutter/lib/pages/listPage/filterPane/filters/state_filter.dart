import 'package:flutter/material.dart';
import 'package:gender_fair_2024/models/filter_data.dart';
import 'package:gender_fair_2024/pages/listPage/filterPane/filters/stateFilter/state_name_tile.dart';
import 'package:gender_fair_2024/models/metadata.dart';
import 'package:gender_fair_2024/models/school_score.dart';

class StateFilter extends StatefulWidget {
  static const filterName = "States";

  static List<SchoolScore> Function(List<SchoolScore>) filterLogic =
      (List<SchoolScore> scores) {
    if (FilterData.instance.selectedStates.isEmpty) {
      return scores;
    } else {
      return scores
          .where((school) =>
              FilterData.instance.selectedStates.contains(school.schoolState))
          .toList();
    }
  };

  static const StateFilter instance = StateFilter._privateConstructor();

  const StateFilter._privateConstructor();

  @override
  State<StateFilter> createState() => _StateFilterState();
}

class _StateFilterState extends State<StateFilter> {
  final TextEditingController controller = TextEditingController();
  static final Map<String, String> states =
      Metadata.instance.getMetadataCategory(1).metadataPairs;
  List<MapEntry<String, String>> autocompleteStates = [];

  @override
  void initState() {
    super.initState();
    FilterData.instance.registerFilter(
      name: StateFilter.filterName,
      filterFunction: StateFilter.filterLogic,
    );
    FilterData.instance.registerResetCallback(
      name: StateFilter.filterName,
      resetCallback: () {
        FilterData.instance.selectedStates.clear();
      },
    );
    FilterData.instance.addRebuildCallback(
      name: StateFilter.filterName,
      rebuildCallback: () {
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    FilterData.instance.removeRebuildCallback(
      name: StateFilter.filterName,
    );
    super.dispose();
  }

  void _updateAutocomplete(String inputString) {
    setState(() {
      if (inputString.isEmpty) {
        autocompleteStates = [];
      } else {
        String inputStringLower = inputString.toLowerCase();
        autocompleteStates = states.entries
            .where(
                // If it the user entered states that matches 1a) the state name or 1b) the state abbreviation and 2) does not already exist in the selected states
                (entry) =>
                    (entry.key.toLowerCase().contains(inputStringLower) ||
                        entry.value.toLowerCase().contains(inputStringLower)) &&
                    !FilterData.instance.selectedStates.contains(entry.key))
            .toList();
      }
    });
  }

  void _selectState(MapEntry<String, String> state) {
    setState(() {
      FilterData.instance.selectedStates.add(state.key);
      autocompleteStates = [];
      controller.clear();
    });
    FilterData.instance.applyFilters();
  }

  void _removeState(String state) {
    setState(() {
      FilterData.instance.selectedStates.remove(state);
    });
    FilterData.instance.applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Filter By State',
            hintText: 'Enter State Name Here',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: const Icon(Icons.filter_alt_sharp),
          ),
          onChanged: _updateAutocomplete,
        ),
        if (autocompleteStates.isNotEmpty)
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 180),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: autocompleteStates.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(autocompleteStates[index].value),
                    onTap: () {
                      _selectState(autocompleteStates[index]);
                      setState(() {
                        autocompleteStates = [];
                      });
                    },
                  );
                },
              ),
            ),
          ),
        Visibility(
            visible: FilterData.instance.selectedStates.isNotEmpty,
            child: const SizedBox(height: 10)),
        Wrap(
          spacing: 8,
          children: FilterData.instance.selectedStates
              .map((entry) => StateNameTile(
                    state: states[entry]!,
                    removeStateCallback: () => _removeState(entry),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
