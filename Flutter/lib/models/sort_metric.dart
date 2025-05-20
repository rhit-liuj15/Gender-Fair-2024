import 'package:gender_fair_2024/models/list_page_column_attributes.dart';
import 'package:gender_fair_2024/models/school_score.dart';
import 'package:gender_fair_2024/pages/listPage/listPane/components/school_score_row.dart';

class SortMetric {
  final Map<String, Function()> _sortMetricChangeCallback = {};
	
  ListPageColumnAttributes sortMetric = ListPageColumnAttributes.total;
  bool sortDescending = ListPageColumnAttributes.total.sortDescending;

  static final SortMetric instance = SortMetric._privateConstructor();
  SortMetric._privateConstructor();

	void addSortMetricChangeCallback({
    required String name,
    required Function() callback,
  }) {
    _sortMetricChangeCallback[name] = callback;
  }
	
	void removeSortMetricChangeCallback({
    required String name,
  }) {
    _sortMetricChangeCallback.remove(name);
  }
	
  void applySortMetric() {
		_sortMetricChangeCallback.forEach((key, value) => value());
  }

  void updateSortMetric(ListPageColumnAttributes column) {
    if (sortMetric != column) {
      sortMetric = column;
      sortDescending = SchoolScoreRow.defaultSortOrder[column]!;
			applySortMetric();
    }
    // Otherwise, the same element has been selected. The website won't need to respond in that case.
  }
	
  void invertSort() {
    sortDescending = !sortDescending;
		applySortMetric();
  }

  List<SchoolScore> sortSchools(List<SchoolScore> unsortedSchools) {
    Comparator<SchoolScore> comparator;
    switch (sortMetric) {
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
                .listPageToSchoolScoreMapping[sortMetric]]!
            .compareTo(b.subscores[ListPageColumnAttributes
                .listPageToSchoolScoreMapping[sortMetric]]!);
        break;
      default:
        if (sortMetric.sortable) {
          comparator = (a, b) => 0; // No sorting needed
        } else {
          throw ("Sort column '$sortMetric' is not supported");
        }
    }
    unsortedSchools.sort((a, b) {
      int compareResult = comparator(a, b);
			compareResult = sortDescending ? -compareResult : compareResult;
      if (compareResult == 0) {
        compareResult = -(a.score.compareTo(b.score));
				if (compareResult == 0) {
					compareResult = a.schoolName.compareTo(b.schoolName);
				}
      }
      return compareResult;
    });
		return unsortedSchools;
  }
}
