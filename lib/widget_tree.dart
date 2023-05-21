import 'auth.dart';
import 'pages/firebase_home.dart';
import 'pages/login_register_page.dart';
import 'package:flutter/material.dart';
import 'pages/home_page.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Homepage();
          } else {
            return LoginPage();
          }
        });
  }
}
