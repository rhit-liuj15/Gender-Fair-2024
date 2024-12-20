
import 'package:flutter/material.dart';
import 'package:gender_fair_2024/components/filter_page_state_name_tile.dart';
import 'package:gender_fair_2024/components/school_score_row.dart';
import 'package:gender_fair_2024/models/school_score.dart';
import 'package:gender_fair_2024/models/data_loader.dart';

class SortableTable extends StatefulWidget {
  const SortableTable({super.key});

  @override
  _SortableTableState createState() => _SortableTableState();
}

class _SortableTableState extends State<SortableTable> {
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
  Map<String,String> stateNameToAbbreviations = <String,String>{};
	int sortingBy = -1;
	bool sortAscending = true;

	Map<String,FilterPageStateNameTile> stateNameTiles = <String,FilterPageStateNameTile>{};
	Map<String,bool> stateIsFilteredFor = <String,bool>{};
	List<String> statesFilteredFor = <String>[]; 
	List<String> get _statesFilteredFor {
		return stateIsFilteredFor.entries.where((entry) => entry.value == true).map((entry) => entry.key).toList();
	}

	final TextStyle textStyle = const TextStyle(fontSize: 18.0);

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
    schoolsFilteredFor = statesFilteredFor.isEmpty ? scoreList : _schoolsFilteredFor;
    sortDataByMethod();
	populateStateNameTiles();
  }

	void populateStateNameTiles() {
		for (String name in stateNames) {
			String abbr = stateNameToAbbreviations[name]!;
			stateIsFilteredFor[abbr] = false;
			stateNameTiles[abbr] = FilterPageStateNameTile(
				state: name,
				removeStateCallback: () {
					if (stateIsFilteredFor.containsKey(abbr)) {
						setState(() {
							stateIsFilteredFor[abbr] = false;
              statesFilteredFor = _statesFilteredFor;
              schoolsFilteredFor = statesFilteredFor.isEmpty ? scoreList : _schoolsFilteredFor;
              sortDataByMethod();
						});
					} else {
						print("The abbreviation '$abbr' does not exist");
					}
				}
			);
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
            throw("Sort column index $sortingBy is not supported");
        }
				if (compareResult == 0) {
					return a.uid.compareTo(b.uid); // Backup sort, UID is guaranteed unique
				}
        return sortAscending ? compareResult : -compareResult;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
			children: [
				Expanded(
					flex: 2,
					child: Card(
						child: Column(
						  children: [
						    const Text("This is the filter tab", textAlign: TextAlign.center,),
								Autocomplete<String>(
									optionsBuilder: (TextEditingValue textEditingValue) {
										if (textEditingValue.text == '') {
											return const Iterable<String>.empty();
										}
										return stateNames.where((String option) {
											return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
										});
									},
									onSelected: (String selection) {
										setState(() {
										  stateIsFilteredFor[stateNameToAbbreviations[selection]!] = true;
										  statesFilteredFor = _statesFilteredFor;
                      schoolsFilteredFor = statesFilteredFor.isEmpty ? scoreList : _schoolsFilteredFor;
                      sortDataByMethod();
										});
									},
								),
								Wrap(
									children: stateAbbreviations.map((abbr) {
										return Visibility(
        							visible: stateIsFilteredFor[abbr]!,
											child: stateNameTiles[abbr]!,
										);
									}).toList(),
								)
						  ],
						),
					),
				),
				const SizedBox(width: 30.0,),
				Expanded(
					flex: 5,
					child: Column(
						children: [
							Row(
								// children: [
								// 	Expanded(
								// 		flex: 9,
								// 		child: InkWell(
								// 			onTap: () => sortData('name'),
								// 			child: Text('Name', textAlign: TextAlign.center, style: textStyle),
								// 		),
								// 	),
								// 	Expanded(
								// 		flex: 2,
								// 		child: 
								// 		InkWell(
								// 			onTap: () => sortData('state'),
								// 			child: Text('State', textAlign: TextAlign.center, style: textStyle),
								// 		),
								// 	),
								// 	Expanded(
								// 		flex: 3,
								// 		child: InkWell(
								// 			onTap: () => sortData('studentPopulation'),
								// 			child: Text('Students', textAlign: TextAlign.center, style: textStyle),
								// 		),
								// 	),
								// ],
								children: List.generate(
									SchoolScoreRow.numColumns,
									(index) => Expanded(
										flex: SchoolScoreRow.flexValues[index],
										child: Padding(
											padding: const EdgeInsets.all(8.0),
											child: 
											TextButton(
												onPressed: () {sortData(index);},
												child: Text(SchoolScoreRow.columnNames[index]),
											)
											// Material(
											// 	elevation: 4.0, // Same as Card elevation
											// 	shape: RoundedRectangleBorder(
											// 		borderRadius: BorderRadius.circular(12.0), // Match Card's borderRadius
											// 	),
											// 	child: InkWell(
											// 		onTap: () {sortData(index);},
											// 		child: Card(
											// 			color: Colors.amber[200],
											// 			margin: EdgeInsets.zero,
														
											// 			child: Text(
											// 				SchoolScoreRow.columnNames[index],
											// 				style: textStyle,
											// 				textAlign: TextAlign.center,
											// 			),
											// 		),
											// 	),
											// ),
										),
									),
								),
							),
							Expanded(
								child: ListView.builder(
									itemCount: schoolsFilteredFor.length,
									itemBuilder: (context, index) {
										return SchoolScoreRow(school: schoolsFilteredFor[index]);
									},
								),
							),
						],
					),
				),
			],
		);
  }
}