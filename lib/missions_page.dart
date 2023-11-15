import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'utils/mission_card.dart'; // Assuming mission_card.dart contains the MissionCard widget

class Mission {
  final String title;
  final String time; // This should be a DateTime or a formatted string
  final String iconName; // If you use icon names as strings
  final String colorCode; // If you use color codes as strings

  Mission({
    required this.title,
    required this.time,
    this.iconName = '', // Provide default values or ensure they are passed
    this.colorCode = '',
  });

  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      title: json['title'],
      time: json['time'], // Make sure to convert this to your required format
      // ... initialize other properties
    );
  }
}

class MissionsPage extends StatefulWidget {
  @override
  _MissionsPageState createState() => _MissionsPageState();
}

class _MissionsPageState extends State<MissionsPage> {
  List<Mission> _missions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMissions();
  }

  Future<void> _fetchMissions() async {
    try {
      // Update with your actual endpoint to fetch missions
      final response = await http.get(Uri.parse('http://localhost:8080/api/mission'));
      
      if (response.statusCode == 200) {
        List<dynamic> missionsJson = json.decode(response.body);
        setState(() {
          _missions = missionsJson.map((json) => Mission.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        // Handle the case where the server returns a non-200 status code
        throw Exception('Failed to load missions');
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
        title: Text('Missions'),
      ),
      body: ListView.builder(
        itemCount: _missions.length,
        itemBuilder: (context, index) {
          final mission = _missions[index];
          return MissionCard(
            iconName: mission.iconName, // Correct property name
            title: mission.title,
            time: mission.time,
            colorCode: mission.colorCode, // Correct property name
            // ... other properties and callbacks
          );
        },
      ),
    );
  }
}
