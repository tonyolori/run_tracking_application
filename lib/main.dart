//import 'dart:html';
// ignore_for_file: avoid_print

import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:fit_work/activity_recognition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'components/location_service.dart';
import 'constants.dart';
import 'Step_page.dart';
import 'package:flutter/material.dart';
import 'map_page.dart';
import 'package:pedometer/pedometer.dart';
import 'home_page.dart';

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
    //dynamic locator = LocationService();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationService()),
        Provider.value(value: Pedometer),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
          theme: lightTheme,
          home:  const Homepage(),
    ));
  }
}
