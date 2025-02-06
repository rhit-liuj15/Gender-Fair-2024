

import 'package:gender_fair_2024/models/school_score.dart';

enum ListPageColumnAttributes {
  
	addToList(flexWidth: 2, name: "Add To List", sortable: false, sortDescending: false),
	ranking(flexWidth: 2, name: "Ranking", sortable: false, sortDescending: false),
	instName(flexWidth: 7, name: "Institution Name", sortable: true, sortDescending: false),
	leadership(flexWidth: 2, name: "Leadership", sortable: true, sortDescending: true),
	polnpay(flexWidth: 2, name: "Policies & Pay", sortable: true, sortDescending: true),
	safety(flexWidth: 2, name: "Safety", sortable: true, sortDescending: true),
	diversity(flexWidth: 2, name: "Diversity", sortable: true, sortDescending: true),
	total(flexWidth: 2, name: "Total", sortable: true, sortDescending: true);

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

  static Map<ListPageColumnAttributes,bool> get sortOrder => {
		for (var item in sortableItems) item: item.sortDescending
	};
	
  static List<int> get flexValues => 
		ListPageColumnAttributes.values.map((item) => item.flexWidth).toList();

  static List<String> get colNames => 
		ListPageColumnAttributes.values.map((item) => item.name).toList();

		
  static final Map<ListPageColumnAttributes, SchoolScoreAttributes> listPageToSchoolScoreMapping = Map.unmodifiable(
		<ListPageColumnAttributes, SchoolScoreAttributes>{
			ListPageColumnAttributes.leadership: SchoolScoreAttributes.leadership,
			ListPageColumnAttributes.polnpay: SchoolScoreAttributes.polnpay,
			ListPageColumnAttributes.safety: SchoolScoreAttributes.safety,
			ListPageColumnAttributes.diversity: SchoolScoreAttributes.diversity,
		}
	);
}
