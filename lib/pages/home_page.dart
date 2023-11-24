import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/mission_card.dart';
import '../utils/goal_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Goal> _goals = [];
  List<Mission> _selectedMissions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _fetchGoals();
      _fetchMissions();
    });
  }

  Future<void> _fetchGoals() async {
    var userID = "1";
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/goals'),
        headers: { 'userID': userID });

      if (response.statusCode == 200) {
        List<dynamic> goalsJson = json.decode(response.body);
        setState(() {
          _goals =
              goalsJson.map((json) => Goal.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        // Handle the case where the server returns a non-200 status code
        throw Exception('Failed to load goals');
      }
    } catch (e) {
      // Handle any errors here
      setState(() {
        _isLoading = false;
      });
      print(e);
    }
  }

  Future<void> _fetchMissions() async {
    var userID = "1";
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/missions/accepted'),
        headers: { 'userID': userID }
      );

      if (response.statusCode == 200) {
        List<dynamic> selectedMissionsjson = json.decode(response.body);
        setState(() {
          _selectedMissions = selectedMissionsjson
              .map((json) => Mission.fromJson(json))
              .toList();
          _isLoading = false;
        });
      } else {
        // Handle the case where the server returns a non-200 status code
        print(response.body);
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
        title: Text('Overview'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
              children: [
                Text('Goals',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                // Build Goals List
                ..._goals.map((m) => GoalCard(goal: m)).toList(),
                SizedBox(height: 20),
                Text('Selected Missions',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ..._selectedMissions
                    .map((m) => MissionCard(mission: m, onSelect: () {}))
                    .toList(),
              ],
            )),
    );
  }
}
