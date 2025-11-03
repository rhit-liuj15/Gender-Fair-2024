
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotFoundFage extends StatelessWidget {
  static const NotFoundFage instance = NotFoundFage._privateConstructor();
  const NotFoundFage._privateConstructor();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        border: Border.all(color: const Color(0xFFFF4713), width: 2),
      ),
      child: Column(
				mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("That page was not found! Click the button below to go to the home page."),
					TextButton(
						onPressed: () => context.go(Uri(path:'/').toString()),
						child: const Text("Home")
					)
        ],
      ),
    );
  }
}
