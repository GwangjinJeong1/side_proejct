import 'package:flutter/material.dart';
import '../ready.dart';
import 'home_app.dart';
import 'home_web.dart';

class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    if (width < 1126 || height < 627) {
      return const ReadyPage();
    } else {
      return HomeWeb();
    }
  }
}
