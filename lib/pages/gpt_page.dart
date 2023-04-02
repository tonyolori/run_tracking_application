// import 'package:flutter/material.dart';
// import 'package:fit_work/constants.dart';
// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:provider/provider.dart';
// import 'package:step_progress_indicator/step_progress_indicator.dart';
// import '../components/step_helper.dart';
// import '../database/step_data.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:d_chart/d_chart.dart';

// class ProgressPage extends StatefulWidget {
//   @override
//   _ProgressPageState createState() => _ProgressPageState();
// }

// class _ProgressPageState extends State<ProgressPage> {
//   bool _isSwitched = false;

//   @override
//   Widget build(BuildContext context) {
//     constructedBar = context.read<StepHelper>().constructedbar;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Progress"),
//         actions: [
//           IconButton(
//             icon: _isSwitched
//                 ? Icon(Icons.format_list_bulleted_outlined)
//                 : Icon(Icons.view_module_outlined),
//             onPressed: () {
//               setState(() {
//                 _isSwitched = !_isSwitched;
//               });
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           SizedBox(
//             height: 100,
//           ),
//           Center(
//             child: _isSwitched
//                 ? AspectRatio(
//                     aspectRatio: 4 / 3,
//                     child: DChartBar(
//                       data: constructedBar,
//                       domainLabelPaddingToAxisLine: 16,
//                       axisLineTick: 2,
//                       axisLinePointTick: 2,
//                       axisLinePointWidth: 10,
//                       axisLineColor: Colors.black,
//                       measureLabelPaddingToAxisLine: 16,
//                       barColor: (barData, index, id) => Colors.black,
//                       showBarValue: true,
//                     ),
//                   )
//                 : GridView.count(
//                     crossAxisCount: 2,
//                     mainAxisSpacing: 10,
//                     crossAxisSpacing: 10,
//                     padding: EdgeInsets.all(10),
//                     children: List.generate(
//                       4,
//                       (index) => Container(
//                         color: Colors.grey[300],
//                         child: Center(
//                           child: Text(
//                             "Grid Item ${index + 1}",
//                             style: TextStyle(fontSize: 20),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//           ),
//         ],
//       ),
//     );
//   }
// }
