import 'package:flutter/material.dart';
import 'package:animated_introduction/animated_introduction.dart';
import '../utils/goals.dart';
import 'home_page.dart';

class GoalsSelectionScreen extends StatefulWidget {
  @override
  _GoalsSelectionScreenState createState() => _GoalsSelectionScreenState();
}

class _GoalsSelectionScreenState extends State<GoalsSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedIntroduction(
        slides: pages,
        indicatorType: IndicatorType.circle,
        onDone: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
        },
      ),
    );
  }
}
