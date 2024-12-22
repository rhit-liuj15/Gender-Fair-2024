import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gender_fair_2024/models/school_data.dart';
import 'package:gender_fair_2024/models/school_score.dart';

class DataLoader {
	// I'm trying my best to guess this is how singleton works in flutter...
	Map<String,String> stateNameToAbbreviations = <String,String>{};
	Map<int,SchoolData> allSchools = <int,SchoolData>{};
	Map<int,SchoolScore> allScores = <int,SchoolScore>{};
	// The reason these two are separate is that I plan to load all scores up front, but only request school's full details when necessary.
	bool dataReady = false;
  static final DataLoader instance = DataLoader._privateConstructor();

  DataLoader._privateConstructor();

  Future<void> loadData() async {
		if (!dataReady) {
			// var stateNamesUrl = Uri.http('10.0.0.48:4800', 'states');
			// try {
			// 	final response = await http.get(stateNamesUrl);
			// 	if (response.statusCode == 200) {
			// 		List<dynamic> data = jsonDecode(response.body);
			// 		stateNameToAbbreviations = <String,String>{};
			// 		for (var item in data) {
			// 			stateNameToAbbreviations[item['valueLabel']] = item['Codevalue'];
			// 			print("stateNameToAbbreviations['${item['valueLabel']}'] = '${item['Codevalue']}';");
			// 		}
			// 		dataReady = true;
			// 	} else {
			// 		print('Failed to load data. HTTP Status Code: ${response.statusCode}');
			// 	}
			// } catch (e) {
			// 	print('Error occurred: $e');
			// }

			stateNameToAbbreviations['Alaska'] = 'AK';
			stateNameToAbbreviations['Alabama'] = 'AL';
			stateNameToAbbreviations['Arkansas'] = 'AR';
			stateNameToAbbreviations['American Samoa'] = 'AS';
			stateNameToAbbreviations['Arizona'] = 'AZ';
			stateNameToAbbreviations['California'] = 'CA';
			stateNameToAbbreviations['Colorado'] = 'CO';
			stateNameToAbbreviations['Connecticut'] = 'CT';
			stateNameToAbbreviations['District of Columbia'] = 'DC';
			stateNameToAbbreviations['Delaware'] = 'DE';
			stateNameToAbbreviations['Florida'] = 'FL';
			stateNameToAbbreviations['Federated States of Micronesia'] = 'FM';
			stateNameToAbbreviations['Georgia'] = 'GA';
			stateNameToAbbreviations['Guam'] = 'GU';
			stateNameToAbbreviations['Hawaii'] = 'HI';
			stateNameToAbbreviations['Iowa'] = 'IA';
			stateNameToAbbreviations['Idaho'] = 'ID';
			stateNameToAbbreviations['Illinois'] = 'IL';
			stateNameToAbbreviations['Indiana'] = 'IN';
			stateNameToAbbreviations['Kansas'] = 'KS';
			stateNameToAbbreviations['Kentucky'] = 'KY';
			stateNameToAbbreviations['Louisiana'] = 'LA';
			stateNameToAbbreviations['Massachusetts'] = 'MA';
			stateNameToAbbreviations['Maryland'] = 'MD';
			stateNameToAbbreviations['Maine'] = 'ME';
			stateNameToAbbreviations['Marshall Islands'] = 'MH';
			stateNameToAbbreviations['Michigan'] = 'MI';
			stateNameToAbbreviations['Minnesota'] = 'MN';
			stateNameToAbbreviations['Missouri'] = 'MO';
			stateNameToAbbreviations['Northern Marianas'] = 'MP';
			stateNameToAbbreviations['Mississippi'] = 'MS';
			stateNameToAbbreviations['Montana'] = 'MT';
			stateNameToAbbreviations['North Carolina'] = 'NC';
			stateNameToAbbreviations['North Dakota'] = 'ND';
			stateNameToAbbreviations['Nebraska'] = 'NE';
			stateNameToAbbreviations['New Hampshire'] = 'NH';
			stateNameToAbbreviations['New Jersey'] = 'NJ';
			stateNameToAbbreviations['New Mexico'] = 'NM';
			stateNameToAbbreviations['Nevada'] = 'NV';
			stateNameToAbbreviations['New York'] = 'NY';
			stateNameToAbbreviations['Ohio'] = 'OH';
			stateNameToAbbreviations['Oklahoma'] = 'OK';
			stateNameToAbbreviations['Oregon'] = 'OR';
			stateNameToAbbreviations['Pennsylvania'] = 'PA';
			stateNameToAbbreviations['Puerto Rico'] = 'PR';
			stateNameToAbbreviations['Palau'] = 'PW';
			stateNameToAbbreviations['Rhode Island'] = 'RI';
			stateNameToAbbreviations['South Carolina'] = 'SC';
			stateNameToAbbreviations['South Dakota'] = 'SD';
			stateNameToAbbreviations['Tennessee'] = 'TN';
			stateNameToAbbreviations['Texas'] = 'TX';
			stateNameToAbbreviations['Utah'] = 'UT';
			stateNameToAbbreviations['Virginia'] = 'VA';
			stateNameToAbbreviations['Virgin Islands'] = 'VI';
			stateNameToAbbreviations['Vermont'] = 'VT';
			stateNameToAbbreviations['Washington'] = 'WA';
			stateNameToAbbreviations['Wisconsin'] = 'WI';
			stateNameToAbbreviations['West Virginia'] = 'WV';
			stateNameToAbbreviations['Wyoming'] = 'WY';

			addSchoolScore(SchoolScore(uid: 1826, schoolName: "UCLA", subscores: [17, 13, 9, 22]));
			addSchoolScore(SchoolScore(uid: 7523, schoolName: "MIT", subscores: [20, 14, 29, 33]));
			addSchoolScore(SchoolScore(uid: 4321, schoolName: "Stanford", subscores: [18, 12, 24, 30]));
			addSchoolScore(SchoolScore(uid: 9876, schoolName: "Harvard", subscores: [15, 11, 27, 35]));
			addSchoolScore(SchoolScore(uid: 2570, schoolName: "Yale", subscores: [19, 15, 30, 34]));
			addSchoolScore(SchoolScore(uid: 6102, schoolName: "Caltech", subscores: [20, 13, 25, 31]));
			addSchoolScore(SchoolScore(uid: 3651, schoolName: "Rose-Hulman Institute of Technology", subscores: [20, 15, 30, 35]));
			addSchoolScore(SchoolScore(uid: 1745, schoolName: "Columbia", subscores: [16, 14, 28, 29]));
			addSchoolScore(SchoolScore(uid: 7854, schoolName: "Princeton", subscores: [14, 13, 22, 33]));
			addSchoolScore(SchoolScore(uid: 4398, schoolName: "UC Berkeley", subscores: [17, 12, 30, 32]));
			addSchoolScore(SchoolScore(uid: 5962, schoolName: "University of Chicago", subscores: [18, 15, 29, 35]));
			addSchoolScore(SchoolScore(uid: 7934, schoolName: "Duke", subscores: [16, 13, 26, 30]));
			addSchoolScore(SchoolScore(uid: 1283, schoolName: "University of Michigan", subscores: [19, 14, 24, 29]));
			addSchoolScore(SchoolScore(uid: 3429, schoolName: "NYU", subscores: [15, 12, 28, 34]));
			addSchoolScore(SchoolScore(uid: 5901, schoolName: "University of Virginia", subscores: [20, 14, 30, 33]));
			addSchoolScore(SchoolScore(uid: 8723, schoolName: "Brown University", subscores: [18, 12, 27, 31]));
			addSchoolScore(SchoolScore(uid: 4395, schoolName: "University of Washington", subscores: [16, 13, 23, 28]));
			addSchoolScore(SchoolScore(uid: 3810, schoolName: "Dartmouth", subscores: [17, 14, 22, 30]));
			addSchoolScore(SchoolScore(uid: 6427, schoolName: "Cornell", subscores: [20, 15, 29, 35]));
			addSchoolScore(SchoolScore(uid: 9284, schoolName: "University of Texas", subscores: [19, 11, 25, 31]));
			addSchoolScore(SchoolScore(uid: 1762, schoolName: "University of Florida", subscores: [15, 12, 28, 32]));
			addSchoolScore(SchoolScore(uid: 2548, schoolName: "Penn State", subscores: [14, 13, 27, 33]));
			addSchoolScore(SchoolScore(uid: 8742, schoolName: "University of Wisconsin", subscores: [18, 14, 30, 34]));
			addSchoolScore(SchoolScore(uid: 1203, schoolName: "Purdue", subscores: [19, 15, 24, 29]));
			addSchoolScore(SchoolScore(uid: 3619, schoolName: "Northwestern", subscores: [17, 12, 26, 32]));
			addSchoolScore(SchoolScore(uid: 4623, schoolName: "University of Illinois", subscores: [20, 14, 30, 35]));
			addSchoolScore(SchoolScore(uid: 5310, schoolName: "Emory University", subscores: [16, 11, 28, 30]));
			addSchoolScore(SchoolScore(uid: 8937, schoolName: "Georgetown", subscores: [15, 13, 27, 31]));
			addSchoolScore(SchoolScore(uid: 7495, schoolName: "Vanderbilt", subscores: [19, 14, 29, 34]));
			addSchoolScore(SchoolScore(uid: 2043, schoolName: "Rice University", subscores: [20, 13, 25, 28]));
			addSchoolScore(SchoolScore(uid: 3197, schoolName: "University of Minnesota", subscores: [18, 12, 30, 33]));
			addSchoolScore(SchoolScore(uid: 6541, schoolName: "Boston University", subscores: [17, 14, 28, 31]));
			addSchoolScore(SchoolScore(uid: 4538, schoolName: "University of Rochester", subscores: [14, 12, 23, 29]));
			addSchoolScore(SchoolScore(uid: 2983, schoolName: "Carnegie Mellon", subscores: [19, 13, 30, 35]));
			addSchoolScore(SchoolScore(uid: 7029, schoolName: "University of Southern California", subscores: [20, 15, 29, 34]));
			addSchoolScore(SchoolScore(uid: 4821, schoolName: "University of Arizona", subscores: [16, 14, 27, 32]));
			addSchoolScore(SchoolScore(uid: 5198, schoolName: "University of Colorado", subscores: [15, 13, 26, 33]));
			addSchoolScore(SchoolScore(uid: 6083, schoolName: "Georgia Tech", subscores: [20, 14, 30, 35]));
			addSchoolScore(SchoolScore(uid: 9102, schoolName: "University of Utah", subscores: [18, 12, 24, 28]));
			addSchoolScore(SchoolScore(uid: 1348, schoolName: "University of Oregon", subscores: [17, 14, 25, 30]));
			addSchoolScore(SchoolScore(uid: 2349, schoolName: "Indiana University", subscores: [19, 13, 29, 31]));
			addSchoolScore(SchoolScore(uid: 4587, schoolName: "University of Kansas", subscores: [16, 12, 27, 34]));
			addSchoolScore(SchoolScore(uid: 7021, schoolName: "University of Miami", subscores: [14, 15, 28, 30]));
			addSchoolScore(SchoolScore(uid: 3820, schoolName: "University of Alabama", subscores: [18, 14, 30, 32]));
			addSchoolScore(SchoolScore(uid: 5794, schoolName: "University of Kentucky", subscores: [20, 13, 29, 33]));
			addSchoolScore(SchoolScore(uid: 6041, schoolName: "University of Missouri", subscores: [15, 11, 26, 31]));
			addSchoolScore(SchoolScore(uid: 8032, schoolName: "University of Nebraska", subscores: [19, 14, 30, 34]));
			addSchoolScore(SchoolScore(uid: 9103, schoolName: "University of Oklahoma", subscores: [18, 12, 27, 29]));

			dataReady = true;
		}
  }

	void addSchoolScore(SchoolScore score) {
		if (allScores.containsKey(score.uid)) {
			print("UID ${score.uid}} is shared by '${score.schoolName}' and '${allScores[score.uid]!.schoolName}'. The former is not added to allScores.");
		} else {
			allScores[score.uid] = score;
		}
	}

	void addSchoolData(SchoolData data) {
		if (allScores.containsKey(data.uid)) {
			print("UID ${data.uid}} is shared by '${data.schoolName}' and '${allScores[data.uid]!.schoolName}'. The former is not added to allSchools.");
		} else {
			allSchools[data.uid] = data;
		}
	}

	bool requestSchoolData(int uid) {
		// This is to be expanded later with an actual request
		print("Making a request for UID $uid");
		return allSchools.containsKey(uid);
	}
}

