import 'package:flutter/material.dart';
import 'package:d_chart/d_chart.dart';
import "package:fit_work/components/calorie_worker.dart";
import '../constants.dart';
import '../db/calorie_db.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  List<Map<String, dynamic>> constructedCalorieBar = [];
  CalorieWorker calorieWorker = CalorieWorker();

  _innit() async {
    // await CalorieDatabase.innit().then((value) => constructBarData('Monthly'));//calorieWorker.fillDatabase()
    await CalorieDatabase.innit().then((value) => calorieWorker.fillDatabase());
    constructBarData('Monthly');
    if (mounted) setState(() {});
  }

  constructBarData(String choice) async {
    constructedCalorieBar = await calorieWorker.constructBarData(choice);
    if (mounted) setState(() {});

    return;
  }

  @override
  void initState() {
    super.initState();
    _innit();
  }

  @override
  void dispose() {
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
                      await constructBarData(newValue!);
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
              "Calories burned",
              style: graphLabel,
            ),
            AspectRatio(
              aspectRatio: 4 / 3,
              child: DChartBar(
                data:
                    constructedCalorieBar, //dummyCalorieData,//? you have go fix thislater
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
            _whitespace(),
            Text(
              "Weight ",
              style: graphLabel,
            ),
            // OutlinedButton(onPressed: (){
            //       await CalorieDatabase.innit().then((value) => calorieWorker.fillDatabase());

            // }, child: Text("print database"))
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
          ],
        ),
      ),
    );
  }

  SizedBox _whitespace() {
    return const SizedBox(
      height: 50,
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
