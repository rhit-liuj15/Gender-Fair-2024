import 'dart:convert';
import 'package:gender_fair_2024/models/school_data.dart';
import 'package:gender_fair_2024/models/school_score.dart';
import 'package:http/http.dart' as http;

class DataLoader {
	// I'm trying my best to guess this is how singleton works in flutter...
	Map<String,String> stateNameToAbbreviations = <String,String>{};
	Map<int,SchoolData> allSchools = <int,SchoolData>{};
	Map<int,SchoolScore> allScores = <int,SchoolScore>{};
	bool dataReady = false; // Change this back at some point
  static final DataLoader instance = DataLoader._privateConstructor();

  DataLoader._privateConstructor();

  // Method to load data asynchronously and populate stateNames
  Future<void> loadData() async {
		if (!dataReady) {
			// var url = Uri.http('genderfair2024.csse.rose-hulman.edu:80', 'states');
			// try {
			// 	final response = await http.get(url);
			// 	if (response.statusCode == 200) {
			// 		List<dynamic> data = jsonDecode(response.body);
			// 		stateNameToAbbreviations = <String,String>{};
			// 		for (var item in data) {
			// 			stateNameToAbbreviations[item['valueLabel']] = item['Codevalue'];
			// 		}
			// 		dataReady = true;
			// 	} else {
			// 		print('Failed to load data. HTTP Status Code: ${response.statusCode}');
			// 	}
			// } catch (e) {
			// 	print('Error occurred: $e');
			// }
			
			addSchooScore(SchoolScore(uid: 1826, schoolName: "UCLA", subscores: [17, 13, 9, 22]));
			addSchooScore(SchoolScore(uid: 7523, schoolName: "MIT", subscores: [20, 14, 29, 33]));
			addSchooScore(SchoolScore(uid: 4321, schoolName: "Stanford", subscores: [18, 12, 24, 30]));
			addSchooScore(SchoolScore(uid: 9876, schoolName: "Harvard", subscores: [15, 11, 27, 35]));
			addSchooScore(SchoolScore(uid: 2570, schoolName: "Yale", subscores: [19, 15, 30, 34]));
			addSchooScore(SchoolScore(uid: 6102, schoolName: "Caltech", subscores: [20, 13, 25, 31]));
			addSchooScore(SchoolScore(uid: 1745, schoolName: "Columbia", subscores: [16, 14, 28, 29]));
			addSchooScore(SchoolScore(uid: 7854, schoolName: "Princeton", subscores: [14, 13, 22, 33]));
			addSchooScore(SchoolScore(uid: 4398, schoolName: "UC Berkeley", subscores: [17, 12, 30, 32]));
			addSchooScore(SchoolScore(uid: 5962, schoolName: "University of Chicago", subscores: [18, 15, 29, 35]));
			addSchooScore(SchoolScore(uid: 7934, schoolName: "Duke", subscores: [16, 13, 26, 30]));
			addSchooScore(SchoolScore(uid: 1283, schoolName: "University of Michigan", subscores: [19, 14, 24, 29]));
			addSchooScore(SchoolScore(uid: 3429, schoolName: "NYU", subscores: [15, 12, 28, 34]));
			addSchooScore(SchoolScore(uid: 5901, schoolName: "University of Virginia", subscores: [20, 14, 30, 33]));
			addSchooScore(SchoolScore(uid: 8723, schoolName: "Brown University", subscores: [18, 12, 27, 31]));
			addSchooScore(SchoolScore(uid: 4395, schoolName: "University of Washington", subscores: [16, 13, 23, 28]));
			addSchooScore(SchoolScore(uid: 3810, schoolName: "Dartmouth", subscores: [17, 14, 22, 30]));
			addSchooScore(SchoolScore(uid: 6427, schoolName: "Cornell", subscores: [20, 15, 29, 35]));
			addSchooScore(SchoolScore(uid: 9284, schoolName: "University of Texas", subscores: [19, 11, 25, 31]));
			addSchooScore(SchoolScore(uid: 1762, schoolName: "University of Florida", subscores: [15, 12, 28, 32]));
			addSchooScore(SchoolScore(uid: 2548, schoolName: "Penn State", subscores: [14, 13, 27, 33]));
			addSchooScore(SchoolScore(uid: 8742, schoolName: "University of Wisconsin", subscores: [18, 14, 30, 34]));
			addSchooScore(SchoolScore(uid: 1203, schoolName: "Purdue", subscores: [19, 15, 24, 29]));
			addSchooScore(SchoolScore(uid: 3619, schoolName: "Northwestern", subscores: [17, 12, 26, 32]));
			addSchooScore(SchoolScore(uid: 4623, schoolName: "University of Illinois", subscores: [20, 14, 30, 35]));
			addSchooScore(SchoolScore(uid: 5310, schoolName: "Emory University", subscores: [16, 11, 28, 30]));
			addSchooScore(SchoolScore(uid: 8937, schoolName: "Georgetown", subscores: [15, 13, 27, 31]));
			addSchooScore(SchoolScore(uid: 7495, schoolName: "Vanderbilt", subscores: [19, 14, 29, 34]));
			addSchooScore(SchoolScore(uid: 2043, schoolName: "Rice University", subscores: [20, 13, 25, 28]));
			addSchooScore(SchoolScore(uid: 3197, schoolName: "University of Minnesota", subscores: [18, 12, 30, 33]));
			addSchooScore(SchoolScore(uid: 6541, schoolName: "Boston University", subscores: [17, 14, 28, 31]));
			addSchooScore(SchoolScore(uid: 4538, schoolName: "University of Rochester", subscores: [14, 12, 23, 29]));
			addSchooScore(SchoolScore(uid: 2983, schoolName: "Carnegie Mellon", subscores: [19, 13, 30, 35]));
			addSchooScore(SchoolScore(uid: 7029, schoolName: "University of Southern California", subscores: [20, 15, 29, 34]));
			addSchooScore(SchoolScore(uid: 4821, schoolName: "University of Arizona", subscores: [16, 14, 27, 32]));
			addSchooScore(SchoolScore(uid: 5198, schoolName: "University of Colorado", subscores: [15, 13, 26, 33]));
			addSchooScore(SchoolScore(uid: 6083, schoolName: "Georgia Tech", subscores: [20, 14, 30, 35]));
			addSchooScore(SchoolScore(uid: 9102, schoolName: "University of Utah", subscores: [18, 12, 24, 28]));
			addSchooScore(SchoolScore(uid: 1348, schoolName: "University of Oregon", subscores: [17, 14, 25, 30]));
			addSchooScore(SchoolScore(uid: 2349, schoolName: "Indiana University", subscores: [19, 13, 29, 31]));
			addSchooScore(SchoolScore(uid: 4587, schoolName: "University of Kansas", subscores: [16, 12, 27, 34]));
			addSchooScore(SchoolScore(uid: 7021, schoolName: "University of Miami", subscores: [14, 15, 28, 30]));
			addSchooScore(SchoolScore(uid: 3820, schoolName: "University of Alabama", subscores: [18, 14, 30, 32]));
			addSchooScore(SchoolScore(uid: 5794, schoolName: "University of Kentucky", subscores: [20, 13, 29, 33]));
			addSchooScore(SchoolScore(uid: 6041, schoolName: "University of Missouri", subscores: [15, 11, 26, 31]));
			addSchooScore(SchoolScore(uid: 8032, schoolName: "University of Nebraska", subscores: [19, 14, 30, 34]));
			addSchooScore(SchoolScore(uid: 9103, schoolName: "University of Oklahoma", subscores: [18, 12, 27, 29]));

			dataReady = true;
		}
  }

	void addSchooScore(SchoolScore score) {
		if (allScores.containsKey(score.uid)) {
			print("UID ${score.uid}} is shared by '${score.schoolName}' and '${allScores[score.uid]!.schoolName}'. The former is not added.");
		} else {
			allScores[score.uid] = score;
		}
	}
}

