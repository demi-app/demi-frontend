import 'package:flutter/material.dart';
import 'package:frontend/pages/home_page.dart';
import 'package:frontend/pages/reschedule.dart';
import 'package:frontend/utils/screen_arguments.dart';
import 'package:frontend/utils/user_data.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMissions();
  }

  Future<void> _fetchMissions() async {
    try {
      final response = await http
          .get(_authAPI.missionsAllPath, headers: {'userID': widget.userId});

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

  Future<List<DateTime>> _fetchPreferredTime(String missionId) async {
    print(widget.userId);
    try {
      final response = await http.get(_authAPI.missionsAcceptedPath,
          headers: {'userID': widget.userId});

      if (response.statusCode == 200) {
        List<dynamic> jsonMilestones = json.decode(response.body);
        List milestones =
            jsonMilestones.map((json) => Mission.fromJson(json)).toList();
        milestones.removeWhere((milestone) => milestone.id != missionId);
        DateTime startTime = milestones.first.startTime;
        DateTime endTime = milestones.first.endTime;
        return [startTime, endTime];
      } else {
        print(response.body);
        print(response.statusCode);
        print("tiring");
        return [DateTime.now(), DateTime.now()];
      }
    } catch (e) {
      print(e);
      print("bruhBruh");
    }
    return [DateTime.now(), DateTime.now()];
  }

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
          ..._missions.map((mission) {
            return FutureBuilder<List<DateTime>>(
                future: _fetchPreferredTime(mission.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error loading times');
                  } else {
                    return MissionCard(
                        mission: mission,
                        onSelect: () => _updateMissionStatus(mission.id),
                        onHowTo: () => launchUrl(Uri.parse(mission.howTo)),
                        onInspiration: () =>
                            launchUrl(Uri.parse(mission.inspiration)),
                        onReschedule: () => Navigator.pushNamed(
                            context, ReschedulePage.routeName),
                        startTime: snapshot.data![0],
                        endTime: snapshot.data![1],
                        selectionReason: 'Mark as Completed');
                  }
                });
          }).toList(),
          ElevatedButton(
            onPressed: () => navigateToHomePage(),
            child: Text('Go to Home Page'),
          )
        ],
      ),
    );
  }

  Future<void> _updateMissionStatus(String missionId) async {
    try {
      final response = await http.put(
        _authAPI.missionStatusPath,
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
