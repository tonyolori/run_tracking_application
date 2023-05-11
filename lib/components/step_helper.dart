import 'dart:math';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../db/step_db.dart';
import '../model/step_model.dart' as step;
import 'package:pedometer/pedometer.dart';

//enum TimeFrame {year,month, week }
final List<String> timeframe = <String>[
  'Monthly',
  'Daily',
];

class StepHelper with ChangeNotifier {
  bool databasefilled =
      false; //change this to be gotten from shared preferences

  List<step.Step> availableSteps = [];
  //db
  late Stream<StepCount> _pedometer;
  late var _subscription;
  int todaysteps = 0;
  String steps = "0";

  //get barData ->

  StepHelper() {
    _innit();
  }
  _innit() async {
    startListening();
  }

  void startListening() async {
    await Permission.activityRecognition.request().isGranted;
    _pedometer = Pedometer.stepCountStream;
    _subscription = _pedometer.listen(
      _onStepCount,
      onError: _onError,
      onDone: _onDone,
      cancelOnError: true,
    );
  }

  void stopListening() {
    _subscription.cancel();
  }

  void _onDone() => print("Finished pedometer tracking");
  void _onError(error) => print("Flutter Pedometer Error: $error");

  void _onStepCount(StepCount event) {
    steps = event.steps.toString();
    print("Stephelper:$steps");
    notifyListeners();
  }

}
