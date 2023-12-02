import 'package:flutter/material.dart';

class Milestone {
  final String id;
  final String name;
  final String description;
  final double xpRequired;
  final String category;

  Milestone({
    required this.id,
    required this.name,
    required this.description,
    required this.xpRequired,
    required this.category,
  });

  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      xpRequired: json['progress'],
      category: json['milestone_id'],
    );
  }
}

class MilestoneCard extends StatelessWidget {
  final Milestone milestone;
  final double progress;

  const MilestoneCard({
    Key? key,
    required this.milestone,
    required this.progress,
  }) : super(key: key);

  double userProgress(numerator, denominator) {
    double result = numerator / denominator;
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  milestone.name,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  milestone.description,
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 16.0),
                LinearProgressIndicator(
                  value: userProgress(progress, milestone.xpRequired),
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
