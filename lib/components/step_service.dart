// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:pedometer/pedometer.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class StepService {
  late Stream<StepCount> _pedometer;
  late var _subscription;
  late int todaysteps;
  late String _steps;
  //void function onstepcount;

  void startListening() {

    _pedometer = Pedometer.stepCountStream;
    _subscription = _pedometer.listen( 
      _onStepCount,
      onError: _onError,
      onDone: _onDone,
      cancelOnError: true,
    );
  }

  StepService() {
    //startListening();
  }

  void _onDone() => print("Finished pedometer tracking");
  void _onError(error) => print("Flutter Pedometer Error: $error");

  void _onStepCount(StepCount event) {
      _steps = event.steps.toString();
  }

  Future<int> getTodaySteps(int value) async {
    print(value);
    int savedStepsCount = 0; //TODO: get value from database

    int todayDayNo = 0; //=  get value from database
    if (value < savedStepsCount) {
      // Upon device reboot, pedometer resets. When this happens, the saved counter must be reset as well.
      savedStepsCount = 0;
      //TODO: persist this value using a package of your choice here
    }

    // load the last day saved using a package of your choice here
    int lastDaySavedKey = 888888;
    int lastDaySaved = 0; //TODO: get from database

    // When the day changes, reset the daily steps count
    // and Update the last day saved as the day changes.
    if (lastDaySaved < todayDayNo) {
      lastDaySaved = todayDayNo;
      savedStepsCount = value;

      //todo: persist
    }

    // setState(() {
    todaysteps = value - savedStepsCount;
    // });
    //todo persist
    //stepsBox.put(todayDayNo, todaySteps);
    return todaysteps; // this is your daily steps value.
  }

  void stopListening() {
    _subscription.cancel();
  }
}
