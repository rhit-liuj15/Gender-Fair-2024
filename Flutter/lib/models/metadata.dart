class Metadata {
  static final Map<int, MetadataCategory> groupMapping =
      <int, MetadataCategory>{};

  static final Metadata instance = Metadata._privateConstructor();

  Metadata._privateConstructor();

  void addEntry(int group, String abbreviation, String description) {
    try {
      switch (group) {
        case 0:
          getMetadataCategory(int.parse(abbreviation))
              .setGroupDescription(description);
        default:
          getMetadataCategory(group).addEntry(abbreviation, description);
      }
    } catch (e) {
      print(e);
    }
  }

  MetadataCategory getMetadataCategory(int group) {
    if (!groupMapping.containsKey(group)) {
      groupMapping[group] = MetadataCategory(categoryNumber: group);
    }
    return groupMapping[group]!;
  }

  @override
  String toString() {
    return "The contents of the metadata table is $groupMapping";
  }
}

class MetadataCategory {
  final int categoryNumber;
  late String categoryDescription = "";
  final Map<String, String> metadataPairs = <String, String>{};

  MetadataCategory({
    required this.categoryNumber,
  });

  void setGroupDescription(String description) {
    categoryDescription = description;
  }

  void addEntry(String abbreviation, String description) {
    if (metadataPairs.containsKey(abbreviation)) {
      throw Exception(
          "Duplicate entry on abbreviation '$abbreviation' in group $categoryNumber ($categoryDescription).\nExisting: ${metadataPairs[abbreviation]}\nNew: $description");
    }
    metadataPairs[abbreviation] = description;
  }

  String? getEntry(String abbreviation) {
    return metadataPairs[abbreviation];
  }

  @override
  String toString() {
    return "$metadataPairs";
  }
}
