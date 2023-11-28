import 'package:flutter/material.dart';
import 'package:frontend/pages/missions_page.dart';
import 'package:frontend/utils/milestone_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/mission_card.dart';
import '../utils/goal_card.dart';
import '../utils/screen_arguments.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  final String userId;

  const HomePage({
    super.key,
    required this.userId,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Goal> _goals = [];
  List<Mission> _selectedMissions = [];
  List<Milestone> _milestones = [];
  DateTime _preferredTime = DateTime.now();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSampleGoals(); //_fetchGoals();
    _loadSampleMissions(); //_fetchMissions();
    _loadSampleMilestones(); //_fetchMilestones();
  }

  void _loadSampleMissions() {
    setState(() {
      _selectedMissions = [
        Mission(
            id: '1',
            description:
                'watch scott pillie', // Adjust as per your requirements
            xpValue: 10,
            time: Duration(hours: 2),
            inspiration: 'h.com/watch?v=ZXsQAXx_ao0',
            howTo: ''),
        Mission(
            id: '2',
            description: 'bug out', // Adjust as per your requirements
            xpValue: 20,
            time: Duration(hours: 1),
            inspiration: 'https://www.youtube.com/watch?v=ZXsQAXx_ao0',
            howTo: ''),
        // Add more sample missions as needed
      ];
      _isLoading = false;
    });
  }

  void _loadSampleGoals() {
    setState(() {
      _goals = [
        Goal(
          id: '1',
          description: 'be cool',
        ),
        Goal(
          id: '2',
          description: 'bug out',
        ),
      ];
      _isLoading = false;
    });
  }

  void _loadSampleMilestones() {
    setState(() {
      _milestones = [
        Milestone(
            id: '1',
            description:
                'too much scott pillie', // Adjust as per your requirements
            progress: .8,
            goalId: '1')
      ];
      _isLoading = false;
    });
  }

  Future<void> _fetchGoals() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:8080/goals'),
          headers: {'userID': widget.userId});

      if (response.statusCode == 200) {
        List<dynamic> goalsJson = json.decode(response.body);
        setState(() {
          _goals = goalsJson.map((json) => Goal.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load goals');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
    }
  }

  Future<void> _fetchMilestones() async {
    try {
      final response = await http.get(
          Uri.parse('http://localhost:8080/milestones'),
          headers: {'userID': widget.userId});

      if (response.statusCode == 200) {
        List<dynamic> milestonesJson = json.decode(response.body);
        setState(() {
          _milestones =
              milestonesJson.map((json) => Milestone.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        print(response.body);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
    }
  }

  Future<void> _fetchMissions() async {
    try {
      final response = await http.get(
          Uri.parse('http://localhost:8080/missions/accepted'),
          headers: {'userID': widget.userId});

      if (response.statusCode == 200) {
        List<dynamic> selectedMissionsJson = json.decode(response.body);
        setState(() {
          _selectedMissions = selectedMissionsJson
              .map((json) => Mission.fromJson(json))
              .toList();
          _isLoading = false;
        });
      } else {
        print(response.body);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
    }
  }

  Future<void> getPreferredTime(missionId) async {
    final response = await http.get(Uri.parse(
        'http://localhost:8080/missions/${widget.userId}/${missionId}'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _preferredTime = data['preferredTime'];
    } else {
      // Handle error or set state to show an error message
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
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text('Goals',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ..._goals
              .map((goal) => GoalCard(
                  goal: goal, onSelect: () {}, showSelectButton: false))
              .toList(),
          SizedBox(height: 20),
          Text('Selected Missions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ..._milestones
              .map((milestone) => MilestoneCard(milestone: milestone))
              .toList(),
          SizedBox(height: 20),
          Text('Selected Missions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ..._selectedMissions
              .map((mission) => MissionCard(
                    mission: mission,
                    onSelect: () {
                      _updateMissionStatus(mission.id);
                    },
                    onInspiration: () {
                      // Handle inspiration action
                    },
                    onHowTo: () {
                      // Handle how-to action
                    },
                    onReschedule: () {
                      // Handle reschedule action
                    },
                    preferredTime:
                        _preferredTime, // Use your preferred time format here
                  ))
              .toList(),
          SizedBox(height: 20), // Space before the button
          ElevatedButton(
            onPressed: () => navigateToMissionsPage(),
            child: Text('Go to Missions Page'),
          )
        ],
      ),
    );
  }

  void navigateToMissionsPage() {
    // Use Navigator to push MissionsPage
    Navigator.pushNamed(
      context,
      MissionsPage.routeName,
      arguments: ScreenArguments(widget.userId),
    );
  }

  Future<void> _updateMissionStatus(String missionId) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:8080/mission/status'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'userID': widget.userId
        },
        body: jsonEncode({
          "missionID": missionId,
          "userID": widget.userId,
          "status": "completed"
        }),
      );
      if (response.statusCode == 200) {
        // Handle successful completion
        setState(() {
          _selectedMissions.removeWhere((mission) => mission.id == missionId);
        });
        print("Mission was completed");
      } else {
        // Handle errors
        print("Error: ${response.statusCode}");
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
}
