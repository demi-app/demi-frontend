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
  final VoidCallback? onSelect;
  final bool showSelectButton;

  const GoalCard({
    Key? key,
    required this.goal,
    this.onSelect,
    this.showSelectButton = true,
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
                  goal.description,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                if (showSelectButton)
                  ElevatedButton(
                    onPressed: onSelect,
                    child: Text('Select'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
