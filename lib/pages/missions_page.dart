import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/mission_card.dart';

class MissionsPage extends StatefulWidget {
  static const routeName = '/missions';
  final String userId;

  const MissionsPage({
    super.key,
    required this.userId,
  });

  @override
  _MissionsPageState createState() => _MissionsPageState();
}

class _MissionsPageState extends State<MissionsPage> {
  List<Mission> _missions = [];
  DateTime _preferredTime = DateTime.now();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSampleMissions(); //_fetchMissions();
  }

  void _loadSampleMissions() {
    setState(() {
      _missions = [
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

  Future<void> _fetchMissions() async {
    try {
      final response = await http.get(
          Uri.parse('http://localhost:8080/missions/accepted'),
          headers: {'userID': widget.userId});

      if (response.statusCode == 200) {
        List<dynamic> selectedMissionsJson = json.decode(response.body);
        setState(() {
          _missions = selectedMissionsJson
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
          Text("Today's Missions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ..._missions
              .map((mission) => MissionCard(
                    mission: mission,
                    onSelect: () {
                      _selectMission(mission.id);
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
        ],
      ),
    );
  }

  Future<void> _selectMission(String missionId) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:8080/mission/selected'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'userID': widget.userId
        },
        body: jsonEncode({
          "missionID": missionId,
          "userID": widget.userId,
          "isSelected": "y"
        }),
      );
      if (response.statusCode == 200) {
        // Handle successful selection
        setState(() {
          _missions.removeWhere((mission) => mission.id == missionId);
        });
        print("Mission was selected");
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
