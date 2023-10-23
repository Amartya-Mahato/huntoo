import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:huntoo/providers/map_provider/map_provider.dart';
import 'package:huntoo/routes/routes.dart';
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
      routes: Routes().routes,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(color: Colors.black),
        primaryTextTheme: TextTheme(
            bodyMedium: GoogleFonts.firaCode(shadows: [
          const Shadow(
            color: Colors.black87,
            offset: Offset(0, 1),
            blurRadius: 4,
          )
        ], color: const Color.fromARGB(223, 255, 255, 255), wordSpacing: 0.1)),
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
