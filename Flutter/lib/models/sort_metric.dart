import 'package:gender_fair_2024/models/list_page_column_attributes.dart';
import 'package:gender_fair_2024/models/school_data.dart';
import 'package:gender_fair_2024/pages/listPane/components/school_data_row.dart';

class SortMetric {
  final Map<String, Function()> _sortMetricChangeCallback = {};
	
  ListPageColumnAttributes sortMetric = ListPageColumnAttributes.instName;
  bool sortDescending = false;

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
      sortDescending = SchoolDataRow.defaultSortOrder[column]!;
			applySortMetric();
    }
    // Otherwise, the same element has been selected. The website won't need to respond in that case.
  }
	
  void invertSort() {
    sortDescending = !sortDescending;
		applySortMetric();
  }

  List<SchoolData> sortSchools(List<SchoolData> unsortedSchools) {
    Comparator<SchoolData> comparator;
    switch (sortMetric) {
      case ListPageColumnAttributes.instName:
        comparator = (a, b) => a.getName().compareTo(b.getName());
        break;
			// default:
      //   comparator = (a, b) => a.getName().compareTo(b.getName());
			// 	print("Only sorting by school name is supported");
    }
    unsortedSchools.sort((a, b) {
      int compareResult = comparator(a, b);
			compareResult = sortDescending ? -compareResult : compareResult;
			if (compareResult == 0) {
				compareResult = a.getUID().compareTo(b.getUID());
			}
      return compareResult;
    });
		return unsortedSchools;
  }
}
