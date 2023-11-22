import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/milestone_card.dart'; // Assuming milestone_card.dart contains the MilestoneCard widget
import '../utils/mission_card.dart'; // Assuming milestone_card.dart contains the MilestoneCard widget
import '../utils/user_profile.dart';
import 'package:provider/provider.dart';

class MilestonesPage extends StatefulWidget {
  @override
  _MilestonesPageState createState() => _MilestonesPageState();
}

class _MilestonesPageState extends State<MilestonesPage> {
  List<Milestone> _milestones = [];
  List<Mission> _selectedMissions = [];
  bool _isLoading = true;

  void _loadSampleMilestones() {
    setState(() {
      _milestones = [
        Milestone(
          id: '1',
          iconName: 'iconName1', // Adjust as per your requirements
          description: 'Milestone 1',
          progress: '100',
          goal_id: 'a',
        ),
        Milestone(
          id: '2',
          iconName: 'iconName1', // Adjust as per your requirements
          description: 'Milestone 2',
          progress: '200',
          goal_id: 'b',
        ),
        // Add more sample milestones as needed
      ];
      _isLoading = false;
    });
  }

  void _loadSampleMissions() {
    setState(() {
      _selectedMissions = [
        Mission(
          id: '1',
          iconName: 'iconName1', // Adjust as per your requirements
          description: 'Mission 1',
          xp_value: '100',
          milestone_id: 'a',
        ),
        Mission(
          id: '2',
          iconName: 'iconName1', // Adjust as per your requirements
          description: 'Mission 2',
          xp_value: '200',
          milestone_id: 'b',
        ),
        // Add more sample missions as needed
      ];
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _loadSampleMilestones(); // _fetchMilestones();
      _loadSampleMissions(); //_fetchMissions
    });
  }

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
                ..._milestones.map((m) => MilestoneCard(milestone: m)).toList(),
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
