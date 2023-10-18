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
      extendBody: true,
      body: Stack(
        children: [
          PageView(
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
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 60,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0, 0.55],
                      colors: [Colors.transparent, Colors.black87])),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        unselectedItemColor: const Color.fromARGB(255, 143, 101, 30),
        selectedItemColor: const Color.fromARGB(255, 184, 122, 8),
        onTap: _bottomNav,
        currentIndex: currIndex,
        items: const [
          BottomNavigationBarItem(
              backgroundColor: Colors.transparent,
              icon: Icon(Icons.home_filled),
              label: 'Dashboard'),
          BottomNavigationBarItem(
              backgroundColor: Colors.transparent,
              icon: Icon(Icons.search_rounded),
              label: 'Planner'),
          BottomNavigationBarItem(
              backgroundColor: Colors.transparent,
              icon: Icon(Icons.local_hospital_rounded),
              label: 'Create'),
          BottomNavigationBarItem(
              backgroundColor: Colors.transparent,
              icon: Icon(Icons.people_alt_rounded),
              label: 'Friends'),
          BottomNavigationBarItem(
              backgroundColor: Colors.transparent,
              icon: Icon(Icons.person),
              label: 'Profile'),
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
