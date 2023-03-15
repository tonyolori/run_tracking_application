import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import '../constants.dart';

class statisticsPage extends StatefulWidget {
  const statisticsPage({super.key});

  @override
  State<statisticsPage> createState() => _statisticsPageState();
}

class _statisticsPageState extends State<statisticsPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            "Overview",
            style: labelBold,
          ),
          const rowWidget(iconlabel: Icons.bolt_outlined,mainString: "0",labelString: "Activities",)
        ],
      ),
    );
  }
}

class rowWidget extends StatelessWidget {
  final IconData iconlabel;
  final String mainString;
  final String labelString;

  const rowWidget({
    super.key,
    required this.iconlabel,
    required this.mainString,
    required this.labelString
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(iconlabel),
        Column(
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
        Icon(iconlabel),
        Column(
          children: [
            Text(mainString, style: labelBold),
            Text(
              labelString,
              style: labelStyle,
            ),
          ],
        ),
      ],
    );
  }
}
