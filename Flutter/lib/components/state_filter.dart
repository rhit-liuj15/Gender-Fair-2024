import 'package:flutter/material.dart';
import 'package:gender_fair_2024/components/filter_widget.dart';
import 'package:gender_fair_2024/components/state_name_tile.dart';
import 'package:gender_fair_2024/models/metadata.dart';
import 'package:gender_fair_2024/models/school_score.dart';

class StateFilter extends StatefulWidget implements FilterWidget {
  @override
	final void Function({
		required List<SchoolScore> Function(List<SchoolScore>) filterFunction,
		required String name,
		required dynamic Function() resetCallback,
	}) updateFilterCallback;
  @override
	final Function({required String name}) removeFilterCallback;

  const StateFilter({
    super.key,
    required this.updateFilterCallback,
    required this.removeFilterCallback,
  });

  @override
  StateFilterState createState() => StateFilterState();
}

class StateFilterState extends State<StateFilter> {
  final TextEditingController controller = TextEditingController();
  Map<String, String> states =
      Metadata.instance.getMetadataCategory(1).metadataPairs;

  List<MapEntry<String, String>> autocompleteStates = [];
  Set<String> selectedStates = <String>{};

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
                    !selectedStates.contains(entry.key))
            .toList();
      }
    });
  }

  void _selectState(MapEntry<String, String> state) {
    setState(() {
      selectedStates.add(state.key);
      autocompleteStates = [];
      controller.clear();
      onStatesSelectedChange();
    });
  }

  void _removeState(String state) {
    setState(() {
      selectedStates.remove(state);
      onStatesSelectedChange();
    });
  }

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
              .where((school) => selectedStates
                  .contains(school.schoolState))
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
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
            ),
            child: ListView.builder(
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
        Visibility(
					visible: selectedStates.isNotEmpty,
					child: const SizedBox(height: 10)
				),
        Wrap(
          spacing: 8,
          children: selectedStates
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
