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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => MapProvider()),
        ChangeNotifierProvider(create: (_) => PlannerHistoryProvider()),
      ], child: const HomeScreen()),
    );
  }
}
