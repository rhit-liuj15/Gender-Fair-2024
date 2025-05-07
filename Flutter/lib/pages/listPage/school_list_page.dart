import 'package:flutter/material.dart';
import 'package:gender_fair_2024/models/mutable_value_notifier.dart';
import 'package:gender_fair_2024/pages/listPage/listPane/school_score_row.dart';
import 'package:gender_fair_2024/models/school_score.dart';
import 'package:gender_fair_2024/models/data_loader.dart';
import 'package:gender_fair_2024/models/list_page_column_attributes.dart';

import 'filterPane/filter_and_compare_pane.dart';
import 'listPane/school_list_pane.dart';

class SchoolListPage extends StatefulWidget {
  const SchoolListPage({super.key});

  @override
  State<SchoolListPage> createState() => _SchoolListPageState();
}

class _SchoolListPageState extends State<SchoolListPage> {
  final int schoolsPerPage = 20;
  int selectedSchoolsCount = SchoolScore.selectedSchools.length;

  final Map<String, List<SchoolScore> Function(List<SchoolScore>)> filterFunctions = {};
  final Map<String, Function()> filterResetCallbacks = {};

  List<SchoolScore> scoreList = <SchoolScore>[];
	MutableValueNotifier<List<SchoolScore>> schoolsFilteredFor = MutableValueNotifier<List<SchoolScore>>(<SchoolScore>[]);

  ListPageColumnAttributes sortingBy = ListPageColumnAttributes.total;
  bool sortDescending = ListPageColumnAttributes.total.sortDescending;

  final FocusNode filterTextFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
		scoreList = DataLoader.instance.allSchoolScores.values.toList();
		schoolsFilteredFor.value = List.from(scoreList);
		sortData();
  }

  void updateSortMetric(ListPageColumnAttributes column) {
    if (sortingBy != column) {
      sortingBy = column;
      sortDescending = SchoolScoreRow.defaultSortOrder[column]!;
    	sortData();
    }
		// Otherwise, the same element has been selected. The website won't need to respond in that case.
  }

  void invertSort() {
		sortDescending = !sortDescending;
		sortData();
  }

  void updateFilter({
		required String name,
		required List<SchoolScore> Function(List<SchoolScore>) filterFunction,
		required Function() resetCallback,
	}) {
		filterFunctions[name] = filterFunction;
		filterResetCallbacks[name] = resetCallback;
    updateShownSchools();
  }

  void removeFilter({
		required String name,
	}) {
		filterFunctions.remove(name);
		filterResetCallbacks.remove(name);
    updateShownSchools();
  }

  void clearAllFilters() {
		filterResetCallbacks.forEach((key, value) {
		  value();
		});
		filterFunctions.clear();
		filterResetCallbacks.clear();
    updateShownSchools();
  }

  void clearSchoolSelection() {
		
		SchoolScore.selectedSchools.clear();
    updateShownSchools();
  }

  void updateShownSchools() {
		schoolsFilteredFor.value = scoreList;
		for (List<SchoolScore> Function(List<SchoolScore>) func
				in filterFunctions.values) {
			schoolsFilteredFor.value = func(schoolsFilteredFor.value);
		}
    sortData();
  }

  void sortData() {
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
		schoolsFilteredFor.value.sort((a, b) {
			int compareResult = comparator(a, b);
			if (compareResult == 0) {
				compareResult = a.score.compareTo(b.score);
			}
			return sortDescending ? -compareResult : compareResult;
		});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40.0,
                  vertical: 10.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: FilterAndComparePane(
                        selectedSchoolsCount:
                            SchoolScore.selectedSchools.length,
												updateFilterCallback: updateFilter,
												removeFilterCallback: removeFilter,
                        clearAllCallback: clearAllFilters,
                        clearSchoolSelection: clearSchoolSelection,
                      ),
                    ),
                    const SizedBox(width: 30.0),
                    Expanded(
                      flex: 5,
                      child: SchoolListPane(
                        updateSortingMetricCallback: updateSortMetric,
                        invertSortCallback: invertSort,
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