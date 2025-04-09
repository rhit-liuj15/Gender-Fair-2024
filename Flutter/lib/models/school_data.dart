class SchoolData {
  int uid = 0;
  String schoolName = '';
  late Map<String, dynamic> data;

  SchoolData({
    required this.uid,
    required this.schoolName,
    required this.data,
  });

  SchoolData.fromJSON(dynamic json) {
    uid = json["UNITID"];
    schoolName = json["INSTNM"];
    data = json;
  }

  SchoolData.unknownUID(int uid) {
    uid = uid;
    schoolName = "Unknown School $uid!";
    data = {};
  }

  @override
  String toString() {
    return "\n$schoolName\nUID $uid\nData: $data";
  }
}
