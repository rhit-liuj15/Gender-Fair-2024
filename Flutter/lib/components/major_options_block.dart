import 'package:flutter/material.dart';
import 'package:gender_fair_2024/models/metadata.dart';

class MajorOptionsBlock extends StatelessWidget {
  static final Map<int, String> allCategories = Map.unmodifiable(Metadata
      .instance
      .getMetadataCategory(4)
      .metadataPairs
      .map((key, value) => MapEntry(int.parse(key), value)));
  final String majorName;
  final Set<int> selectedLevels;
  final void Function() updateLevelsCallback;

  const MajorOptionsBlock({
    super.key,
    required this.majorName,
    required this.selectedLevels,
    required this.updateLevelsCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
				Row(
					children: [
						Text(
							majorName,
							style: const TextStyle(
									fontSize: 16.0, fontWeight: FontWeight.bold),
							textAlign: TextAlign.start,
						),
						const Expanded(
							child: SizedBox()
						),
						IconButton(
							icon: const Icon(Icons.close),
							tooltip: 'Remove $majorName',
							onPressed: () {
								selectedLevels.clear();
								updateLevelsCallback();
							},
						),
					],
				),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              for (MapEntry<int, String> entry in allCategories.entries)
                Row(
                  children: [
										Checkbox(
											value: selectedLevels.contains(entry.key),
											onChanged: (value) {
											  if (value != null) {
													if (value) {
														selectedLevels.add(entry.key);
													} else {
														selectedLevels.remove(entry.key);
													}
													updateLevelsCallback();
												}
											},
										),
										Text(entry.value)
									],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
