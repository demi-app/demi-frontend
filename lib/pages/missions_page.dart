import 'package:flutter/material.dart';
import 'package:frontend/pages/home_page.dart';
import 'package:frontend/utils/screen_arguments.dart';
import 'package:frontend/utils/user_data.dart';
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
  AuthAPI _authAPI = AuthAPI();
  List<Mission> _missions = [];
  DateTime _preferredTime = DateTime.now();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMissions();
  }

  Future<void> _fetchMissions() async {
    try {
      final response = await http.get(
          _authAPI.missionsAll,
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

  void navigateToHomePage() {
    // Use Navigator to push MissionsPage
    Navigator.pushNamed(
      context,
      HomePage.routeName,
      arguments: ScreenArguments(widget.userId),
    );
  }
/*
  Future<void> getPreferredTime(missionId) async {
    final response = await http.get(Uri.parse(
        'http://localhost:8080/missions/${widget.userId}/${missionId}'),
        headers: {'userId': widget.userId});
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _preferredTime = data['preferredTime'];
    } else {
      // Handle error or set state to show an error message
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                        _preferredTime, 
                    type: 'Choose',
                  ))
              .toList(),
              ElevatedButton(
                  onPressed: () => navigateToHomePage(),
                  child: Text('Go to Home Page'),
                )
              ],
            ),
      );
  }

  Future<void> _selectMission(String missionId) async {
    try {
      final response = await http.put(
        _authAPI.missionStatus,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'userID': widget.userId
        },
        body: jsonEncode({
          "missionID": missionId,
          "userID": widget.userId,
          "status": "accepted"
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