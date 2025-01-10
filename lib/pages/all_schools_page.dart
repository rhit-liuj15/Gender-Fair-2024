import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:gender_fair_2024/components/filter_state_name_tile.dart';
import 'package:gender_fair_2024/components/school_score_row.dart';
import 'package:gender_fair_2024/models/school_score.dart';
import 'package:gender_fair_2024/models/data_loader.dart';
import 'package:gender_fair_2024/pages/school_comparison_page.dart';

class AllSchoolsPage extends StatefulWidget {
  const AllSchoolsPage({super.key});

  @override
  State<AllSchoolsPage> createState() => _AllSchoolsPageState();
}

class _AllSchoolsPageState extends State<AllSchoolsPage> {
  List<SchoolScore> scoreList = <SchoolScore>[];

  List<SchoolScore> schoolsFilteredFor = <SchoolScore>[];
  List<SchoolScore> get _schoolsFilteredFor {
    return scoreList;
  }

  List<String> stateNames = <String>[];
  List<String> get _stateNames {
    return stateNameToAbbreviations.keys.toList();
  }

  List<String> stateAbbreviations = <String>[];
  List<String> get _stateAbbreviations {
    return stateNameToAbbreviations.values.toList();
  }

  List<String> filteringStates = <String>[];
  Map<String, String> stateNameToAbbreviations = <String, String>{};
  int sortingBy = -1;
  bool sortAscending = true;

  Map<String, FilterTextTile> stateNameTiles = <String, FilterTextTile>{};
  Map<String, bool> stateIsFilteredFor = <String, bool>{};
  List<String> statesFilteredFor = <String>[];
  List<String> get _statesFilteredFor {
    return stateIsFilteredFor.entries
        .where((entry) => entry.value == true)
        .map((entry) => entry.key)
        .toList();
  }

  final TextStyle textStyle = const TextStyle(fontSize: 18.0);
  final TextEditingController filterTextEditingController =
      TextEditingController();
  final FocusNode filterTextFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // Asynchronously load data from the singleton instance
  Future<void> loadData() async {
    await DataLoader.instance.loadData();
    setState(() {
      scoreList = DataLoader.instance.allScores.values.toList();
      stateNameToAbbreviations = DataLoader.instance.stateNameToAbbreviations;
    });
    stateNames = _stateNames;
    stateAbbreviations = _stateAbbreviations;
    statesFilteredFor = _statesFilteredFor;
    schoolsFilteredFor =
        statesFilteredFor.isEmpty ? scoreList : _schoolsFilteredFor;
    sortDataByMethod();
    populateStateNameTiles();
  }

  void populateStateNameTiles() {
    for (String name in stateNames) {
      String abbr = stateNameToAbbreviations[name]!;
      stateIsFilteredFor[abbr] = false;
      stateNameTiles[abbr] = FilterTextTile(
          state: name,
          removeStateCallback: () {
            if (stateIsFilteredFor.containsKey(abbr)) {
              setState(() {
                stateIsFilteredFor[abbr] = false;
                statesFilteredFor = _statesFilteredFor;
                schoolsFilteredFor =
                    statesFilteredFor.isEmpty ? scoreList : _schoolsFilteredFor;
                sortDataByMethod();
              });
            } else {
              print("The abbreviation '$abbr' does not exist");
            }
          });
    }
  }

  void sortData(int index) {
    setState(() {
      if (sortingBy == index) {
        sortAscending = !sortAscending;
      } else {
        sortingBy = index;
        if (index < 0) {
          sortAscending = true;
        } else {
          sortAscending = SchoolScoreRow.defaultSortOrder[index];
        }
      }
      sortDataByMethod();
    });
  }

