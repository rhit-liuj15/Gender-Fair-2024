import 'package:gender_fair_2024/models/school_score.dart';

interface class FilterWidget {
  final void Function({
		required List<SchoolScore> Function(List<SchoolScore>) filterFunction,
		required String name,
		required dynamic Function() resetCallback,
	}) updateFilterCallback;
  final Function({required String name}) removeFilterCallback;
	
  const FilterWidget({
    required this.updateFilterCallback,
    required this.removeFilterCallback,
  });
}