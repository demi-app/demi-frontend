import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'utils/mission_card.dart'; // Assuming mission_card.dart contains the MissionCard widget
import 'utils/user_profile.dart';
import 'package:provider/provider.dart';

class MissionsPage extends StatefulWidget {
  @override
  _MissionsPageState createState() => _MissionsPageState();
}

class _MissionsPageState extends State<MissionsPage> {
  List<Mission> _missions = [];
  bool _isLoading = true;

  void _loadSampleMissions() {
    setState(() {
      _missions = [
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
    _loadSampleMissions(); // _fetchMissions();
  }

  Future<void> _fetchMissions() async {
    var userId = Provider.of<UserNotifier>(context).currentUser?.id;
    try {
      final response = await http
          .get(Uri.parse('http://localhost:8080/api/mission?userId=$userId'));

      if (response.statusCode == 200) {
        List<dynamic> missionsJson = json.decode(response.body);
        setState(() {
          _missions =
              missionsJson.map((json) => Mission.fromJson(json)).toList();
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

  Future<void> _sendMissionSelectionToBackend(Mission mission) async {
    try {
      // Replace with your actual backend URL and data format
      final response = await http.post(
        Uri.parse('https://yourbackend.com/api/mission/select'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'missionId':
              mission.id, // Assuming each mission has a unique identifier
          'selected': 'true',
        }),
      );

      if (response.statusCode == 200) {
        // Handle response...
      } else {
        // Error handling...
      }
    } catch (e) {
      // Exception handling...
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
            mission: mission,
            onSelect: () => _handleMissionSelected(mission),
            //Handle Mission
          );
        },
      ),
    );
  }

  void _handleMissionSelected(Mission mission) {
    // Send the selection information to the backend
    // For example, using an HTTP POST request
    print('Lets goooooo');
    _sendMissionSelectionToBackend(mission);
  }
}
