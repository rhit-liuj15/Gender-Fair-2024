import 'package:flutter/material.dart';
import 'package:gender_fair_2024/models/metadata.dart';
import 'package:gender_fair_2024/models/school_academic_offerings.dart';

class MajorOptionsBlock extends StatefulWidget {
  static final Map<int, String> allCategories = Map.unmodifiable(Metadata
      .instance
      .getMetadataCategory(4)
      .metadataPairs
      .map((key, value) => MapEntry(int.parse(key), value)));
  final SchoolAcademicOfferings offerings;
  final Set<int> selectedLevels;
  final void Function() updateLevelsCallback;

  const MajorOptionsBlock({
    super.key,
    required this.offerings,
    required this.selectedLevels,
    required this.updateLevelsCallback,
  });

  @override
  State<MajorOptionsBlock> createState() => _MajorOptionsBlockState();
}

class _MajorOptionsBlockState extends State<MajorOptionsBlock> {
  @override
  Widget build(BuildContext context) {

		String majorName = Metadata.instance.getMetadataCategory(3).metadataPairs[widget.offerings.cipcode]!;

    return Column(
      children: [
				Row(
					children: [
						Expanded(
							child: Text(
								majorName,
								style: const TextStyle(
										fontSize: 16.0, fontWeight: FontWeight.bold),
								textAlign: TextAlign.start,
							),
						),
						IconButton(
							icon: const Icon(Icons.close),
							onPressed: () {
								widget.selectedLevels.clear();
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
							if (widget.offerings.numSchoolsOfferingLevel(level: entry.key) > 0) Row(
                  children: [
										Checkbox(
											value: widget.selectedLevels.contains(entry.key),
											onChanged: (value) {
											  if (value != null) {
													setState(() {
														if (value) {
															widget.selectedLevels.add(entry.key);
														} else {
															widget.selectedLevels.remove(entry.key);
														}
													});
													widget.updateLevelsCallback();
												}
											},
										),
										Text("${entry.value} (${widget.offerings.numSchoolsOfferingLevel(level: entry.key)})"),
									],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
