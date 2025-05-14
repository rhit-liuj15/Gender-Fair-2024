class SelectedSchools {
  final Set<int> selectedSchools = <int>{};
  final Map<String, Function()> selectedSchooslListChangeCallbacks = {};
	
  static final SelectedSchools instance = SelectedSchools._privateConstructor();
  SelectedSchools._privateConstructor();

	void addSelectedSchoolsListListener({
    required String name,
    required Function() callback,
  }) {
    SelectedSchools.instance.selectedSchooslListChangeCallbacks[name] = callback;
  }
	
	void removeSelectedSchoolsListListener({
    required String name,
  }) {
    SelectedSchools.instance.selectedSchooslListChangeCallbacks.remove(name);
  }
	

  void applySelectedSchoolChange() {
		selectedSchooslListChangeCallbacks.forEach((key, value) => value());
  }

  void clearSchoolSelection() {
    selectedSchools.clear();
		applySelectedSchoolChange();
  }
}
