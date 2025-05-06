import 'package:flutter/material.dart';

class FilterBlock extends StatelessWidget {
  final String title;
  final Widget child;

  const FilterBlock({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
			padding: const EdgeInsets.all(16.0),
			child: Column(
				children: [
					Row(
						children: [
							Text(
								title,
								style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
								textAlign: TextAlign.start,
							),
							const SizedBox(width: 14.0),
							Expanded(
								child: Align(
									alignment: Alignment.centerRight,
									child: Container(
										height: 2.5, // Adjust as needed
										color: Colors.black,
									),
								),
							),
						],
					),
					const SizedBox(height: 20.0),
					Padding(
						padding: const EdgeInsets.only(left: 35.0, right: 35.0),
						child: child,
					),
				],
			),
		);
  }
}
