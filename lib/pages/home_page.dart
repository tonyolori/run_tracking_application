import 'package:fit_work/db/user_db.dart';
import 'package:permission_handler/permission_handler.dart';
import '../constants.dart';
import 'Step_page.dart';
import 'package:flutter/material.dart';
import 'maps_home.dart';
import 'settings_page.dart';
import 'progress_page.dart';
import 'user_page.dart';
import '../model/user_model.dart';
import 'firebase_page.dart';
class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int selectedIndex = 0;

  final List<Widget> _screens = [
    MapHomePage(),
    const RunTracking(),
    const ProgressPage(),
    const SettingsPage(),
    const FirebasePage(),
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

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Row(
  //       children: <Widget>[
  //         // create a navigation rail
  //         NavigationRail(
  //           selectedIndex: selectedIndex,
  //           onDestinationSelected: (int index) {
  //             setState(() {
  //               selectedIndex = index;
  //             });
  //           },
  //           labelType: NavigationRailLabelType.selected,
  //           backgroundColor: Colors.green,
  //           destinations: const <NavigationRailDestination>[
  //             // navigation destinations
  //             NavigationRailDestination(
  //               icon: Icon(Icons.favorite_border),
  //               selectedIcon: Icon(Icons.favorite),
  //               label: Text('Wishlist'),
  //             ),
  //             NavigationRailDestination(
  //               icon: Icon(Icons.person_outline_rounded),
  //               selectedIcon: Icon(Icons.person),
  //               label: Text('Account'),
  //             ),
  //             NavigationRailDestination(
  //               icon: Icon(Icons.shopping_cart_outlined),
  //               selectedIcon: Icon(Icons.shopping_cart),
  //               label: Text('Cart'),
  //             ),
  //             NavigationRailDestination(
  //               icon: Icon(Icons.shopping_cart_outlined),
  //               selectedIcon: Icon(Icons.shopping_cart),
  //               label: Text('smart'),
  //             ),
  //             NavigationRailDestination(
  //               icon: Icon(Icons.shopping_cart_outlined),
  //               selectedIcon: Icon(Icons.shopping_cart),
  //               label: Text('dart'),
  //             ),
  //           ],
  //           selectedIconTheme: IconThemeData(color: Colors.white),
  //           unselectedIconTheme: IconThemeData(color: Colors.black),
  //           selectedLabelTextStyle: TextStyle(color: Colors.white),
  //         ),
  //         const VerticalDivider(thickness: 1, width: 2),
  //         Expanded(child: _screens[selectedIndex])
  //       ],
  //     ),
  //   );
  // }

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
            destinations: const <Widget>[
              NavigationDestination(
                icon: Icon(Icons.explore),
                label: 'Maps',
              ),
              NavigationDestination(
                icon: Icon(Icons.commit),
                label: 'Steps',
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
            ]),
        body: _screens[selectedIndex],
      ),
    );
  }
}
