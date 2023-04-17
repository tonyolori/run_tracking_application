import 'package:flutter/material.dart';
import 'package:d_chart/d_chart.dart';
import 'package:provider/provider.dart';
import '../components/step_helper.dart';
import '../db/step_db.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  List<Map<String, dynamic>> constructedBar = [];

  // void addListener() {
  //   context.read<StepHelper>().addListener(updateBarValues);
  // }

  // void removeListener() {
  //   context.read<StepHelper>().removeListener(updateBarValues);
  // }

  void updateBarValues() {
    constructedBar = context.read<StepHelper>().constructedbar;
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
                      context.read<StepHelper>().choice = newValue!;
                      await context
                          .read<StepHelper>()
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
            Text("Steps"),
            AspectRatio(
              aspectRatio: 4 / 3,
              child: DChartBar(
                data: constructedBar,
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
            const SizedBox(
              height: 30,
              width: 10,
            ),
            Text("Calories burned"),
            AspectRatio(
              aspectRatio: 4 / 3,
              child: DChartBar(
                data: constructedBar,
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
            const SizedBox(
              height: 30,
              width: 10,
            ),
            AspectRatio(
              aspectRatio: 4 / 3,
            child: DChartLine(
              animate: true,
              areaColor: (lineData, index, id) => Colors.grey,
              lineWidth: 5.0,
              //animationDuration: ,
              data: const [
                {
                  'id': 'Line',
                  'data': [
                    {'domain': 0, 'measure': 4.1},
                    {'domain': 2, 'measure': 4},
                    {'domain': 3, 'measure': 6},
                    {'domain': 4, 'measure': 1},
                  ],
                },
              ],
              lineColor: (lineData, index, id) => Colors.amber,
            ),
            ),
          ],
        ),
      ),
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
