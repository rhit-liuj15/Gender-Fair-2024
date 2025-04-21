class SchoolData {
  late Map<String, dynamic> data;

  SchoolData({
    required this.data,
  });

  SchoolData.fromJSON(dynamic json) {
    data = json;
  }

  SchoolData.unknownUID(int uid) {
    data = {
			"UNITID" : uid,
			"INSTNM" : "Unknown School $uid!",
		};
  }

  @override
  String toString() {
    return "\n${getName()}}\nUID ${getUID()}\nData: $data";
  }

  String getName() {
    return data["INSTNM"];
  }
  int getUID() {
    return data["UNITID"];
  }
}
