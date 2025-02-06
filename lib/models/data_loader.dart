import 'dart:convert';
import 'package:gender_fair_2024/models/school_score_column_attributes.dart';
import 'package:http/http.dart' as https;
import 'package:gender_fair_2024/models/school_data.dart';
import 'package:gender_fair_2024/models/school_score.dart';

class DataLoader {
  // I'm trying my best to guess this is how singleton works in flutter...
  Map<String, String> stateNameToAbbreviations = <String, String>{};
  Map<int, SchoolData> allSchools = <int, SchoolData>{};
  Map<int, SchoolScore> allScores = <int, SchoolScore>{};
  // The reason these two are separate is that I plan to load all scores up front, but only request school's full details when necessary.
  bool _dataReady = false;
  static final DataLoader instance = DataLoader._privateConstructor();

  DataLoader._privateConstructor();

  void computeRankings() {
  List<SchoolScore> sortedScores = allScores.values.toList();
  sortedScores.sort((a, b) => b.score.compareTo(a.score)); 

  int rank = 1; 
  int rangeStart = 1; 
  List<String> rankRanges = []; 

  for (int i = 0; i < sortedScores.length; i++) {
    if (i > 0 && sortedScores[i].score == sortedScores[i - 1].score) {
      rangeStart = sortedScores[i - 1].rank;
    } else {
      rank = i + 1;
      rangeStart = rank;
    }
    
    if (i == sortedScores.length - 1 || sortedScores[i].score != sortedScores[i + 1].score) {
      rankRanges.add("$rangeStart-$rank");
      rangeStart = rank + 1; 
    }

    sortedScores[i].rank = rank;
  }
}


 Future<void> loadData() async {
  if (!_dataReady) {
    var scoreUrl = Uri.https('genderfair2024.csse.rose-hulman.edu', 'score');
    try {
      final response = await https.get(scoreUrl);
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        for (var item in data) {
          allScores[item['UNITID']] = SchoolScore(
            uid: item['UNITID'],
            schoolName: item['INSTNM'],
            subscores: Map.unmodifiable({
							SchoolScoreColumnAttributes.leadership: item['LEADERSHIP'],
							SchoolScoreColumnAttributes.polnpay: item['POLICIES'],
							SchoolScoreColumnAttributes.safety: item['SAFETY'],
							SchoolScoreColumnAttributes.diversity: item['DIVERSITY'],
						}),
          );
        }
        computeRankings();
        _dataReady = true;
      } else {
        print('Failed to load data. HTTP Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }
}


  void addSchoolData(SchoolData data) {
    if (allSchools.containsKey(data.uid)) {
      print(
          "UID ${data.uid} is shared by '${data.schoolName}' and '${allScores[data.uid]!.schoolName}'. The former is not added to allSchools.");
    } else {
      allSchools[data.uid] = data;
    }
  }

  Future<void> requestSchoolData(Set<int> uids) async {
    // This is to be expanded later with an actual request
		Set<int> notPresentData = uids.difference(allSchools.keys.toSet());
		print("UIDS ${allSchools.keys.toSet().intersection(uids)} already exist in data");
		if (notPresentData.isNotEmpty) {
			String fetchUIDs = notPresentData.join(',');
			var dataUrl = Uri.https('genderfair2024.csse.rose-hulman.edu', 'data', {'uids': fetchUIDs});
			print("Making a request for UIDs $fetchUIDs");
			print(dataUrl);
			try {
				final https.Response response = await https.get(dataUrl);
				if (response.statusCode == 200) {
					List<dynamic> data = jsonDecode(response.body);
					for (var item in data) {
						addSchoolData(SchoolData.fromJSON(item));
					}
					_dataReady = true;
				} else {
					print('Failed to load data. HTTP Status Code: ${response.statusCode}');
				}
			} catch (e) {
				print('Error occurred: $e');
			}
		}
  }
}
