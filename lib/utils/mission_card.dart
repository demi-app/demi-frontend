import 'package:flutter/material.dart';

class Mission {
  final String id;
  final String description;
  final int xpValue;

  Mission({
    required this.id,
    required this.description,
    required this.xpValue,
  });

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
        id: json['id'],
        description: json['description'],
        xpValue: json['xpValue']);
  }
}

class MissionCard extends StatelessWidget {
  final Mission mission;
  final VoidCallback onSelect; // Callback for mission selection
  final bool isSelected;

  const MissionCard({
    Key? key,
    required this.mission,
    required this.onSelect,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The icon and color are now directly retrieved from the Mission object
    return Card(
      child: ListTile(
        leading: Icon(Icons.circle),
        title: Text(mission.description),
        subtitle: Text('${mission.xpValue} XP'),
        trailing: IconButton(
          icon: Icon(Icons.check_circle_outline),
          onPressed: onSelect,
        ),
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