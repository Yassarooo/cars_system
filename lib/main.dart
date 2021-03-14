import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'UI/HomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Cars Management System",
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(accentColor: Colors.white, brightness: Brightness.dark),
    );
  }
}