  void sortDataByMethod() {
    setState(() {
      schoolsFilteredFor.sort((a, b) {
        int compareResult;
        switch (sortingBy) {
          case -1:
            compareResult = a.uid.compareTo(b.uid);
            break;
          case 0:
            compareResult = a.schoolName.compareTo(b.schoolName);
            break;
          case 1:
            compareResult = a.subscores[0].compareTo(b.subscores[0]);
            break;
          case 2:
            compareResult = a.subscores[1].compareTo(b.subscores[1]);
            break;
          case 3:
            compareResult = a.subscores[2].compareTo(b.subscores[2]);
            break;
          case 4:
            compareResult = a.subscores[3].compareTo(b.subscores[3]);
            break;
          case 5:
            compareResult = a.score.compareTo(b.score);
            break;
          default:
            throw ("Sort column index $sortingBy is not supported");
        }
        if (compareResult == 0) {
          return a.uid
              .compareTo(b.uid); // Backup sort, UID is guaranteed unique
        }
        return sortAscending ? compareResult : -compareResult;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
            child: Row(
              children: [
                SizedBox(
                  width: 85, 
                  height: 100,
                  child: Image.asset(
                    'assets/logo.png', 
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10.0),
                const Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "School Ranking System",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                     const SizedBox(height: 8.0),
                    const Flexible(
                        child: Text(
                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                          "Vivamus lacinia odio vitae vestibulum vestibulum. "
                          "Cras ultricies ligula sed magna dictum porta. "
                          "Donec sollicitudin molestie malesuada. "
                          "Praesent sapien massa, convallis a pellentesque nec, egestas non nisi.",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                           textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10.0),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
               padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Card(
                        child: Column(
                          children: [
                            const Text(
                              "Filter and Compare Go Here",
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  20.0, 5.0, 20.0, 5.0),
                              child: RawAutocomplete(
                                textEditingController:
                                    filterTextEditingController,
                                focusNode: filterTextFocusNode,
                                onSelected: (String selection) {
                                  setState(() {
                                    filterTextEditingController.clear();
                                    stateIsFilteredFor[stateNameToAbbreviations[
                                        selection]!] = true;
                                    statesFilteredFor = _statesFilteredFor;
                                    schoolsFilteredFor =
                                        statesFilteredFor.isEmpty
                                            ? scoreList
                                            : _schoolsFilteredFor;
                                    sortDataByMethod();
                                  });
                                },
                                optionsBuilder:
                                    (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<String>.empty();
                                  }
                                  return stateNames.where((String option) {
                                    return option.toLowerCase().contains(
                                        textEditingValue.text.toLowerCase());
                                  });
                                },
                                optionsViewBuilder: (BuildContext context,
                                    AutocompleteOnSelected<String> onSelected,
                                    Iterable<String> options) {
                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    itemCount: options.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final String option =
                                          options.elementAt(index);
                                      return ListTile(
                                        title: Text(option),
                                        onTap: () => onSelected(option),
                                      );
                                    },
                                  );
                                },
                                fieldViewBuilder: (BuildContext context,
                                    TextEditingController textEditingController,
                                    FocusNode focusNode,
                                    VoidCallback onFieldSubmitted) {
                                  return TextField(
                                    controller: textEditingController,
                                    focusNode: focusNode,
                                    onSubmitted: (String value) {
                                      onFieldSubmitted();
                                    },
                                    decoration: const InputDecoration(
                                      labelText: 'State',
                                      border: OutlineInputBorder(),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Wrap(
                              children: stateAbbreviations.map((abbr) {
                                return Visibility(
                                  visible: stateIsFilteredFor[abbr]!,
                                  child: stateNameTiles[abbr]!,
                                );
                              }).toList(),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SchoolComparisonPage(),
                                  ),
                                );
                              },
                              child: const Text("Compare Schools"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30.0,
                    ),
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          Row(
                            children: List.generate(
                              SchoolScoreRow.numColumns,
                              (index) => Expanded(
                                flex: SchoolScoreRow.flexValues[index],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextButton(
                                    onPressed: () {
                                      sortData(index);
                                    },
                                    child: Text(
                                      SchoolScoreRow.columnNames[index],
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: schoolsFilteredFor.length,
                              itemBuilder: (context, index) {
                                return SchoolScoreRow(
                                    school: schoolsFilteredFor[index]);
                              },
                            ),
                          ),
                        ],
                      ),
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
