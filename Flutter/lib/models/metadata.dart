class Metadata {
	/// The data class for storing the metadata provided by the database
  static final Map<int, MetadataCategory> groupMapping =
      <int, MetadataCategory>{};

  static final Metadata instance = Metadata._privateConstructor();

  Metadata._privateConstructor();

	/// Adds an entry to the specified [group]
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

	/// Gets a metadata category by [group], or an empty group with that group number if it doesn't exist. This empty group is stored.
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
	/// A metadata category with a number [categoryNumber], description [categoryDescription], and a mapping of abbreviation to values [metadataPairs].
	/// Access to data is performed by calling [getEntry].
  final int categoryNumber;
  late String categoryDescription = "";
  final Map<String, String> metadataPairs = <String, String>{};

  MetadataCategory({
    required this.categoryNumber,
  });

	/// Sets the description for this category.
  void setGroupDescription(String description) {
    categoryDescription = description;
  }

	/// Adds an entry to this metadata category.
	/// The new data is ignored on conflict.
  void addEntry(String abbreviation, String description) {
    if (metadataPairs.containsKey(abbreviation)) {
      throw Exception(
          "Duplicate entry on abbreviation '$abbreviation' in group $categoryNumber ($categoryDescription).\nExisting: ${metadataPairs[abbreviation]}\nNew: $description");
    }
    metadataPairs[abbreviation] = description;
  }

	/// Gets an entry from the metadata category. The value may be [Null]
  String? getEntry(String abbreviation) {
    return metadataPairs[abbreviation];
  }

  @override
  String toString() {
    return "$metadataPairs";
  }
}
