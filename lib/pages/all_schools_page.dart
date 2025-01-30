import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:gender_fair_2024/components/filter_state_name_tile.dart';
import 'package:gender_fair_2024/components/school_score_row.dart';
import 'package:gender_fair_2024/models/school_score.dart';
import 'package:gender_fair_2024/models/data_loader.dart';
import 'package:gender_fair_2024/pages/school_comparison_page.dart';

import 'filter_and_compare_pane.dart';
import 'school_list_pane.dart';

class AllSchoolsPage extends StatefulWidget {
  const AllSchoolsPage({super.key});

  @override
  State<AllSchoolsPage> createState() => _AllSchoolsPageState();
}

class _AllSchoolsPageState extends State<AllSchoolsPage> {
  int _hoveredColumnIndex = -1;
  int currentPage = 1;
  final int schoolsPerPage = 20;

  List<SchoolScore> scoreList = <SchoolScore>[];
  List<SchoolScore> schoolsFilteredFor = <SchoolScore>[];

  List<String> stateNames = <String>[];
  List<String> stateAbbreviations = <String>[];
  List<String> filteringStates = <String>[];
  Map<String, String> stateNameToAbbreviations = <String, String>{};
  int sortingBy = 6;
  bool sortAscending = false;

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

  List<SchoolScore> get paginatedSchools {
    final startIndex = (currentPage - 1) * schoolsPerPage;
    final endIndex = startIndex + schoolsPerPage;
    return schoolsFilteredFor.sublist(
      startIndex,
      endIndex > schoolsFilteredFor.length ? schoolsFilteredFor.length : endIndex,
    );
  }

  Future<void> loadData() async {
    await DataLoader.instance.loadData();
    setState(() {
      scoreList = DataLoader.instance.allScores.values.toList();
      stateNameToAbbreviations = DataLoader.instance.stateNameToAbbreviations;
    });
    schoolsFilteredFor = scoreList;
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
            compareResult = b.score.compareTo(a.score);
            break;
          case 1:
            compareResult = a.schoolName.compareTo(b.schoolName);
            break;
          case 2:
            compareResult = a.subscores[0].compareTo(b.subscores[0]);
            break;
          case 3:
            compareResult = a.subscores[1].compareTo(b.subscores[1]);
            break;
          case 4:
            compareResult = a.subscores[2].compareTo(b.subscores[2]);
            break;
          case 5:
            compareResult = a.subscores[3].compareTo(b.subscores[3]);
            break;
          case 6:
            compareResult = a.score.compareTo(b.score);
            break;
          default:
            throw ("Sort column index $sortingBy is not supported");
        }
        if (compareResult == 0) {
          return a.uid.compareTo(b.uid);
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
          // Top header
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
                SizedBox(width: 10.0),
              ],
            ),
          ),

          // Main content row
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
                        filterTextEditingController: filterTextEditingController,
                        stateAbbreviations: stateAbbreviations,
                        stateIsFilteredFor: stateIsFilteredFor,
                        stateNameTiles: stateNameTiles,
                        onSearchChange: (value) {
                          setState(() {
                            currentPage = 1;
                            schoolsFilteredFor = scoreList
                                .where((school) => school.schoolName
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          });
                        },
                        onComparePressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SchoolComparisonPage(),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(width: 30.0),

                    // Right pane: sorting, list, pagination
                    Expanded(
                      flex: 5,
                      child: SchoolListPane(
                        sortingBy: sortingBy,
                        onSortByMethod: sortDataByMethod,
                        onUpdateSortingBy: (int newIndex) {
                          setState(() {
                            sortingBy = newIndex;
                            sortDataByMethod();
                          });
                        },
                        onSortData: sortData,
                        schoolsFilteredFor: schoolsFilteredFor,
                        paginatedSchools: paginatedSchools,
                        currentPage: currentPage,
                        schoolsPerPage: schoolsPerPage,
                        onPageChange: (int newPage) {
                          setState(() {
                            currentPage = newPage;
                          });
                        },
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
