import 'package:flutter/material.dart';
import 'package:d_chart/d_chart.dart';
import 'package:provider/provider.dart';
import '../components/step_helper.dart';
import '../database/step_data.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  late DatabaseCrud database;
  List<Map<String, dynamic>> constructedBar = [];
  List<Map<String, dynamic>> constructedBarWeekly = [];


  void addListener() {
    context.read<StepHelper>().addListener(updateBarValues);
  }

  void removeListener() {
    context.read<StepHelper>().removeListener(updateBarValues);
  }

  void updateBarValues() {
    constructedBar = context.read<StepHelper>().constructedbar;
    constructedBarWeekly = context.read<StepHelper>().constructedbarweekly;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    addListener();
  }

  @override
  void dispose() {
    //removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String dropdownValue = 'Yearly';

    return Scaffold(
      appBar: AppBar(
        title: Text("Progress"),
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0, right: 20.0),
              child: SizedBox(
                height: 50,
                child: DropdownButton<String>(
                  value: dropdownValue,
                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },//stop at trying to create weekly graph
                  items: <String>[
                    'Yearly',
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
          Center(
            child: AspectRatio(
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
          ),
        ],
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







