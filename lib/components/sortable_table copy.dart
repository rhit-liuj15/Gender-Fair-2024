
// import 'package:flutter/material.dart';
// import 'package:gender_fair_2024/components/filter_page_state_name_tile.dart';
// import 'package:gender_fair_2024/models/school_data.dart';
// import 'package:gender_fair_2024/models/state_names_data.dart';

// class SortableTable extends StatefulWidget {
//   const SortableTable({super.key});

//   @override
//   _SortableTableState createState() => _SortableTableState();
// }

// class _SortableTableState extends State<SortableTable> {
//   List<SchoolData> schoolList = <SchoolData>[];

// 	List<SchoolData> schoolsFilteredFor = <SchoolData>[];
// 	List<SchoolData> get _schoolsFilteredFor {
// 		return schoolList.where((data) => statesFilteredFor.contains(data.schoolStateInitials)).toList();
// 	}
//   List<String> stateNames = <String>[];
//   List<String> get _stateNames {
// 		return stateNameToAbbreviations.keys.toList();
// 	}
	
//   List<String> stateAbbreviations = <String>[];
//   List<String> get _stateAbbreviations {
// 		return stateNameToAbbreviations.values.toList();
// 	}

// 	List<String> filteringStates = <String>[];
//   Map<String,String> stateNameToAbbreviations = <String,String>{};
// 	int sortingBy = -1; // Sorting by name: 0, state: 1, student population: 2
// 	bool sortAscending = true;

// 	Map<String,FilterPageStateNameTile> stateNameTiles = <String,FilterPageStateNameTile>{};
// 	Map<String,bool> stateIsFilteredFor = <String,bool>{};
// 	List<String> statesFilteredFor = <String>[];
// 	List<String> get _statesFilteredFor {
// 		return stateIsFilteredFor.entries.where((entry) => entry.value == true).map((entry) => entry.key).toList();
// 	}

// 	final TextStyle textStyle = const TextStyle(fontSize: 18.0);

// 	@override
//   void initState() {
//     super.initState();
//     loadData();
//   }

//   // Asynchronously load data from the singleton instance
//   Future<void> loadData() async {
//     await AllSchoolData.instance.loadData();
//     await StateNamesData.instance.loadData();
//     setState(() {
//       schoolList = AllSchoolData.instance.allSchools;
//       stateNameToAbbreviations = StateNamesData.instance.stateNameToAbbreviations;
//     });
//     stateNames = _stateNames;
//     stateAbbreviations = _stateAbbreviations;
//     statesFilteredFor = _statesFilteredFor;
//     schoolsFilteredFor = statesFilteredFor.isEmpty ? schoolList : _schoolsFilteredFor;
//     sortDataByExistingMethod();
// 	populateStateNameTiles();
//   }

// 	void populateStateNameTiles() {
// 		for (String name in stateNames) {
// 			String abbr = stateNameToAbbreviations[name]!;
// 			stateIsFilteredFor[abbr] = false;
// 			stateNameTiles[abbr] = FilterPageStateNameTile(
// 				state: name,
// 				removeStateCallback: () {
// 					if (stateIsFilteredFor.containsKey(abbr)) {
// 						setState(() {
// 							stateIsFilteredFor[abbr] = false;
//               statesFilteredFor = _statesFilteredFor;
//               schoolsFilteredFor = statesFilteredFor.isEmpty ? schoolList : _schoolsFilteredFor;
//               sortDataByExistingMethod();
// 						});
// 					} else {
// 						print("The abbreviation '$abbr' does not exist");
// 					}
// 				}
// 			);
// 		}
// 	}

//   void sortData(String attribute) {
//     setState(() {
// 			switch (attribute) {
// 				case 'name':
// 					if (sortingBy == 0) {
// 						sortAscending = !sortAscending;
// 					} else {
// 						sortingBy = 0;
// 						sortAscending = true;
// 					}
// 					break;
// 				case 'state':
// 					if (sortingBy == 1) {
// 						sortAscending = !sortAscending;
// 					} else {
// 						sortingBy = 1;
// 						sortAscending = true;
// 					}
// 					break;
// 				case 'studentPopulation':
// 					if (sortingBy == 2) {
// 						sortAscending = !sortAscending;
// 					} else {
// 						sortingBy = 2;
// 						sortAscending = false;
// 					}
// 					break;
// 				case 'uid':
// 					sortingBy = -1;
// 					sortAscending = true;
// 				default:
// 					throw("The attribute '$attribute' is not supported by the SortableTable");
// 			}
//       schoolsFilteredFor.sort((a, b) {
//         int compareResult;
//         switch (attribute) {
//           case 'name':
//             compareResult = a.schoolName.compareTo(b.schoolName);
//             break;
//           case 'state':
//             compareResult = a.schoolStateInitials.compareTo(b.schoolStateInitials);
//             break;
//           case 'studentPopulation':
//             compareResult = a.studentPopulation.compareTo(b.studentPopulation);
//             break;
//           case 'uid':
//             compareResult = a.uid.compareTo(b.uid);
//             break;
//           default:
//             throw("The attribute '$attribute' is not supported by the SortableTable");
//         }
// 				if (compareResult == 0) {
// 					return a.uid.compareTo(b.uid); // Backup sort, UID is guaranteed unique
// 				}
//         return sortAscending ? compareResult : -compareResult;
//       });
//     });
//   }

