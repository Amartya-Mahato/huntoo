import 'package:flutter/material.dart';
import 'package:huntoo/providers/map_provider/map_provider.dart';
import 'package:huntoo/screens/home_screen.dart';
import 'package:provider/provider.dart';

import 'providers/planner_history_provider/planner_history_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Huntoo!',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(color: Colors.black),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.transparent),
      ),
      home: MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => MapProvider()),
        ChangeNotifierProvider(create: (_) => PlannerHistoryProvider()),
      ], child: const HomeScreen()),
    );
  }
}
