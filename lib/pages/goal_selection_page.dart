import 'package:flutter/material.dart';
import 'package:frontend/pages/home_page.dart';
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
      final response = await http.get(Uri.parse('http://localhost:8080/goals'));

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
                ..._goals
                    .map((g) => GoalCard(
                        goal: g,
                        onSelect: () async {
                          try {
                            final response = await http.post(
                              Uri.parse('http://localhost:8080/goal'),
                              headers: {
                                'Content-Type':
                                    'application/json; charset=UTF-8',
                                    'userID': widget.userId,
                              },
                              body: jsonEncode(
                                  {"ID": g.id}),
                            );
                            print(g.id);
                            print(widget.userId);
                            print("back from response");
                            print(response.statusCode);
                            if (response.statusCode == 200) {
                              print('big success');
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
