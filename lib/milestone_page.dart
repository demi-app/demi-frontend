import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'utils/milestone_card.dart'; // Assuming milestone_card.dart contains the MilestoneCard widget

class Milestone {
  final String title;
  final String time; // This should be a DateTime or a formatted string
  final String iconName; // If you use icon names as strings
  final String colorCode; // If you use color codes as strings

  Milestone({
    required this.title,
    required this.time,
    this.iconName = '', // Provide default values or ensure they are passed
    this.colorCode = '',
  });

  factory Milestone.fromJson(Map<String, dynamic> json) {
    return Milestone(
      title: json['title'],
      time: json['time'], // Make sure to convert this to your required format
      // ... initialize other properties
    );
  }
}

class MilestonesPage extends StatefulWidget {
  @override
  _MilestonesPageState createState() => _MilestonesPageState();
}

class _MilestonesPageState extends State<MilestonesPage> {
  List<Milestone> _milestones = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMilestones();
  }

  Future<void> _fetchMilestones() async {
    try {
      // Update with your actual endpoint to fetch milestones
      final response = await http.get(Uri.parse('http://localhost:8080/api/milestone'));
      
      if (response.statusCode == 200) {
        List<dynamic> milestonesJson = json.decode(response.body);
        setState(() {
          _milestones = milestonesJson.map((json) => Milestone.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        // Handle the case where the server returns a non-200 status code
        throw Exception('Failed to load milestones');
      }
    } catch (e) {
      // Handle any errors here
      setState(() {
        _isLoading = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Milestones'),
      ),
      body: ListView.builder(
        itemCount: _milestones.length,
        itemBuilder: (context, index) {
          final milestone = _milestones[index];
          return MilestoneCard(
            iconName: milestone.iconName, // Correct property name
            title: milestone.title,
            time: milestone.time,
            colorCode: milestone.colorCode, // Correct property name
            // ... other properties and callbacks
          );
        },
      ),
    );
  }
}
