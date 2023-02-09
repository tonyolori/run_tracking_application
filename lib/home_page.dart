import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'components/location_service.dart';
import 'constants.dart';
import 'Step_page.dart';
import 'package:flutter/material.dart';
import 'map_page.dart';
import 'package:pedometer/pedometer.dart';
import 'settings_page.dart';


class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int selectedIndex = 0;

  final List<Widget> _screens = [
    MapTrackingPage(),
    RunTracking(),
    SettingsPage(),
  ];
  askPermission() async {
    // var status = await Permission.camera.status;
    var status = await Permission.activityRecognition.request();
    //await Permission.activityRecognition.request().isGranted;
    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
    }

    print('status =');
    print(status);
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
            destinations: const <Widget>[
              NavigationDestination(
                icon: Icon(Icons.explore),
                label: 'Explore',
              ),
              NavigationDestination(
                icon: Icon(Icons.commute),
                label: 'Commute',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.bookmark),
                icon: Icon(Icons.bookmark_border),
                label: 'Saved',
              ),
            ]),
        body: _screens[selectedIndex],
      ),
    );
  }
}



// ElevatedButton(
//                 onPressed: () async {
//                   await askPermission();
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => RunTracking()),
//                   );
//                 },
//                 child: const Text('Launch steps'),
//               ),