//   void sortDataByExistingMethod() {
//     setState(() {
//       schoolsFilteredFor.sort((a, b) {
//         int compareResult;
//         switch (sortingBy) {
//           case 0:
//             compareResult = a.schoolName.compareTo(b.schoolName);
//             break;
//           case 1:
//             compareResult = a.schoolStateInitials.compareTo(b.schoolStateInitials);
//             break;
//           case 2:
//             compareResult = a.studentPopulation.compareTo(b.studentPopulation);
//             break;
//           case -1:
//             compareResult = a.uid.compareTo(b.uid);
//             break;
//           default:
//             throw("Sort column index $sortingBy is not supported");
//         }
// 				if (compareResult == 0) {
// 					return a.uid.compareTo(b.uid); // Backup sort, UID is guaranteed unique
// 				}
//         return sortAscending ? compareResult : -compareResult;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
// 			children: [
// 				Expanded(
// 					flex: 2,
// 					child: Card(
// 						child: Column(
// 						  children: [
// 						    const Text("This is the filter tab", textAlign: TextAlign.center,),
// 								Autocomplete<String>(
// 									optionsBuilder: (TextEditingValue textEditingValue) {
// 										if (textEditingValue.text == '') {
// 											return const Iterable<String>.empty();
// 										}
// 										return stateNames.where((String option) {
// 											return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
// 										});
// 									},
// 									onSelected: (String selection) {
// 										setState(() {
// 										  stateIsFilteredFor[stateNameToAbbreviations[selection]!] = true;
// 										  statesFilteredFor = _statesFilteredFor;
//                       schoolsFilteredFor = statesFilteredFor.isEmpty ? schoolList : _schoolsFilteredFor;
//                       sortDataByExistingMethod();
// 										});
// 									},
// 								),
// 								Wrap(
// 									children: stateAbbreviations.map((abbr) {
// 										return Visibility(
//         							visible: stateIsFilteredFor[abbr]!,
// 											child: stateNameTiles[abbr]!,
// 										);
// 									}).toList(),
// 								)
// 						  ],
// 						),
// 					),
// 				),
// 				const SizedBox(width: 30.0,),
// 				Expanded(
// 					flex: 5,
// 					child: Column(
// 						children: [
// 							Row(
// 								// children: [
// 								// 	Expanded(
// 								// 		flex: 9,
// 								// 		child: InkWell(
// 								// 			onTap: () => sortData('name'),
// 								// 			child: Text('Name', textAlign: TextAlign.center, style: textStyle),
// 								// 		),
// 								// 	),
// 								// 	Expanded(
// 								// 		flex: 2,
// 								// 		child: 
// 								// 		InkWell(
// 								// 			onTap: () => sortData('state'),
// 								// 			child: Text('State', textAlign: TextAlign.center, style: textStyle),
// 								// 		),
// 								// 	),
// 								// 	Expanded(
// 								// 		flex: 3,
// 								// 		child: InkWell(
// 								// 			onTap: () => sortData('studentPopulation'),
// 								// 			child: Text('Students', textAlign: TextAlign.center, style: textStyle),
// 								// 		),
// 								// 	),
// 								// ],
// 								children: List.generate(
// 									SchoolDataRow.numColumns,
// 									(index) => Expanded(
// 										flex: SchoolDataRow.flexValues[index],
// 										child: Text(
// 											SchoolDataRow.columnNames[index],
// 											style: textStyle,
// 											textAlign: TextAlign.end,
// 										),
// 									),
// 								),
// 							),
// 							Expanded(
// 								child: ListView.builder(
// 									itemCount: schoolsFilteredFor.length,
// 									itemBuilder: (context, index) {
// 										return SchoolDataRow(school: schoolsFilteredFor[index]);
// 									},
// 								),
// 							),
// 						],
// 					),
// 				),
// 			],
// 		);
//   }
// }