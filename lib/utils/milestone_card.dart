import 'package:flutter/material.dart';

class Milestone {
  final String id;
  //final String iconName;
  final String description;
  final double progress;
  final String goalId;

  Milestone({
    required this.id,
    //required this.iconName,
    required this.description,
    required this.progress,
    required this.goalId,
  });

  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      id: json['id'],
      //iconName: json['icon'],
      description: json['description'],
      progress: json['progress'],
      goalId: json['milestone_id'],
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
                  "Goal title",
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
                  value: milestone.progress,
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
