// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print

import 'package:fit_work/constants.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import '../components/step_helper.dart';
import '../db/step_db.dart';

class RunTracking extends StatefulWidget {
  const RunTracking({super.key});

  @override
  _RunTrackingState createState() => _RunTrackingState();
}

class _RunTrackingState extends State<RunTracking> {
  String _status = '?', _steps = '?';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void initPlatformState() {
    _steps = context.read<StepHelper>().steps;
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text("Step Page"),
    ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(onPressed: (){}, child: Text("Add steps")),
            OutlinedButton(onPressed: (){}, child: Text("Remove steps")),
            OutlinedButton(onPressed: (){}, child: Text("Reset")),

          ],
        ),
        Text(
          "Steps",
          style: TextStyle(fontSize: 48),
        ),
        SizedBox(
          height: 40,
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            CircularStepProgressIndicator(
              totalSteps: 100,
              currentStep: ((int.parse(context.watch<StepHelper>().steps) * 100) ~/ 8000),//33,
              stepSize: 15,
              selectedColor: Colors.greenAccent,
              unselectedColor: Colors.grey[200],
              circularDirection: CircularDirection.clockwise,
              startingAngle: kPI - kPI / 4,
              arcSize: kPI * 1.5,
              padding: 0,
              width: kBoxSize,
              height: kBoxSize,
              selectedStepSize: 15,
              roundedCap: (_, __) => true,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  context.watch<StepHelper>().steps,
                  style: TextStyle(
                    height: null,
                    fontSize: 70,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Association(
                      label: "Duration",
                      value: "5H",
                    ),
                    Association(
                      label: "Steps",
                      value: "8000"//_steps,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );
}
}

//? my former build
  // @override
  // Widget build(BuildContext context) {
  //   //print(((int.parse(_steps)) ~/ 80 ));
  //   return SafeArea(
  //     child: Scaffold(
  //       appBar: AppBar(
  //         title: Text("Step Page"),
  //       ),
  //       body: Column(
  //         // mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: <Widget>[
  //           Row(
  //             children: [
  //               Text(
  //                 "Steps",
  //                 style: TextStyle(fontSize: 48),
  //               ),
  //             ],
  //           ),
  //           SizedBox(
  //             height: 120,
  //           ),
  //           Align(
  //             alignment: FractionalOffset.bottomCenter,
  //             child: SizedBox(
  //               height: kBoxSize,
  //               width: kBoxSize,
  //               child: StepWidget(steps: _steps),
  //             ),
  //           ),
  //           // Row(
  //           //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           //   children: [
  //           //     SmallIcon(),
  //           //     SmallIcon(),
  //           //   ],
  //           // )
  //         ],
  //       ),
  //     ),
  //   );
  // }
//}

class StepWidget extends StatelessWidget {
  const StepWidget({
    super.key,
    required String steps,
  }) : _steps = steps;

  final String _steps;

  @override
  Widget build(BuildContext context) {
    return Stack(
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
            context.watch<StepHelper>().steps,
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
                  Association(
                    label: "Duration",
                    value: "5H",
                  ),
                  Association(
                    label: "Steps",
                    value: _steps,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SmallIcon extends StatelessWidget {
  const SmallIcon({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class Association extends StatefulWidget {
  String label;
  String value;
  Association({super.key, required this.label, required this.value});

  @override
  State<Association> createState() => _AssociationState();
}

class _AssociationState extends State<Association> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.label,
        ),
        Text(
          widget.value,
          style: TextStyle(
            height: null,
            fontSize: 24,
          ),
        ),
      ],
    );
  }
}
