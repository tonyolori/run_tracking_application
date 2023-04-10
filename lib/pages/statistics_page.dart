import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import '../constants.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Overview",
                style: labelBold,
              ),
              const rowWidget(
                iconlabel: Icons.bolt_outlined,
                mainString: "0",
                labelString: "Activities",
                iconlabel2: Icons.local_fire_department,
                mainString2: "0",
                labelString2: "Calories",
              ),
              const rowWidget(
                iconlabel: Icons.timer_outlined,
                mainString: "0",
                labelString: "Duration",
                iconlabel2: Icons.location_on_outlined,
                mainString2: "0",
                labelString2: "Distance",
              ),
              const rowWidget(
                iconlabel: Icons.timelapse,
                mainString: "0",
                labelString: "Avg. Pace",
                iconlabel2: Icons.abc,
                mainString2: "0",
                labelString2: "Avg. Speed",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class rowWidget extends StatelessWidget {
  final IconData iconlabel;
  final String mainString;
  final String labelString;
  final IconData iconlabel2;
  final String mainString2;
  final String labelString2;

  const rowWidget({
    super.key,
    required this.iconlabel,
    required this.mainString,
    required this.labelString,
    required this.iconlabel2,
    required this.mainString2,
    required this.labelString2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 30,
          height: 30,
          child: Center(child: Icon(iconlabel)),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(mainString, style: labelBold),
            Text(
              labelString,
              style: labelStyle,
            ),
          ],
        ),
        const SizedBox(
          width: 20,
        ),
        SizedBox(
          width: 30,
          height: 30,
          child: Center(child: Icon(iconlabel2)),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(mainString2, style: labelBold),
            Text(
              labelString2,
              style: labelStyle,
            ),
          ],
        ),
      ],
    );
  }
}
