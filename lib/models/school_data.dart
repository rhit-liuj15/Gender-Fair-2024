class SchoolData {
  int uid = 0;
  String schoolName = '';
  Set<SchoolDataCategory> categories = {};

  SchoolData({
    required this.uid,
    required this.schoolName,
    required this.categories,
  });

  SchoolData.fromJSON(dynamic json) {
    uid = json["UNITID"];
    schoolName = json["INSTNM"];
    categories = {
      SchoolDataCategory(categoryName: "Basic Information", data: {
        "2023 Graduation Headcount": json["DEGREETOT"],
        "Fall 2023 Enrollment": json["ENROLTOT"],
      }),
      SchoolDataCategory(categoryName: "Financials", data: {
        "Average Salary For Men": json["SALARYPPM"],
        "Average Salary For Women": json["SALARYPPF"],
      }),
      SchoolDataCategory(categoryName: "Academic Staff Composition", data: {
        "Women Professors": json["PROFWOMENPCT"],
        "Women Associate Professors": json["ASSOCPROFWOMEN"],
        "Tenured Women Academic Staff": json["TENUREWOMENPCT"],
      }),
      SchoolDataCategory(categoryName: "Non-Academic Staff Composition", data: {
        "Black": json["NASBLACKPCT"],
        "Hispanic": json["NASHISPANICPCT"],
        "Asian": json["NASASIAPCT"],
      }),
      SchoolDataCategory(categoryName: "Safety", data: {
        "Hate Crimes Per Year 2020-2022": json["YEARLYHATECRIME"],
        "Hate Crimes Per Year 2020-2022 Per 1K Students":
            json["YEARLYHATECRIME1K"],
        "VAWA Per Year 2020-2022": json["YEARLYVAWA"],
        "VAWA Per Year 2020-2022 Per 1K Students": json["YEARLYVAWA1K"],
      }),
    };
  }

  SchoolData.unknownUID(int uid) {
    uid = uid;
    schoolName = "Unknown School $uid!";
    categories = {};
  }

  @override
  String toString() {
    return "\n$schoolName\nUID $uid\n$categories";
  }
}

class SchoolDataCategory {
  final String categoryName;
  Map<String, dynamic> data;

  SchoolDataCategory({
    required this.categoryName,
    required this.data,
  });

  @override
  String toString() {
    return "$categoryName: $data\n";
  }
}
