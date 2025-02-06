import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:gender_fair_2024/components/filter_state_name_tile.dart';
import 'package:gender_fair_2024/components/school_score_row.dart';
import 'package:gender_fair_2024/models/school_score.dart';
import 'package:gender_fair_2024/models/data_loader.dart';
import 'package:gender_fair_2024/models/school_score_column_attributes.dart';
import 'package:gender_fair_2024/pages/school_comparison_page.dart';

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

  List<SchoolScore> scoreList = <SchoolScore>[];
  List<SchoolScore> schoolsFilteredFor = <SchoolScore>[];

  List<String> stateNames = <String>[];
  List<String> stateAbbreviations = <String>[];
  List<String> filteringStates = <String>[];
  Map<String, String> stateNameToAbbreviations = <String, String>{};
  SchoolScoreColumnAttributes sortingBy = SchoolScoreColumnAttributes.total;
  bool sortDescending = SchoolScoreColumnAttributes.total.sortDescending;

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

  void updateSortMetric(SchoolScoreColumnAttributes column) {
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
        case SchoolScoreColumnAttributes.instName:
          comparator = (a, b) => a.schoolName.compareTo(b.schoolName);
          break;

        case SchoolScoreColumnAttributes.ranking:
        case SchoolScoreColumnAttributes.total:
          comparator = (a, b) => a.score.compareTo(b.score);
          break;
					
				case SchoolScoreColumnAttributes.leadership:
				case SchoolScoreColumnAttributes.polnpay:
				case SchoolScoreColumnAttributes.safety:
				case SchoolScoreColumnAttributes.diversity:
          comparator = (a, b) => a.subscores[sortingBy]!.compareTo(b.subscores[sortingBy]!);
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
          compareResult = a.rank.compareTo(b.rank);
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
                            fontSize: 30.0,
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
                            if (value.isEmpty) {
                              schoolsFilteredFor = List.from(scoreList);
                            } else {
                              schoolsFilteredFor = scoreList
                                  .where((school) => school.schoolName
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                  .toList();
                            }
                            sortData();
                          });
                        },
                        onComparePressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) =>
                                const SchoolComparisonPage(),
                          );
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
