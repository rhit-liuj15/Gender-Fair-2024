import 'package:flutter/material.dart';
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
  int selectedSchoolsCount = SchoolScore.selectedSchools.length;

  final Map<String, List<SchoolScore> Function(List<SchoolScore>)>
      filterFunctions = {};

  List<SchoolScore> scoreList = <SchoolScore>[];
  List<SchoolScore> schoolsFilteredFor = <SchoolScore>[];

  ListPageColumnAttributes sortingBy = ListPageColumnAttributes.total;
  bool sortDescending = ListPageColumnAttributes.total.sortDescending;

  final FocusNode filterTextFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      scoreList = DataLoader.instance.allSchoolScores.values.toList();
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

  void updateShownSchools() {
    setState(() {
      schoolsFilteredFor = scoreList;
      for (List<SchoolScore> Function(List<SchoolScore>) func
          in filterFunctions.values) {
        schoolsFilteredFor = func(schoolsFilteredFor);
      }
    });
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
          comparator = (a, b) => a.subscores[ListPageColumnAttributes
                  .listPageToSchoolScoreMapping[sortingBy]]!
              .compareTo(b.subscores[ListPageColumnAttributes
                  .listPageToSchoolScoreMapping[sortingBy]]!);
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
                const SizedBox(width: 30.0),
                SizedBox(
                  width: 85,
                  height: 100,
                  child: Image.asset(
                    'assets/logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 50.0),
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
                const SizedBox(width: 30.0),
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
                        selectedSchoolsCount:
                            SchoolScore.selectedSchools.length,
                        filterFunctions: filterFunctions,
                        updateShownSchools: updateShownSchools,
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
                        onUpdateSelected: updateShownSchools,
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
