class SchoolAcademicOfferings {
	/// The data class that stores which schools offer a particular level of the degree with [cipcode]

	String cipcode;
  final Map<int, Set<int>> _levelToUIDs = {};

	
  SchoolAcademicOfferings({
    required this.cipcode,
  });

	void addOffering({
		required int uid,
		required int level,
	}) {
		if (_levelToUIDs.containsKey(level)) {
			_levelToUIDs[level]!.add(uid);
		} else {
			_levelToUIDs[level] = <int>{uid};
		}
	}

	Set<int> schoolsOfferingCourseAtLevel({
		required int level,
	}) {
		return _levelToUIDs[level] ?? <int>{};
	}

	Set<int> levelsAvailableForMajor() {
		return _levelToUIDs.keys.toSet();
	}
}
