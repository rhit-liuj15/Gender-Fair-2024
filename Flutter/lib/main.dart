import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gender_fair_2024/components/nav_tile.dart';
import 'package:gender_fair_2024/models/data_loader.dart';
import 'package:gender_fair_2024/pages/about_us_page.dart';
import 'package:gender_fair_2024/pages/school_list_page.dart';

Future<void> main() async {
  await DataLoader.instance.loadData();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
	final Map<int,Widget> pages = {
		0:const SchoolListPage(),
		1:const AboutUsPage(),
	};
	int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gender Fair College Ranking',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFFFF4713),
          onPrimary: Colors.white,
          secondary: Color(0xFFFF4713),
          onSecondary: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
          error: Colors.red,
          onError: Colors.white,
        ),
        useMaterial3: true,
      ),
			home: Scaffold(
				appBar: AppBar(
					leading: SizedBox(
						width: 85,
						height: 100,
						child: Image.asset(
							'assets/logo.png',
							fit: BoxFit.cover,
						),
					),
					title: const Text("Gender Fair"),
					actions: [
						NavTile(
							label: "Rankings",
							isSelected: currentPageIndex == 0,
							onTap: () {
								setState(() {
								  currentPageIndex = 0;
								});
							},
						),
						NavTile(
							label: "About Us",
							isSelected: currentPageIndex == 1,
							onTap: () {
								setState(() {
								  currentPageIndex = 1;
								});
							},
						),
					],
				),
				body: Stack(
					children: [
						Container(
							decoration: BoxDecoration(
								gradient: LinearGradient(
									colors: [
										Colors.white.withOpacity(0.9),
										const Color(0xFFFF4713).withOpacity(0.2),
									],
									stops: const [0.1, 1.0],
									begin: Alignment.topLeft,
									end: Alignment.bottomRight,
								),
							),
						),
						BackdropFilter(
							filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
							child: Container(
								decoration: BoxDecoration(
									color: const Color.fromARGB(255, 160, 50, 50).withOpacity(0.2),
									borderRadius: BorderRadius.circular(20),
								),
							),
						),
						SafeArea(
							child: pages[currentPageIndex]!,
						),
					],
				),
			),
    );
  }
}

