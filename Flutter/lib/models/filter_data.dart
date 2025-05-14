import 'package:gender_fair_2024/models/metadata.dart';
import 'package:gender_fair_2024/models/school_score.dart';

class FilterData {
  final Map<String, List<SchoolScore> Function(List<SchoolScore>)>
      filterFunctions = {};

	// These Maps are separate due to their intended functionality:
	// filterResetCallbacks are provided by the filters as an instruction on how to reset the data
	// and only if there is data being displayed, will that widget separately provide a widgetRebuildCallbacks
	// to notify itself to rebuild.
	// schoolListChangeCallbacks is created such that selected schools aren't updated or reset along
	// with regular filters; instead, they get reset when 
  final Map<String, Function()> filterResetCallbacks = {};
  final Map<String, Function()> widgetRebuildCallbacks = {};
  final Map<String, Function()> schoolListChangeCallbacks = {};

	// Variables used by school name "filter"
	String schoolNameInput = "";

	// Variables used by show only selected schools "filter"
	bool showOnlySelected = false;

  // Variables used by state filter
  final Set<String> selectedStates = <String>{};

  // Variables used by public/private filter
  final Map<String, String> schoolCategories =
      Metadata.instance.getMetadataCategory(2).metadataPairs;
  final Map<String, bool> showSchoolCategories =
      Metadata.instance.getMetadataCategory(2).metadataPairs.map<String, bool>(
            (key, value) => MapEntry(key, false),
          );

	// Variables used by major/level filter
  Map<String, Set<int>> selectedLevelsByCIPCODE = <String, Set<int>>{};



  static final FilterData instance = FilterData._privateConstructor();

  FilterData._privateConstructor();

  void registerFilter({
    required String name,
    required List<SchoolScore> Function(List<SchoolScore>) filterFunction,
  }) {
    filterFunctions[name] = filterFunction;
  }

  void registerResetCallback({
    required String name,
    required Function() resetCallback,
  }) {
    filterResetCallbacks[name] = resetCallback;
  }

	void addRebuildCallback({
    required String name,
    required Function() rebuildCallback,
  }) {
    widgetRebuildCallbacks[name] = rebuildCallback;
  }
	
	void removeRebuildCallback({
    required String name,
  }) {
    widgetRebuildCallbacks.remove(name);
  }

	void addSchoolListListener({
    required String name,
    required Function() callback,
  }) {
    schoolListChangeCallbacks[name] = callback;
  }
	
	void removeSchoolListListener({
    required String name,
  }) {
    schoolListChangeCallbacks.remove(name);
  }
	
  void applyFilters() {
		schoolListChangeCallbacks.forEach((key, value) => value());
  }

  void clearFilters() {
    filterResetCallbacks.forEach((key, value) {
			print(key);
			value();
		});
    widgetRebuildCallbacks.forEach((key, value) {
			print(key);
			value();
		});
		applyFilters();
  }

  List<SchoolScore> filterSchools(List<SchoolScore> schools) {
    List<SchoolScore> schoolsFilteredFor = List.from(schools);
    for (MapEntry<String, List<SchoolScore> Function(List<SchoolScore>)> entry
        in filterFunctions.entries) {
      schoolsFilteredFor = entry.value(schoolsFilteredFor);
    }
    return schoolsFilteredFor;
  }
}
