enum ListPageColumnAttributes {
	/// This enum serves as the config file for how the columns on the list page should be ordered

  instName(
      flexWidth: 7,
      name: "Institution Name",
      sortable: true,
      sortDescending: false),
  populationTotal(
    flexWidth: 3,
    name: "Student Population",
    sortable: true,
    sortDescending: true
  ),
  ;

  const ListPageColumnAttributes({
    required this.flexWidth,
    required this.name,
    required this.sortable,
    required this.sortDescending,
  });

  final int flexWidth;
  final String name;
  final bool sortable;
  final bool sortDescending;

  static List<ListPageColumnAttributes> get sortableItems =>
      ListPageColumnAttributes.values.where((item) => item.sortable).toList();

  static Map<ListPageColumnAttributes, bool> get sortOrder =>
      {for (var item in sortableItems) item: item.sortDescending};

  static List<int> get flexValues =>
      ListPageColumnAttributes.values.map((item) => item.flexWidth).toList();

  static List<String> get colNames =>
      ListPageColumnAttributes.values.map((item) => item.name).toList();

}
