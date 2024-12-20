class SchoolData {
	int uid;
  String schoolName;
	Map<int,Map<String, dynamic>> schoolData;

  SchoolData({
		required this.uid,
    required this.schoolName,
    required this.schoolData,
  });

  @override
  String toString() {
    return "The school $schoolName has UID $uid";
  }
}