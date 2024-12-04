import 'dart:convert';

import 'package:gender_fair_2024/models/school_data.dart';
import 'package:http/http.dart' as http;

class AllSchoolData {
	// I'm trying my best to guess this is how singleton works in flutter...
	late List<SchoolData> allSchools;
	bool schoolDataReady = false;
  static final AllSchoolData instance = AllSchoolData._privateConstructor();

  AllSchoolData._privateConstructor();

  // Method to load data asynchronously and populate allSchools
  Future<void> loadData() async {
		if (!schoolDataReady) {;
			var url = Uri.http('genderfair2024.csse.rose-hulman.edu:80', 'schools');
			try {
				final response = await http.get(url);
				if (response.statusCode == 200) {
					List<dynamic> data = jsonDecode(response.body);
					allSchools = data.map((item) => SchoolData(
						uid: item["School ID"],
						schoolName: item["School Name"],
						schoolStateInitials: item["State Abbreviation"],
						studentPopulation: item["Total Students"],
					)).toList();
					schoolDataReady = true;
				} else {
					print('Failed to load data. HTTP Status Code: ${response.statusCode}');
				}
			} catch (e) {
				print('Error occurred: $e');
			}
		}
  }
}