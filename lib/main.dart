import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gender_fair_2024/pages/school_list_page.dart';

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
          onPrimary: Colors.black,
          secondary: Colors.cyan,
          onSecondary: Colors.black,
          background: Color(0xFFF5F5F5),
          onBackground: Colors.black,
          surface: Color.fromARGB(224, 255, 255, 255),
          onSurface: Colors.black,
          error: Colors.red,
          onError: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const GlassBackgroundPage(child: SchoolListPage()),
    );
  }
}

class GlassBackgroundPage extends StatelessWidget {
  final Widget child;

  const GlassBackgroundPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.orange
                      .withOpacity(0.9),
                  Colors.deepOrange
                      .withOpacity(0.8),
                  Colors.redAccent.withOpacity(0.7), 
                ],
                stops: [0.2, 0.7, 1.0], 
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
            child: child,
          ),
        ],
      ),
    );
  }
}
