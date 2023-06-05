// ignore_for_file: unused_import
import 'package:provider/provider.dart';
import 'components/location_service.dart';
import 'constants.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'pages/home_page.dart';
import 'components/graph_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'widget_tree.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
          ChangeNotifierProvider(
            create: (_) => LocationService(),
            lazy: false,
          ),
          ChangeNotifierProvider(
            create: (_) => GraphHelper(),
            lazy: false,
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          home: const WidgetTree(),
        ));
  }
}
