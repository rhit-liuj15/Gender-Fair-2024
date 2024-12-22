class SchoolData {
	int uid;
  String schoolName;
	Map<String,dynamic> schoolData;
	// The first string is a category name, and the 

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



SchoolData defaultSchoolDataWithUID(int uid) {
  return SchoolData(
    uid: uid,
    schoolName: "No data for uid $uid!",
    schoolData: {},
  );
}