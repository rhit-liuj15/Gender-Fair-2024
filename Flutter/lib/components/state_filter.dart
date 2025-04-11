import 'package:flutter/material.dart';
import 'package:gender_fair_2024/components/state_name_tile.dart';
import 'package:gender_fair_2024/models/metadata.dart';
import 'package:gender_fair_2024/models/school_score.dart';

class StateFilter extends StatefulWidget {
  final Map<String, List<SchoolScore> Function(List<SchoolScore>)>
      filterFunctions;
  final Function() updateShownSchools;

  const StateFilter({
    super.key,
    required this.filterFunctions,
    required this.updateShownSchools,
  });

  @override
  _StateFilterState createState() => _StateFilterState();
}

class _StateFilterState extends State<StateFilter> {
  final TextEditingController controller = TextEditingController();
  Map<String, String> states =
      Metadata.instance.getMetadataCategory(1).metadataPairs;

  List<MapEntry<String, String>> autocompleteStates = [];
  Map<String, bool> selectedStates = {
    for (var key in Metadata.instance.getMetadataCategory(1).metadataPairs.keys)
      key: false,
  };

  void _updateAutocomplete(String inputString) {
    setState(() {
      if (inputString.isEmpty) {
        autocompleteStates = [];
      } else {
				String inputStringLower = inputString.toLowerCase();
        autocompleteStates = states.entries.where(
					// If it the user entered states that matches 1a) the state name or 1b) the state abbreviation and 2) does not already exist in the selected states
					(entry) => (entry.key.toLowerCase().contains(inputStringLower) ||
              entry.value.toLowerCase().contains(inputStringLower)) &&
							!selectedStates[entry.key]!
        ).toList();
      }
    });
  }

  void _selectState(MapEntry<String, String> state) {
    setState(() {
      selectedStates[state.key] = true;
      onSelectState();
      autocompleteStates = [];
      controller.clear();
    });
  }

  void _removeState(String state) {
    setState(() {
      selectedStates.remove(state);
      onSelectState();
    });
  }

  void onSelectState() {
    if (selectedStates.isEmpty) {
      widget.filterFunctions.remove('States');
    } else {
      List<String> filteredStatesList = selectedStates.entries
          .where((element) => element.value)
          .map((entry) => entry.key)
          .toList();
      widget.filterFunctions['States'] = (List<SchoolScore> scores) {
        return scores
            .where((school) => filteredStatesList.contains(school.schoolState))
            .toList();
      };
    }
    widget.updateShownSchools();
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
        const SizedBox(height: 10),
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
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: selectedStates.entries
              .where((entry) => entry.value)
              .map((entry) => StateNameTile(
                    state: states[entry.key]!,
                    removeStateCallback: () => _removeState(entry.key),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
