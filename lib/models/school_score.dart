class SchoolScore {
	int uid;
  String schoolName;
  List<int> subscores;
	static final List<String> subscoreTitles = List.unmodifiable(["Leadership", "Policies & Pay", "Safety", "Diversity"]);
	static final List<int> maximumValues = List.unmodifiable([20, 15, 30, 35]);
  int rank = 0; 
	
	int get score => subscores.reduce((a,b) => a+b);

  SchoolScore({
		required this.uid,
    required this.schoolName,
    required this.subscores,
    this.rank = 0,
  }) {
		if (subscoreTitles.length != maximumValues.length) {
			throw("School subscore category specification has mismatched lengths");
		} else if (subscores.length != subscoreTitles.length) {
			throw("The subscore entry for '$schoolName' has mismatched length");
		} else if (!pairwiseWithinLimit(subscores, maximumValues)) {
			throw("The subscore entries for '$schoolName' exceeds specified limits: $subscores, $maximumValues");
		}
	}

	bool pairwiseWithinLimit(List<int> val, List<int> lim) {
		// Disabled checking for now until scores are ready
		// for (int i = 0; i < val.length; i++) {
		// 	if (val[i] > lim[i]) return false;
		// }
		return true;
	}

  @override
  String toString() {
    return "The school $schoolName (UID $uid}) has scores $subscores";
  }
}
