import 'package:flutter/material.dart';

class StateNameTile extends StatelessWidget {
  final String state;
	final TextStyle textStyle = const TextStyle(fontSize: 12.0);
	final void Function() removeStateCallback;
	
  const StateNameTile({
		super.key,
		required this.state,
		required this.removeStateCallback,
	});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
			fit: BoxFit.cover,
			child: Card(
				child: Padding(
					padding: const EdgeInsets.all(5.0),
					child: Row(
						children: [
							Text(state, style: textStyle,),
							const SizedBox(width: 5.0,),
							InkWell(
								onTap: () {
									removeStateCallback();
								},
								child: const Icon(Icons.close, size: 20.0,),
							)
						],	
					),
				),
			),
		);
  }
}