import 'package:flutter/material.dart';
import 'package:frontend/pages/home_page.dart';
import 'package:frontend/utils/user_data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/goal_card.dart';
import '../utils/screen_arguments.dart';

class GoalSelection extends StatefulWidget {
  static const routeName = '/goal_selection';
  final String userId;

  const GoalSelection({
    super.key,
    required this.userId,
  });
  @override
  _GoalSelectionState createState() => _GoalSelectionState();
}

class _GoalSelectionState extends State<GoalSelection> {
  AuthAPI _authAPI = AuthAPI();
  List<Goal> _goals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _fetchGoals();
    });
  }

  Future<void> _fetchGoals() async {
    try {
      final response = await http.get(_authAPI.goalPath);
      if (response.statusCode == 200) {
        List<dynamic> goalsJson = json.decode(response.body);
        setState(() {
          _goals = goalsJson.map((json) => Goal.fromJson(json)).toList();
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

  Future<void> _addGoal(selectedGoal) async {
    try {
      final response = await http.post(
        _authAPI.specificGoalPath,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'userID': widget.userId,
        },
        body: jsonEncode({"ID": selectedGoal.id}),
      );
      print(selectedGoal.id);
      print(widget.userId);
      print("back from response");
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('big success');
        setState(() {
          _goals.removeWhere((goal) => goal.id == selectedGoal.id);
        });
      } else {
        // Handle the case where the server returns a non-200 status code
        print("error");
        print(response.statusCode);
        print('bruh');
      }
    } catch (e) {
      // Handle any errors here
      setState(() {
        _isLoading = false;
        print('bruhbruh');
      });
      print(e);
      print('bruh');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Goal Selection Page'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
              children: [
                Text('Goals',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ..._goals
                    .map((goal) => GoalCard(
                        goal: goal,
                        onSelect: () {
                          _addGoal(goal);
                        }))
                    .toList(),
                ElevatedButton(
                  onPressed: () => navigateToHomePage(),
                  child: Text('Go to Home Page'),
                )
              ],
            )),
    );
  }

  void navigateToHomePage() {
    // Use Navigator to push MissionsPage
    Navigator.pushNamed(
      context,
      HomePage.routeName,
      arguments: ScreenArguments(widget.userId),
    );
  }
}
