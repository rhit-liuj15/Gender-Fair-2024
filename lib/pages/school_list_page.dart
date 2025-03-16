import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:gender_fair_2024/components/filter_state_name_tile.dart';
import 'package:gender_fair_2024/components/school_score_row.dart';
import 'package:gender_fair_2024/models/school_score.dart';
import 'package:gender_fair_2024/models/data_loader.dart';
import 'package:gender_fair_2024/models/list_page_column_attributes.dart';

import '../components/filter_and_compare_pane.dart';
import '../components/school_list_pane.dart';

class SchoolListPage extends StatefulWidget {
  const SchoolListPage({super.key});

  @override
  State<SchoolListPage> createState() => _SchoolListPageState();
}

class _SchoolListPageState extends State<SchoolListPage> {
  // int _hoveredColumnIndex = -1;
  final int schoolsPerPage = 20;
  int selectedSchoolsCount = SchoolScoreRow.selectedSchools.length;

	bool showOnlySelectedSchools= false;
  List<SchoolScore> scoreList = <SchoolScore>[];
  List<SchoolScore> schoolsFilteredFor = <SchoolScore>[];

  List<String> stateNames = <String>[];
  List<String> stateAbbreviations = <String>[];
  List<String> filteringStates = <String>[];
  Map<String, String> stateNameToAbbreviations = <String, String>{};
  ListPageColumnAttributes sortingBy = ListPageColumnAttributes.total;
  bool sortDescending = ListPageColumnAttributes.total.sortDescending;

  Map<String, FilterTextTile> stateNameTiles = <String, FilterTextTile>{};
  Map<String, bool> stateIsFilteredFor = <String, bool>{};
  List<String> statesFilteredFor = <String>[];

  final TextStyle textStyle = const TextStyle(fontSize: 18.0);
  final TextEditingController filterTextEditingController =
      TextEditingController();
  final FocusNode filterTextFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await DataLoader.instance.loadData();
    setState(() {
      scoreList = DataLoader.instance.allScores.values.toList();
      stateNameToAbbreviations = DataLoader.instance.stateNameToAbbreviations;
      schoolsFilteredFor = List.from(scoreList);
      sortData();
    });
  }

  void updateSortMetric(ListPageColumnAttributes column) {
		if (sortingBy == column) {
			sortDescending = !sortDescending;
		} else {
			sortingBy = column;
			sortDescending = SchoolScoreRow.defaultSortOrder[column]!;
		}
		sortData();
	}

  void sortData() {
    setState(() {
      Comparator<SchoolScore> comparator;
      switch (sortingBy) {
        case ListPageColumnAttributes.instName:
          comparator = (a, b) => a.schoolName.compareTo(b.schoolName);
          break;

        case ListPageColumnAttributes.ranking:
        case ListPageColumnAttributes.total:
          comparator = (a, b) => a.score.compareTo(b.score);
          break;
					
				case ListPageColumnAttributes.leadership:
				case ListPageColumnAttributes.polnpay:
				case ListPageColumnAttributes.safety:
				case ListPageColumnAttributes.diversity:
          comparator = (a, b) => a.subscores[ListPageColumnAttributes.listPageToSchoolScoreMapping[sortingBy]]!
							.compareTo(b.subscores[ListPageColumnAttributes.listPageToSchoolScoreMapping[sortingBy]]!);
          break;
        default:
          if (sortingBy.sortable) {
            comparator = (a, b) => 0; // No sorting needed
          } else {
            throw ("Sort column '$sortingBy' is not supported");
          }
      }
      schoolsFilteredFor.sort((a, b) {
        int compareResult = comparator(a, b);
        if (compareResult == 0) {
          compareResult = a.score.compareTo(b.score);
        }
        return sortDescending ? -compareResult : compareResult;
      });
    });
  }

  void updateSelectedCount(int count) {
    setState(() {
      selectedSchoolsCount = count;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top header
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 50.0, vertical: 10.0),
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
                      Text(
                        "School Ranking System",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Flexible(
                        child: Text(
                          "The GenderFair Ranking system evaluates colleges and universities based on gender equity, providing transparency on institutional fairness through data-driven insights. By integrating national databases, It empower prospective students to make informed decisions aligned with their values. Currently, schools with identical rank and score are treated as having equal standing.",
                          style: TextStyle(
                            fontSize: 16.0,
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 10.0,
                ),
                child: Row(
                  children: [
                    // Left pane: filter, compare
                    Expanded(
                      flex: 2,
                      child: FilterAndComparePane(
                        filterTextEditingController:
                            filterTextEditingController,
                        stateAbbreviations: stateAbbreviations,
                        stateIsFilteredFor: stateIsFilteredFor,
                        stateNameTiles: stateNameTiles,
                        selectedSchoolsCount:
                            SchoolScoreRow.selectedSchools.length,
                        onSearchChange: (value) {
                          setState(() {
														schoolsFilteredFor = showOnlySelectedSchools ? scoreList.where((item) => SchoolScoreRow.selectedSchools.contains(item.uid)).toList() : scoreList;
                            if (value.isNotEmpty) {
                              schoolsFilteredFor = schoolsFilteredFor
                                  .where((school) => school.schoolName
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                  .toList();
                            }
                            sortData();
                          });
                        },
												showOnlySelected: showOnlySelectedSchools,
												onShowOnlySelectedToggle: (bool? newValue) {
													setState(() {
														showOnlySelectedSchools = newValue!;
														schoolsFilteredFor = showOnlySelectedSchools ? scoreList.where((item) => SchoolScoreRow.selectedSchools.contains(item.uid)).toList() : scoreList;
                            sortData();
													});
												},
                      ),
                    ),

                    const SizedBox(width: 30.0),

                    Expanded(
                      flex: 5,
                      child: SchoolListPane(
                        updateSortingMetricCallback: updateSortMetric,
												sortingMetric: sortingBy,
                        updateSortCallback: sortData,
                        schoolsFilteredFor: schoolsFilteredFor,
                        schoolsPerPage: schoolsPerPage,
                        onUpdateSelectedCount: updateSelectedCount,
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
