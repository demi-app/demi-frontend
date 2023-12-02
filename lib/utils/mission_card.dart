import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';

class Mission {
  final String id;
  final String description;
  final int xpValue;
  final DateTime createdAt;
  final String inspiration;
  final String howTo;
  final String category;

  Mission({
    required this.id,
    required this.description,
    required this.xpValue,
    required this.createdAt,
    required this.inspiration,
    required this.howTo,
    required this.category,
  });

  factory Mission.fromJson(Map<String, dynamic> json) {
    // Parsing dates as an example, adjust based on your actual date format
    return Mission(
      id: json['id'],
      description: json['description'],
      xpValue: json['xpValue'],
      createdAt: json['createdAt'],
      inspiration: json['inspiration'],
      howTo: json['howTo'],
      category: json['category'],
    );
  }
}

class MissionCard extends StatelessWidget {
  final Mission mission;
  final VoidCallback? onSelect;
  final VoidCallback onInspiration;
  final VoidCallback onHowTo;
  final VoidCallback onReschedule;
  final DateTime startTime;
  final DateTime endTime;
  final String selectionReason;

  const MissionCard({
    Key? key,
    required this.mission,
    required this.onSelect,
    required this.startTime,
    required this.endTime,
    required this.selectionReason,
    required this.onInspiration,
    required this.onHowTo,
    required this.onReschedule,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Column(
        children: [
          ListTile(
            title: Text(mission.description),
            //subtitle: Text(
            //  "${DateFormat.jm().format(preferredTime)} - ${DateFormat.jm().format(preferredTime.add(mission.time))}",
            //),
            trailing: ElevatedButton(
              onPressed: onSelect,
              child: Text(selectionReason),
            ),
          ),
          ButtonBar(
            children: [
              TextButton(
                onPressed: onInspiration,
                child: Text('Inspiration'),
              ),
              TextButton(
                onPressed: onHowTo,
                child: Text('How-To'),
              ),
              TextButton(
                onPressed: onReschedule,
                child: Text('Reschedule'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
