class SchoolScore {
  static final Set<int> selectedSchools = <int>{};

  int rank = 0;
  int uid;
  String schoolName;
  String schoolState;
  String schoolType;
  Map<SchoolScoreAttributes, int> subscores;

  int get score => subscores.values.toList().reduce((a, b) => a + b);

  SchoolScore({
    required this.uid,
    required this.schoolName,
    required this.schoolState,
    required this.schoolType,
    required this.subscores,
    this.rank = 0,
  });

  bool scoreOutOfBounds(Map<SchoolScoreAttributes, int> val) {
    return false;
  }

  @override
  String toString() {
    return "The school $schoolName (UID $uid) in state $schoolState has scores $subscores";
  }
}

enum SchoolScoreAttributes {
  leadership(name: "Leadership"),
  polnpay(name: "Policies & Pay"),
  safety(name: "Safety"),
  diversity(name: "Diversity"),
  total(name: "Total");

  const SchoolScoreAttributes({
    required this.name,
  });

  final String name;

  static List<SchoolScoreAttributes> subscoreItems = [
    SchoolScoreAttributes.leadership,
    SchoolScoreAttributes.polnpay,
    SchoolScoreAttributes.safety,
    SchoolScoreAttributes.diversity
  ];
}
