// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:pedometer/pedometer.dart';
import '../database/step_data.dart' as database;
import 'dart:async';

class StepService {
  late Stream<StepCount> _pedometer;
  late var _subscription;
  late int todaysteps;
  late String _steps;
  //void function onstepcount;

  // you can change this to have onstep count in the params for 
  // easy setstate calling
  void startListening() {
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

  StepService() {
    //startListening();
  }

  void _onDone() => print("Finished pedometer tracking");
  void _onError(error) => print("Flutter Pedometer Error: $error");

  void _onStepCount(StepCount event) {
    _steps = event.steps.toString();
  }
}

void main(List<String> args) {
  DateTime time = DateTime.now();
  print(time.month);
}
