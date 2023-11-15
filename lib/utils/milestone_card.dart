import 'package:flutter/material.dart';

class Milestone {
  final String iconName;
  final String title;
  final String time;
  final String colorCode;

  Milestone({
    required this.iconName,
    required this.title,
    required this.time,
    required this.colorCode,
  });

  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      iconName: json['icon'],
      title: json['title'],
      time: json['time'],
      colorCode: json['color'],
    );
  }

  IconData get iconData {
    // Convert the iconName string to IconData
    return iconMap[this.iconName] ?? Icons.error;
  }

  Color get colorData {
    // Convert the colorCode string to Color
    return colorMap[this.colorCode] ?? Colors.grey;
  }
}

// Example of a map that converts string to IconData
final Map<String, IconData> iconMap = {
  'watch_later': Icons.watch_later,
  // Add other mappings here
};

// Example of a map that converts string to Color
final Map<String, Color> colorMap = {
  'blue': Colors.blue,
  'red': Colors.red,
  // Add other color mappings here
};

class MilestoneCard extends StatelessWidget {
  final String iconName;
  final String title;
  final String time;
  final String colorCode;

  const MilestoneCard({
    Key? key,
    required this.iconName,
    required this.title,
    required this.time,
    required this.colorCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData icon = iconMap[iconName] ?? Icons.error;
    Color color = colorMap[colorCode] ?? Colors.grey;

    // Now return a proper widget
    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        subtitle: Text(time),
        // Add other ListTile properties as needed
      ),
    );
  }
}
