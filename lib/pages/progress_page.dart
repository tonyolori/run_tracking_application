import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:d_chart/d_chart.dart';
import 'package:provider/provider.dart';
import '../components/step_helper.dart';
import '../database/step_data.dart';
import '../database/step.dart' as step;

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  late DatabaseCrud database;
  List<Map<String, dynamic>> constructedBar = [];

  void addListener() {
    context.read<StepHelper>().addListener(updateBarValues);
  }

  void removeListener() {
    context.read<StepHelper>().removeListener(updateBarValues);
  }

  void updateBarValues() {
    constructedBar = context.read<StepHelper>().constructedbar;

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
    constructedBar = context.read<StepHelper>().constructedbar;

    return Scaffold(
      appBar: AppBar(
        title: Text("Progress"),
      ),
      body: Column(
        children: [
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
