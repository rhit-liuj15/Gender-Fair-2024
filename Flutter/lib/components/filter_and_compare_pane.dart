import 'package:flutter/material.dart';
import 'package:gender_fair_2024/components/filter_state_name_tile.dart';

class FilterAndComparePane extends StatelessWidget {
  final TextEditingController filterTextEditingController;
  final Set<String> statesFilteredFor;
  final ValueChanged<String> onSearchChange;
  final bool showOnlySelected;
  final ValueChanged<bool?> onShowOnlySelectedToggle;
  final int selectedSchoolsCount;
  final bool showPublic;
  final bool showPrivate;
  final ValueChanged<bool?> onTogglePublic;
  final ValueChanged<bool?> onTogglePrivate;

  const FilterAndComparePane({
    super.key,
    required this.filterTextEditingController,
    required this.statesFilteredFor,
    required this.onSearchChange,
    required this.showOnlySelected,
    required this.onShowOnlySelectedToggle,
    required this.selectedSchoolsCount,
    required this.showPublic,
    required this.showPrivate,
    required this.onTogglePublic,
    required this.onTogglePrivate,
  });

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
                      hintText: 'Type School Name Here',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onChanged: onSearchChange,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: selectedSchoolsCount >= 2
                        ? const Color(0xFFFF4713)
                        : const Color.fromARGB(255, 255, 255, 255),
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
                        value: showPublic,
                        onChanged: onTogglePublic,
                      ),
                      const Text("Public Schools"),
                      const SizedBox(width: 10),
                      Checkbox(
                        value: showPrivate,
                        onChanged: onTogglePrivate,
                      ),
                      const Text("Private Schools"),
                    ],
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
                      const Text("Show Only Selected"),
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
