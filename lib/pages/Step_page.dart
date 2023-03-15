// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:fit_work/constants.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:fit_work/components/step_service.dart';
import '../components/step_helper.dart';
import '../database/step_data.dart';
import '../components/step_helper.dart' as helper;
import '../database/step.dart' as step;

class RunTracking extends StatefulWidget {
  const RunTracking({super.key});

  @override
  _RunTrackingState createState() => _RunTrackingState();
}

class _RunTrackingState extends State<RunTracking> {
  late Stream<StepCount> _stepCountStream;
  String _status = '?', _steps = '?';
  late DatabaseCrud database;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  void initPlatformState() {
    // _stepCountStream = Pedometer.stepCountStream;
    ////Pedometer _pedometer = Provider.of<Pedometer>(context, listen: false);
    ////_stepCountStream = _pedometer.stepCountStream;
    //_stepCountStream.listen(onStepCount).onError(onStepCountError);

    _steps = context.read<StepHelper>().steps;
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    print(((int.parse(_steps)* 100) ~/ 8000 ));
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    "Steps",
                    style: TextStyle(fontSize: 48),
                  ),
                  OutlinedButton(
                    onPressed: () async {},
                    child: Text("press me"),
                  )
                ],
              ),
              SizedBox(
                height: kBoxSize,
                width: kBoxSize,
                child: Stack(
                  children: [
                    CircularStepProgressIndicator(
                      totalSteps: 100,
                      currentStep: ((int.parse(_steps)* 100) ~/ 8000 ),
                      stepSize: 15,
                      selectedColor: Colors.greenAccent,
                      unselectedColor: Colors.grey[200],
                      circularDirection: CircularDirection.clockwise,
                      startingAngle: kPI - kPI / 4, //4.71239,
                      arcSize: kPI * 1.5,
                      padding: 0,
                      width: kBoxSize,
                      height: kBoxSize,
                      selectedStepSize: 15,
                      roundedCap: (_, __) => true,
                    ),
                    Center(
                      child: Text(
                        _steps,
                        style: TextStyle(
                          height: null,
                          fontSize: 70,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 20,
                        left: 70,
                        right: 70,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              association(
                                label: "Duration",
                                value: "5H",
                              ),
                              association(
                                label: "Steps",
                                value: _steps,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SmallIcon(),
                  SmallIcon(),
                ],
              )
              //ElevatedButton(onPressed: onPressed, child: child)
            ],
          ),
        ),
      ),
    );
  }
}

class SmallIcon extends StatelessWidget {
  const SmallIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: 100,
        height: 70,
        decoration: BoxDecoration(color: Colors.greenAccent),
        child: Center(
          child: Row(children: [
            Icon(Icons.local_fire_department),
            Text("KM"),
          ]),
        ),
      ),
    );
  }
}

class association extends StatelessWidget {
  String label;
  String value;
  association({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
        ),
        Text(
          value,
          style: TextStyle(
            height: null,
            fontSize: 24,
          ),
        ),
      ],
    );
  }
}
