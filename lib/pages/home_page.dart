import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
//import '../utils/milestone_card.dart';
import '../utils/mission_card.dart';
import '../utils/user_profile.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //List<Milestone> _milestones = [];
  List<Mission> _selectedMissions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      // _fetchMilestones();
      _fetchMissions();
    });
  }

/*
  Future<void> _fetchMilestones() async {
    var userId = Provider.of<UserNotifier>(context).currentUser?.id;
    try {
      final response = await http
          .get(Uri.parse('http://localhost:8080/api/milestone?userId=$userId'));

      if (response.statusCode == 200) {
        List<dynamic> milestonesJson = json.decode(response.body);
        setState(() {
          _milestones =
              milestonesJson.map((json) => Milestone.fromJson(json)).toList();
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
  */

  Future<void> _fetchMissions() async {
    var userId = Provider.of<UserNotifier>(context).currentUser?.id;
    try {
      final response = await http
          .get(Uri.parse('http://localhost:8080/api/mission?userId=$userId'));

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
        title: Text('Overview'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
              children: [
                Text('Milestones',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                // Build Milestones List
                /*..._milestones.map((m) => MilestoneCard(milestone: m)).toList(),
                SizedBox(height: 20),
                Text('Selected Missions',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),*/
                ..._selectedMissions
                    .map((m) => MissionCard(mission: m, onSelect: () {}))
                    .toList(),
              ],
            )),
    );
  }
}
