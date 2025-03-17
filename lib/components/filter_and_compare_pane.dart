import 'package:flutter/material.dart';
import 'package:gender_fair_2024/components/filter_state_name_tile.dart';

class FilterAndComparePane extends StatelessWidget {
  final TextEditingController filterTextEditingController;
  final List<String> stateAbbreviations;
  final Map<String, bool> stateIsFilteredFor;
  final Map<String, FilterTextTile> stateNameTiles;
  final ValueChanged<String> onSearchChange;
  final bool showOnlySelected;
  final ValueChanged<bool?> onShowOnlySelectedToggle;
  final int selectedSchoolsCount;

  const FilterAndComparePane({
    super.key,
    required this.filterTextEditingController,
    required this.stateAbbreviations,
    required this.stateIsFilteredFor,
    required this.stateNameTiles,
    required this.onSearchChange,
    required this.showOnlySelected,
    required this.onShowOnlySelectedToggle,
    required this.selectedSchoolsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
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
                  "",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                  child: TextField(
                    controller: filterTextEditingController,
                    decoration: InputDecoration(
                      labelText: 'Search Schools',
                      hintText: 'Type school name...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onChanged: onSearchChange,
                  ),
                ),
                Wrap(
                  children: stateAbbreviations.map((abbr) {
                    return Visibility(
                      visible: stateIsFilteredFor[abbr] ?? false,
                      child: stateNameTiles[abbr] ?? const SizedBox(),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: selectedSchoolsCount >= 2
                        ? Colors.blue
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: selectedSchoolsCount >= 2
                        ? const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: showOnlySelected,
                        onChanged: onShowOnlySelectedToggle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Compare $selectedSchoolsCount Selected Schools",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color:
                        selectedSchoolsCount >= 2 ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
