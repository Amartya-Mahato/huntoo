import 'package:flutter/material.dart';
import 'package:huntoo/providers/map_provider/map_provider.dart';
import 'package:huntoo/screens/dash_board_screen.dart';
import 'package:huntoo/screens/friend_list_screen.dart';
import 'package:huntoo/screens/planner_screen.dart';
import 'package:huntoo/screens/profile_screen.dart';
import 'package:provider/provider.dart';

import 'create_hunt_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int currIndex = 0;

  @override
  void initState() {
    context.read<MapProvider>().set();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: _onPageChange,
        children: const [
          DashBoard(),
          PlannerScreen(),
          CreateHuntScreen(),
          FriendListScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.0,
        unselectedItemColor: Colors.deepPurple.shade200,
        selectedItemColor: Colors.deepPurple.shade700,
        onTap: _bottomNav,
        currentIndex: currIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_filled), label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded), label: 'Planner'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_hospital_rounded), label: 'Create'),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_rounded), label: 'Friends'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  void _bottomNav(int pageIndex) {
    setState(() {
      currIndex = pageIndex;
      _pageController.animateToPage(pageIndex,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInCubic);
    });
  }

  void _onPageChange(int pageIndex) {
    setState(() {
      currIndex = pageIndex;
    });
  }
}
