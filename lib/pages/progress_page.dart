import 'package:fit_work/components/step_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:d_chart/d_chart.dart';
import 'package:provider/provider.dart';
import '../components/step_helper.dart';

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
          data: context.read<StepHelper>().constructedbar,
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