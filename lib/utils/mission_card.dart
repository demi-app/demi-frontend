import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Mission {
  final String id;
  final String description;
  final int xpValue;
  final Duration time;
  final String inspiration;
  final String howTo;
  bool isSelected;

  Mission({
    required this.id,
    required this.description,
    required this.xpValue,
    required this.time,
    required this.inspiration,
    required this.howTo,
    this.isSelected = false, // default value
  });

  factory Mission.fromJson(Map<String, dynamic> json) {
    // Parsing dates as an example, adjust based on your actual date format
    return Mission(
      id: json['id'],
      description: json['description'],
      xpValue: json['xpValue'],
      time: json['time'],
      inspiration: json['inspiration'],
      howTo: json['howTo'],
    );
  }
}

class MissionCard extends StatelessWidget {
  final Mission mission;
  final VoidCallback? onSelect;
  final VoidCallback onInspiration;
  final VoidCallback onHowTo;
  final VoidCallback onReschedule;
  final DateTime preferredTime;
  final String type;

  const MissionCard({
    Key? key,
    required this.mission,
    required this.onSelect,
    required this.onInspiration,
    required this.onHowTo,
    required this.onReschedule,
    required this.preferredTime,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: Column(
        children: [
          ListTile(
            title: Text(mission.description),
            subtitle: Text(
              "${DateFormat.jm().format(preferredTime)} - ${DateFormat.jm().format(preferredTime.add(mission.time))}",
            ),
            trailing: ElevatedButton(
              onPressed: onSelect,
              child: Text(type),
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
