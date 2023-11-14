import 'package:flutter/material.dart';
import 'profile_header.dart'; // Replace with the actual file path

// Define the OverviewPage widget
class OverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Overview'),
      ),
      body: ListView(
        children: [
          // You can reuse the ProfileHeader widget if you've created one
          ProfileHeader(
            userName: 'Sebastian',
            avatarUrl:
                '/home/robertopupo/demi-frontend/assets/images/boomer.jpg',
            title: 'Flutter Developer',
          ),
          // Then list the overview cards
          OverviewCard(
            title: 'Anthropologist',
            description: 'Complete 8 missions with human subjects.',
            progress: '0/8',
            xp: 10,
          ),
          OverviewCard(
            title: '10 Day Streak',
            description: 'Nov10-Nov20',
            progress: '2/10',
          ),
          OverviewCard(
            title: 'Career Starter',
            description: 'Draw for 3 hours.',
            progress: '1/3h',
          ),
          // Add more overview cards as needed
        ],
      ),
    );
  }
}

// Define a reusable OverviewCard widget
class OverviewCard extends StatelessWidget {
  final String title;
  final String description;
  final String progress;
  final int? xp;

  const OverviewCard({
    Key? key,
    required this.title,
    required this.description,
    required this.progress,
    this.xp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use a Card widget to style the overview items
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(description),
        trailing: xp != null
            ? Chip(
                label: Text('$xp XP'),
                avatar: Icon(Icons.star),
              )
            : null,
        // Implement a progress indicator based on the 'progress' string
      ),
    );
  }
}
