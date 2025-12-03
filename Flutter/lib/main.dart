import 'package:flutter/material.dart';
import 'package:gender_fair_2024/models/data_loader.dart';
import 'package:gender_fair_2024/pages/detailPage/school_detail_page.dart';
import 'package:gender_fair_2024/pages/listPane/school_list_panel.dart';
import 'package:gender_fair_2024/pages/not_found_page.dart';
import 'package:go_router/go_router.dart';
import 'package:url_strategy/url_strategy.dart';



Future<void> main() async {
  await DataLoader.instance.loadData();
  setPathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
	/// Creates the app
  MyApp({super.key});

  final goRouter = GoRouter(
    redirect: (context, state) {
      final uri = state.uri;
      final isRoot = uri.path == '/';
      final is404 = uri.path == '/404';
      final isDetails = RegExp(r'^/details/\d+$').hasMatch(uri.path);
      if (uri.path == '/' && uri.fragment.startsWith('/details/')) {
        final fragPath = uri.fragment;
        return Uri(path: fragPath).toString();
      }
      final hasExtras = uri.hasQuery || uri.fragment.isNotEmpty;
      if ((isRoot || isDetails) && hasExtras) {
        return uri.replace(queryParameters: const {}, fragment: '').toString();
      }
      return (isRoot || is404 || isDetails) ? null : '/404';
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const Scaffold(
          body: SchoolListPanel.instance,
        ),
        routes: [
          GoRoute(
            path: 'details/:uid',
            builder: (context, state) {
              int uid = int.parse(state.pathParameters['uid']!);
              return SchoolDetailPage(uid: uid);
            }
          ),
          GoRoute(
            path: '/404',
            builder: (context, state) {
              return NotFoundFage.instance;
            }
          )
        ],
      )
    ],
  );

  @override
  Widget build(BuildContext context) {

    return MaterialApp.router(
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
      routerConfig: goRouter,
    );
  }
}
