//import 'dart:html';
// ignore_for_file: avoid_print

import 'package:provider/provider.dart';
import 'components/location_service.dart';
import 'constants.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'pages/home_page.dart';
import 'package:fit_work/components/step_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

  var liveTrackingToggle = true;

class _MyAppState extends State<MyApp> {
  
  @override
  Widget build(BuildContext context) {
    //dynamic locator = LocationService();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationService()),
        Provider.value(value: Pedometer),
        Provider.value(value: StepService()),
        //Provider.value(value: liveTrackingToggle),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
          theme: lightTheme,
          home:  const Homepage(),
    ));
  }
}
