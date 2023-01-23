//import 'dart:html';
// ignore_for_file: avoid_print

import 'package:fit_work/activity_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'run_tracking.dart';
import 'package:flutter/material.dart';
import 'map_tracking.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Pedometer example app'),
      ),
      body: Homepage(),
    ));
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const MapTrackingPage(),
                ),
              );
            },
            child: const Text('Launch maps'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PermissionAsking(),
                ),
              );
            },
            child: const Text('Launch steps'),
          ),
        ],
      ),
    );
  }
}

class PermissionAsking extends StatefulWidget {
  const PermissionAsking({super.key});

  @override
  State<PermissionAsking> createState() => _PermissionAskingState();
}

class _PermissionAskingState extends State<PermissionAsking> {
  askPermission() async {
    // var status = await Permission.camera.status;
    var status = await Permission.activityRecognition.request();

    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
    }

// // You can can also directly ask the permission about its status.
//     //   if (await Permission.location.isRestricted) {
//     //     // The OS restricts access, for example because of parental controls.
//     //   }
//     //   // PermissionStatus status = await Permission.contacts.request();
//     //   // if(status .isDenied == true)
//     //   //   {
//     //   //     askPermission();
//     //   //   }
//     //   // else
//     //   //   {
//     //   //     return true;
//     //   //   }
//     print('status =');
//     print(status);
//     return true;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        child: const Text('Open route'),
        onPressed: () async {
          await askPermission();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => runTracking()),
          );
          //  Navigate to second route when tapped.
        });
  }
}
