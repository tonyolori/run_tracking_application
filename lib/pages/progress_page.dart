import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:d_chart/d_chart.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Progress"),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 4/3,
          child: DChartBar(
          data: const [
              {
                  'id': 'Bar',
                  'data': [
                      {'domain': 'jan', 'measure': 3},
                      {'domain': 'feb', 'measure': 4},
                      {'domain': 'march', 'measure': 6},
                      {'domain': 'april', 'measure': 0.3},
                      {'domain': 'may', 'measure': 3},
                      {'domain': 'june', 'measure': 4},
                      {'domain': 'july', 'measure': 6},
                      {'domain': 'Aug', 'measure': 0.3},
                      {'domain': 'Sept', 'measure': 3},
                      {'domain': 'Oct', 'measure': 4},
                      {'domain': 'Nov', 'measure': 6},
                      {'domain': 'Dec', 'measure': 0.3},
                  ],
              },
          ],
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
    );
  }
}