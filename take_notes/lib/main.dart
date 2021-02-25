import 'package:flutter/material.dart';
import 'package:take_notes/screens/homescreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Take Notes',
      home :HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }

}