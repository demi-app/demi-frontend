import 'package:flutter/material.dart';

class Milestone {
  final String id;
  final String iconName;
  final String description;
  final String progress;
  final String goal_id;

  Milestone({
    required this.id,
    required this.iconName,
    required this.description,
    required this.progress,
    required this.goal_id,
  });

  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      id: json['id'],
      iconName: json['icon'],
      description: json['description'],
      progress: json['progress'],
      goal_id: json['milestone_id'],
    );
  }
}

class MilestoneCard extends StatelessWidget {
  final Milestone milestone;

  const MilestoneCard({
    Key? key,
    required this.milestone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The icon and color are now directly retrieved from the Milestone object
    return Card(
      child: ListTile(
        leading: Icon(Icons.circle),
        title: Text(milestone.description),
        subtitle: Text(milestone.progress),
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