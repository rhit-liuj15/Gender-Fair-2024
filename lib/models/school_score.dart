import 'package:gender_fair_2024/models/school_score_column_attributes.dart';

class SchoolScore {
	
	static final List<int> maximumValues = List.unmodifiable([20, 15, 30, 35]);
  static final Map<SchoolScoreColumnAttributes, int> maximumScores = Map.unmodifiable({
		SchoolScoreColumnAttributes.leadership: 35,
		SchoolScoreColumnAttributes.polnpay: 35,
		SchoolScoreColumnAttributes.safety: 15,
		SchoolScoreColumnAttributes.diversity: 15,
	});

  int rank = 0; 
	int uid;
  String schoolName;
  Map<SchoolScoreColumnAttributes, int> subscores;
	
	int get score => subscores.values.toList().reduce((a,b)=>a+b);

  SchoolScore({
		required this.uid,
    required this.schoolName,
    required this.subscores,
    this.rank = 0,
  }){
		if (scoreOutOfBounds(subscores)) {
			throw("The subscore entries for '$schoolName' exceeds specified limits: $subscores, $maximumValues");
		}
	}

	bool scoreOutOfBounds(Map<SchoolScoreColumnAttributes, int> val) {
		// Placeholder; usefulness to be contemplated.
		return false;
	}

  @override
  String toString() {
    return "The school $schoolName (UID $uid}) has scores $subscores";
  }
}
