import 'package:flutter/material.dart';
import 'package:gender_fair_2024/components/filter_state_name_tile.dart';

// Minimal widget for the left pane
class FilterAndComparePane extends StatelessWidget {
  final TextEditingController filterTextEditingController;
  final List<String> stateAbbreviations;
  final Map<String, bool> stateIsFilteredFor;
  final Map<String, FilterTextTile> stateNameTiles;
  final ValueChanged<String> onSearchChange;
  final VoidCallback onComparePressed;

  const FilterAndComparePane({
    Key? key,
    required this.filterTextEditingController,
    required this.stateAbbreviations,
    required this.stateIsFilteredFor,
    required this.stateNameTiles,
    required this.onSearchChange,
    required this.onComparePressed,
  }) : super(key: key);

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
                  "Filter and Compare Go Here",
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
                TextButton(
                  onPressed: onComparePressed,
                  child: const Text("Compare Schools"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
