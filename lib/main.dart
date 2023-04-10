import 'package:fit_work/components/step_helper.dart';
import 'package:provider/provider.dart';
import 'components/location_service.dart';
import 'constants.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'pages/home_page.dart';
import 'database/user_data.dart';

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
          ChangeNotifierProvider(create: (_) => LocationService(), lazy: false,),
          Provider.value(value: Pedometer),
          ChangeNotifierProvider(
            create: (_) => StepHelper(),
            lazy: true,
          ),
          Provider(
            create: (_)=>User(),
            lazy: false,
            )
          //Provider.value(value: liveTrackingToggle),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          home: const Homepage(),
        ));
  }
}
