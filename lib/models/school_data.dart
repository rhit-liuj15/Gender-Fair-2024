class SchoolData {
	int uid;
  String schoolName;
	Map<String,SchoolDataCategory> categories;

  SchoolData({
		required this.uid,
    required this.schoolName,
    required this.categories,
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
    categories: {},
  );
}

class SchoolDataCategory {
	
  final String categoryName;
	Map<String,dynamic> data;

  SchoolDataCategory({
    required this.categoryName,
    required this.data,
  });

}