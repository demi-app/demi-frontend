import 'package:flutter/material.dart';
import 'package:frontend/pages/missions_page.dart';
import 'package:frontend/utils/secure_storage.dart';
import 'package:frontend/utils/milestone_card.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import '../utils/mission_card.dart';
import '../utils/goal_card.dart';
import '../utils/screen_arguments.dart';
import '../utils/user_data.dart';
import 'login_page.dart';
import 'reschedule.dart';

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
  AuthAPI _authAPI = AuthAPI();
  Future<void> _logout(BuildContext context) async {
    //var req = await _authAPI.logout(widget.userId);
    print('no here');
    await SecureStorage().delete('userId');
    print("stuck here");
    if (!context.mounted) {
      print("minor bruh moment");
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", false);
    if (!context.mounted) {
      return;
    }
    Navigator.pushNamed(
      context,
      LoginPage.routeName,
    );
  }

  List<Goal> _goals = [];
  List<Mission> _selectedMissions = [];
  List<Milestone> _milestones = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchGoals();
    _fetchMissions();
    _fetchMilestones();
  }

  Future<void> _fetchGoals() async {
    try {
      final response =
          await http.get(_authAPI.goalPath, headers: {'userID': widget.userId});

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
      print("bruh");
    }
  }

  Future<void> _fetchMilestones() async {
    try {
      final response = await http
          .get(_authAPI.milestonesPath, headers: {'userID': widget.userId});

      if (response.statusCode == 200) {
        List<dynamic> milestonesJson = json.decode(response.body);
        setState(() {
          _milestones =
              milestonesJson.map((json) => Milestone.fromJson(json)).toList();
          _isLoading = false;
        });
      } else {
        print(response.body);
        print("other stuff");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
      print("gotcha");
    }
  }

  Future<void> _fetchMissions() async {
    print(widget.userId);
    try {
      final response = await http.get(_authAPI.missionsAcceptedPath,
          headers: {'userID': widget.userId});

      if (response.statusCode == 200) {
        List<dynamic> selectedMissionsJson = json.decode(response.body);
        setState(() {
          _selectedMissions = selectedMissionsJson
              .map((json) => Mission.fromJson(json))
              .toList();
          _isLoading = false;
          print("found missions");
        });
      } else {
        print(response.body);
        print(response.statusCode);
        print("tiring");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
      print("bruhBruh");
    }
  }

  Future<List<DateTime>> _fetchPreferredTime(String missionId) async {
    print(widget.userId);
    try {
      final response = await http.get(_authAPI.missionsAcceptedPath,
          headers: {'userID': widget.userId});

      if (response.statusCode == 200) {
        List<dynamic> jsonMissions = json.decode(response.body);
        List missions =
            jsonMissions.map((json) => Mission.fromJson(json)).toList();
        missions.removeWhere((mission) => mission.id != missionId);
        DateTime startTime = missions.first.startTime;
        DateTime endTime = missions.first.endTime;
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

  Future<double> _fetchProgress(String milestoneId) async {
    print(widget.userId);
    try {
      final response = await http
          .get(_authAPI.milestonesPath, headers: {'userID': widget.userId});

      if (response.statusCode == 200) {
        List<dynamic> jsonMilestones = json.decode(response.body);
        List milestones =
            jsonMilestones.map((json) => Milestone.fromJson(json)).toList();
        milestones.removeWhere((milestone) => milestone.id != milestoneId);
        double progress = milestones[0].progress;
        return progress;
      } else {
        print(response.body);
        print(response.statusCode);
        print("tiring");
        return 0;
      }
    } catch (e) {
      print(e);
      print("bruhBruh");
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Demi App'),
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
          Text('Milestones',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ..._milestones.map((milestone) {
            return FutureBuilder<double>(
                future: _fetchProgress(milestone.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error loading times');
                  } else {
                    return MilestoneCard(
                        milestone: milestone, progress: snapshot.data!);
                  }
                });
          }).toList(),
          Text('Selected Missions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ..._selectedMissions.map((mission) {
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
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => navigateToMissionsPage(),
            child: Text('Go to Missions Page'),
          ),
          ElevatedButton(
            onPressed: () => _logout(context),
            child: Text("Logout"),
          ),
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
        _authAPI.missionStatusPath,
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
        // Handle successful selection
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
      print("buhhhi");
    }
  }
}
