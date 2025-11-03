import 'package:flutter/material.dart';
import 'package:gender_fair_2024/models/list_page_column_attributes.dart';
import 'package:gender_fair_2024/models/sort_metric.dart';

class SortMetricTile extends StatefulWidget {
  static const sortMetricListenerName = "Sort Metric";

  static const SortMetricTile instance = SortMetricTile._privateConstructor();

  const SortMetricTile._privateConstructor();

  @override
  State<SortMetricTile> createState() => _SortMetricTileState();
}

class _SortMetricTileState extends State<SortMetricTile> {

  @override
  void initState() {
    super.initState();
    SortMetric.instance.addSortMetricChangeCallback(
      name: SortMetricTile.sortMetricListenerName,
      callback: () {setState(() {});}
    );
  }
	
  @override
  void dispose() {
    SortMetric.instance.removeSortMetricChangeCallback(
      name: SortMetricTile.sortMetricListenerName,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          "Sort by:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 8.0),
        DropdownButton<ListPageColumnAttributes>(
          value: SortMetric.instance.sortMetric,
          onChanged: (ListPageColumnAttributes? newValue) {
            if (newValue != null) {
              SortMetric.instance.updateSortMetric(newValue);
            }
          },
          // Generate dropdown entry for all sortable columns
          items: ListPageColumnAttributes.values
              .where((item) => item.sortable)
              .map((item) => DropdownMenuItem<ListPageColumnAttributes>(
                    value: item,
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ))
              .toList(),
          isExpanded: false,
        ),
				const SizedBox(width: 8.0),
				TextButton(
					onPressed: SortMetric.instance.invertSort,
					child: const Text("Invert Sort"),
				),
      ],
    );
  }
}
