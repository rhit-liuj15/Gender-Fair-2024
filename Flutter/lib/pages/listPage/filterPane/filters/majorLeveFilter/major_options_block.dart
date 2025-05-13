import 'package:flutter/material.dart';
import 'package:gender_fair_2024/models/data_loader.dart';
import 'package:gender_fair_2024/models/filter_data.dart';
import 'package:gender_fair_2024/models/metadata.dart';

class MajorOptionsBlock extends StatefulWidget {
  static final Map<int, String> allCategories = Map.unmodifiable(Metadata
      .instance
      .getMetadataCategory(4)
      .metadataPairs
      .map((key, value) => MapEntry(int.parse(key), value)));
	final String cipcode;
  final void Function() updateLevelsCallback;

  const MajorOptionsBlock({
    super.key,
    required this.cipcode,
    required this.updateLevelsCallback,
  });

  @override
  State<MajorOptionsBlock> createState() => _MajorOptionsBlockState();
}

class _MajorOptionsBlockState extends State<MajorOptionsBlock> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
				Row(
					children: [
						Expanded(
							child: Text(
								Metadata.instance.getMetadataCategory(3).metadataPairs[widget.cipcode]!,
								style: const TextStyle(
										fontSize: 16.0, fontWeight: FontWeight.bold),
								textAlign: TextAlign.start,
							),
						),
						IconButton(
							icon: const Icon(Icons.close),
							onPressed: () {
								FilterData.instance.selectedLevelsByCIPCODE.remove(widget.cipcode);
								widget.updateLevelsCallback();
							},
						),
					],
				),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              for (MapEntry<int, String> entry in MajorOptionsBlock.allCategories.entries)
							if (DataLoader.instance.allSchoolOfferings[widget.cipcode]!.numSchoolsOfferingLevel(level: entry.key) > 0) Row(
                  children: [
										Checkbox(
											value: FilterData.instance.selectedLevelsByCIPCODE[widget.cipcode]!.contains(entry.key),
											onChanged: (value) {
											  if (value != null) {
													setState(() {
														if (value) {
															FilterData.instance.selectedLevelsByCIPCODE[widget.cipcode]!.add(entry.key);
														} else {
															FilterData.instance.selectedLevelsByCIPCODE[widget.cipcode]!.remove(entry.key);
														}
													});
													widget.updateLevelsCallback();
												}
											},
										),
										Text(entry.value),
									],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
