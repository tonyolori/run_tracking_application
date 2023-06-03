// ignore_for_file: unused_import

import 'package:permission_handler/permission_handler.dart';
import '../constants.dart';
import 'package:flutter/material.dart';
import 'maps_home.dart';
import 'settings_page.dart';
import 'progress_page.dart';
import 'profile_page.dart';
import 'firebase_page.dart';
import 'discover_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int selectedIndex = 0;

  final List<Widget> _screens = [
    MapHomePage(),
    const ProgressPage(),
    const SettingsPage(),
    const FirebasePage(),
    DiscoverPage(),
  ];
  List<Widget> destinations = const [
    NavigationDestination(
      icon: Icon(Icons.explore),
      label: 'Maps',
    ),
    NavigationDestination(
      selectedIcon: Icon(Icons.legend_toggle),
      icon: Icon(Icons.monitor),
      label: 'Progress',
    ),
    NavigationDestination(
      selectedIcon: Icon(Icons.bookmark),
      icon: Icon(Icons.bookmark_border),
      label: 'Leaderboard',
    ),
    NavigationDestination(
      selectedIcon: Icon(Icons.bookmark),
      icon: Icon(Icons.bookmark_border),
      label: 'Settings',
    ),
    NavigationDestination(
      selectedIcon: Icon(Icons.golf_course),
      icon: Icon(Icons.bookmark_border),
      label: 'discover',
    ),
  ];
  askPermission() async {
    // var status = await Permission.camera.status;
    var status = await Permission.activityRecognition.request();
    //await Permission.activityRecognition.request().isGranted;
    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              selectedIndex = index;
            });
          },
          selectedIndex: selectedIndex,
          destinations: destinations,
        ),
        body: _screens[selectedIndex],
      ),
    );
  }
}
