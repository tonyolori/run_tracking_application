import 'package:flutter/material.dart';
import 'package:d_chart/d_chart.dart';
import 'package:provider/provider.dart';
import '../components/dummy_data.dart';
import '../components/step_helper.dart';
import '../constants.dart';
import '../db/step_db.dart';
import '../components/graph_helper.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  List<Map<String, dynamic>> constructedStepBar = [];
  List<Map<String, dynamic>> constructedCalorieBar = [];

  // void addListener() {
  //   context.read<StepHelper>().addListener(updateBarValues);
  // }

  // void removeListener() {
  //   context.read<StepHelper>().removeListener(updateBarValues);
  // }

  void updateBarValues() {
    constructedStepBar = context.read<GraphHelper>().stepBarData;
    constructedCalorieBar = context.read<GraphHelper>().calorieBarData;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    //addListener();
    updateBarValues();
    //? example
    //DB.init().then((value) => _fetchEntries());
  }

  @override
  void dispose() {
    //removeListener();
    super.dispose();
  }

  String dropdownValue = 'Monthly';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Progress"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0, right: 20.0),
                child: SizedBox(
                  height: 50,
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    onChanged: (String? newValue) async {
                      context.read<GraphHelper>().choice = newValue!;
                      await context
                          .read<GraphHelper>()
                          .constructBarData(newValue);
                      setState(() {
                        dropdownValue = newValue;
                      });
                    }, //stop at trying to create weekly graph
                    items: <String>[
                      'Monthly',
                      'Daily',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            Text(
              "Weight ",
              style: graphLabel,
            ),
            AspectRatio(
              aspectRatio: 4 / 3,
              child: DChartLine(
                // animate: true,
                areaColor: (lineData, index, id) => Colors.grey,
                lineWidth: 5.0,
                //animationDuration: const Duration(seconds: 1),
                includeArea: true,
                includePoints: true,
                data: const [
                  {
                    'id': 'Line',
                    'data': [
                      {'domain': 0, 'measure': 70},
                      {'domain': 1.5, 'measure': 67},
                      {'domain': 2, 'measure': 65},
                      {'domain': 3, 'measure': 66},
                      {'domain': 4, 'measure': 68},
                    ],
                  },
                ],
                lineColor: (lineData, index, id) => Colors.amber,
              ),
            ),
            _whitespace(),
            Text(
              "Steps",
              style: graphLabel,
            ),
            AspectRatio(
              aspectRatio: 4 / 3,
              child: DChartBar(
                data: constructedStepBar,
                domainLabelPaddingToAxisLine: 16,
                axisLineTick: 2,
                axisLinePointTick: 2,
                axisLinePointWidth: 10,
                axisLineColor: Colors.black,
                measureLabelPaddingToAxisLine: 16,
                barColor: (barData, index, id) => Colors.black,
                showBarValue: true,
              ),
            ),
            _whitespace(),
            Text(
              "Calories burned",
              style: graphLabel,
            ),
            AspectRatio(
              aspectRatio: 4 / 3,
              child: DChartBar(
                data: dummyCalorieData,//constructedCalorieBar,
                domainLabelPaddingToAxisLine: 16,
                axisLineTick: 2,
                axisLinePointTick: 2,
                axisLinePointWidth: 10,
                axisLineColor: Colors.black,
                measureLabelPaddingToAxisLine: 16,
                barColor: (barData, index, id) => Colors.black,
                showBarValue: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox _whitespace() {
    return const SizedBox(
      height: 30,
      width: 10,
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     constructedBar = context.read<StepHelper>().constructedbar;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Progress"),
//       ),
//       body: Column(
//         children: [
//           SizedBox(
//             height: 100,
//           ),
//           Expanded(
//             child: Center(
//               child:  AspectRatio(
//                       aspectRatio: 4 / 3,
//                       child: DChartBar(
//                         data: constructedBar,
//                         domainLabelPaddingToAxisLine: 16,
//                         axisLineTick: 2,
//                         axisLinePointTick: 2,
//                         axisLinePointWidth: 10,
//                         axisLineColor: Colors.black,
//                         measureLabelPaddingToAxisLine: 16,
//                         barColor: (barData, index, id) => Colors.black,
//                         showBarValue: true,
//                       ),
//                     )
//             ),
//           ),
//         ],
//       ),
//     );
//   }

// }
