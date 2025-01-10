import 'package:flutter/material.dart';
import 'package:gender_fair_2024/pages/all_schools_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School Ranking App',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromARGB(202, 255, 99, 2),
          onPrimary: Color.fromARGB(202, 255, 99, 2),
          secondary: Color.fromARGB(255, 99, 2, 202),
          onSecondary: Color.fromARGB(202, 255, 99, 2),
          background: Color(0xFFF5F5F5),
          onBackground: Colors.black,
          surface: Color.fromARGB(160, 255, 255, 255),
          onSurface: Colors.black,
          error: Colors.red,
          onError: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const AllSchoolsPage(),
    );
  }

  
}
