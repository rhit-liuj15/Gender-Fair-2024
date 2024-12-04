import 'dart:convert';
import 'package:http/http.dart' as http;

class StateNamesData {
	// I'm trying my best to guess this is how singleton works in flutter...
	late Map<String,String> stateNameToAbbreviations;
	bool stateNamesReady = false;
  static final StateNamesData instance = StateNamesData._privateConstructor();

  StateNamesData._privateConstructor();

  // Method to load data asynchronously and populate stateNames
  Future<void> loadData() async {
		if (!stateNamesReady) {
			var url = Uri.http('genderfair2024.csse.rose-hulman.edu:80', 'states');
			try {
				final response = await http.get(url);
				if (response.statusCode == 200) {
					List<dynamic> data = jsonDecode(response.body);
					stateNameToAbbreviations = <String,String>{};
					for (var item in data) {
						stateNameToAbbreviations[item['valueLabel']] = item['Codevalue'];
					}
					stateNamesReady = true;
				} else {
					print('Failed to load data. HTTP Status Code: ${response.statusCode}');
				}
			} catch (e) {
				print('Error occurred: $e');
			}
		}
  }
}

