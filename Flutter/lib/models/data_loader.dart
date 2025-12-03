import 'dart:convert';
import 'package:gender_fair_2024/models/school_data.dart';
import 'package:gender_fair_2024/models/data_json.dart';

class DataLoader {
  Map<int, SchoolData> allSchoolData = <int, SchoolData>{};
  Map<String, double> allAverages = <String, double>{};

  bool initialDataLoadComplete = false;

  static final DataLoader instance = DataLoader._privateConstructor();

  DataLoader._privateConstructor();

  Future<void> loadData() async {
    if (!initialDataLoadComplete) {
      List<dynamic> averagesDataEntries = jsonDecode(DataJSON.averages);
      for (var item in averagesDataEntries) {
        allAverages[item['Name']] = item['Value'];
      }

      List<dynamic> schoolDataEntries = jsonDecode(DataJSON.schoolData);
			for (var item in schoolDataEntries) {
				SchoolData data = SchoolData.fromJSON(item);
				allSchoolData[data.getUID()] = data;
			}

      initialDataLoadComplete = true;
    }
  }
}
