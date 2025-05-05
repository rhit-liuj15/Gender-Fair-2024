import 'dart:convert';
import 'package:gender_fair_2024/models/metadata.dart';
import 'package:http/http.dart' as https;
import 'package:gender_fair_2024/models/school_data.dart';
import 'package:gender_fair_2024/models/school_score.dart';

class DataLoader {
  Map<int, SchoolData> allSchoolData = <int, SchoolData>{};
  Map<int, SchoolScore> allSchoolScores = <int, SchoolScore>{};
  Map<String, double> allAverages = <String, double>{};
  // The reason allSchoolData and allSchoolScores are separate is that allSchoolScores are loaded up front, but allSchoolData is requested as necessary.
  bool initialDataLoadComplete = false;
  static final DataLoader instance = DataLoader._privateConstructor();

  DataLoader._privateConstructor();

  void computeRankings() {
    List<SchoolScore> sortedScores = allSchoolScores.values.toList();
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

      if (i == sortedScores.length - 1 ||
          sortedScores[i].score != sortedScores[i + 1].score) {
        rankRanges.add("$rangeStart-$rank");
        rangeStart = rank + 1;
      }

      sortedScores[i].rank = rank;
    }
  }

  Future<void> loadData() async {
    if (!initialDataLoadComplete) {
      var scoreUrl = Uri.https('genderfair2024.csse.rose-hulman.edu', 'score');
      var averagesUrl =
          Uri.https('genderfair2024.csse.rose-hulman.edu', 'averages');
      var metadataUrl =
          Uri.https('genderfair2024.csse.rose-hulman.edu', 'metadata');
      try {
        final scoreResponse = await https.get(scoreUrl);
        if (scoreResponse.statusCode == 200) {
          List<dynamic> data = jsonDecode(scoreResponse.body);
          for (var item in data) {
            allSchoolScores[item['UNITID']] = SchoolScore(
              uid: item['UNITID'],
              schoolName: item['INSTNM'],
              schoolState: item['STATE'],
              schoolType: item['INSTFUNDINGTYPE'],
              subscores: Map.unmodifiable(<SchoolScoreAttributes, int>{
                SchoolScoreAttributes.leadership: item['LEADERSHIP'],
                SchoolScoreAttributes.polnpay: item['POLICIES'],
                SchoolScoreAttributes.safety: item['SAFETY'],
                SchoolScoreAttributes.diversity: item['DIVERSITY'],
              }),
            );
          }
          computeRankings();
        } else {
          print(
              'Failed to load score data. HTTP Status Code: ${scoreResponse.statusCode}');
        }
      } catch (e) {
        print('Error occurred while fetching scores: $e');
      }

      try {
        final metadataResponse = await https.get(metadataUrl);
        if (metadataResponse.statusCode == 200) {
          List<dynamic> data = jsonDecode(metadataResponse.body);
          for (var item in data) {
            Metadata.instance
                .addEntry(item["GROUP"], item["ABBR"], item["DESC"]);
          }
        } else {
          print(
              'Failed to load metadata data. HTTP Status Code: ${metadataResponse.statusCode}');
        }
      } catch (e) {
        print('Error occurred while fetching metadata: $e');
      }

      try {
        final averagesResponse = await https.get(averagesUrl);
        if (averagesResponse.statusCode == 200) {
          List<dynamic> data = jsonDecode(averagesResponse.body);
          for (var item in data) {
            allAverages[item['Name']] = item['Value'];
          }
        } else {
          print(
              'Failed to load averages data. HTTP Status Code: ${averagesResponse.statusCode}');
        }
      } catch (e) {
        print('Error occurred while fetching averages: $e');
      }
      initialDataLoadComplete = true;
    }
  }

  void addSchoolData(SchoolData data) {
    if (allSchoolData.containsKey(data.getUID())) {
      // This is informational. It does not impact the user.
      print(
          "UID ${data.getUID()} is shared by '${data.getName()}' and '${allSchoolScores[data.getUID()]!.schoolName}'. The former is not added to allSchoolData.");
    } else {
      allSchoolData[data.getUID()] = data;
    }
  }

  Future<void> requestSchoolData(Set<int> uids) async {
    // This is to be expanded later with an actual request
    Set<int> notPresentData = uids.difference(allSchoolData.keys.toSet());
    print(
        "UIDS ${allSchoolData.keys.toSet().intersection(uids)} already exist in data");
    if (notPresentData.isNotEmpty) {
      String fetchUIDs = notPresentData.join(',');
      var dataUrl = Uri.https(
          'genderfair2024.csse.rose-hulman.edu', 'data', {'uids': fetchUIDs});
      // print("Making a request for UIDs $fetchUIDs");
      // print(dataUrl);
      try {
        final https.Response response = await https.get(dataUrl);
        if (response.statusCode == 200) {
          List<dynamic> data = jsonDecode(response.body);
          for (var item in data) {
            addSchoolData(SchoolData.fromJSON(item));
          }
        } else {
          print(
              'Failed to load school data. HTTP Status Code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error occurred while loading school data: $e');
      }
    }
  }
}
