import 'package:flutter/material.dart';

class MissionsTabContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Return the current content for the Missions tab
    // Which is the ListView of tasks you had in your original MyHomePage
    return ListView(
      children: <Widget>[
        TaskCard(
          icon: Icons.watch_later,
          title: 'Draw for 50min',
          time: '7:30pm-8:50pm',
          color: Colors.blue,
          onInspirationTap: () {
            // Placeholder callback
          },
          onHowToTap: () {
            // Placeholder callback
          },
          onRescheduleTap: () {
            // Placeholder callback
          },
        ),
        TaskCard(
          icon: Icons.brush,
          title: 'Draw a magical forest creature',
          time: '7:30pm-8:15pm',
          color: Colors.purple,
          onInspirationTap: () {
            // Placeholder callback
          },
          onHowToTap: () {
            // Placeholder callback
          },
          onRescheduleTap: () {
            // Placeholder callback
          },
        ),
        TaskCard(
          icon: Icons.gesture,
          title: 'Draw detailed hands & feet',
          time: '7:30pm-8:00pm',
          color: Colors.blue,
          onInspirationTap: () {
            // Placeholder callback
          },
          onHowToTap: () {
            // Placeholder callback
          },
          onRescheduleTap: () {
            // Placeholder callback
          },
        ),
      ],
    );
  }
}

class TaskCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String time;
  final Color color;
  final VoidCallback onInspirationTap;
  final VoidCallback onHowToTap;
  final VoidCallback onRescheduleTap;

  const TaskCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.time,
    required this.color,
    required this.onInspirationTap,
    required this.onHowToTap,
    required this.onRescheduleTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(title),
        subtitle: Text(time),
        trailing: Wrap(
          spacing: 12, // space between two icons
          children: <Widget>[
            TextButton.icon(
              onPressed: onInspirationTap, // Handle inspiration
              icon: Icon(Icons.lightbulb_outline, size: 18),
              label: Text('Inspiration'),
            ),
            TextButton.icon(
              onPressed: onHowToTap, // Handle how-to
              icon: Icon(Icons.play_circle_fill, size: 18),
              label: Text('How-To'),
            ),
            TextButton.icon(
              onPressed: onRescheduleTap, // Handle reschedule
              icon: Icon(Icons.schedule, size: 18),
              label: Text('Reschedule'),
            ),
          ],
        ),
      ),
    );
  }
}
