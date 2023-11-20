import 'package:flutter/material.dart';

class Goal {
  final String id;
  final String description;

  Goal({
    required this.id,
    required this.description,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      description: json['description'],
    );
  }
}

class GoalCard extends StatelessWidget {
  final Goal goal;

  const GoalCard({
    Key? key,
    required this.goal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The icon and color are now directly retrieved from the Goal object
    return Card(
      child: ListTile(
        leading: Icon(Icons.circle),
        title: Text(goal.description),
      ),
    );
  }
}

// Example of a map that converts string to IconData
//final Map<String, IconData> iconMap = {
//  'watch_later': Icons.watch_later,
  // Add other mappings here
//};

// Example of a map that converts string to Color
//final Map<String, Color> colorMap = {
//  'blue': Colors.blue,
//  'red': Colors.red,
  // Add other color mappings here
//};