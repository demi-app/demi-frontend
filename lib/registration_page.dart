import 'package:flutter/material.dart';
import 'utils/goal_card.dart';
import 'package:provider/provider.dart';
import 'utils/user_profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  List<Goal> _goals = [];
  List<String> selectedGoals = [];
  bool _isLoading = true;

  void _loadSampleGoals() {
    setState(() {
      _goals = [
        Goal(
          id: '1',
          description: 'Goal 1',
        ),
        Goal(
          id: '2',
          description: 'Goal 2',
        ),
        // Add more sample goals as needed
      ];
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _loadSampleGoals(); // _fetchGoals();
    });
  }

  Future<void> _fetchGoals() async {
    var userId = Provider.of<UserNotifier>(context).currentUser?.id;
    try {
      final response =
          await http.get(Uri.parse('http://localhost:8080/api/goals'));

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
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<String?> _registerUser() async {
    final String username = _usernameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;

    // Add validation logic here...

    try {
      final response = await http.post(
        Uri.parse('https://yourapi.com/api/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // User registration successful
        return json.decode(response.body)[
            'userId']; // Adjust based on your actual response structure
      } else {
        // Handle errors...
        return null;
      }
    } catch (e) {
      // Handle errors...
      return null;
    }
  }

  Future<void> _submitSelectedGoals(String userId) async {
    try {
      await http.post(
        Uri.parse('https://yourapi.com/api/userGoals'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'userId': userId,
          'selectedGoals': selectedGoals,
        }),
      );

      // Handle the response...
    } catch (e) {
      // Handle errors...
    }
  }

  void _onGoalSelected(bool? selected, String goalId) {
    setState(() {
      if (selected == true) {
        selectedGoals.add(goalId);
      } else {
        selectedGoals.remove(goalId);
      }
    });
  }

  void _register() async {
    print('Lets goooooo');

    if (!_formKey.currentState!.validate()) {
      return; // Ensure the form is valid
    }

    setState(() {
      _isLoading = true;
    });

    String? userId = await _registerUser();
    if (userId != null) {
      await _submitSelectedGoals(userId);
      // Navigate to another page or show a success message
    } else {
      // Handle registration failure
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                  }),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                // Add validation logic
              ),
              Text('Select Your Goals', style: TextStyle(fontSize: 18)),
              ..._goals.map((goal) {
                return CheckboxListTile(
                  title: Text(goal.description),
                  value: selectedGoals.contains(goal.id),
                  onChanged: (bool? value) {
                    _onGoalSelected(value, goal.id);
                  },
                );
              }).toList(),
              ElevatedButton(
                onPressed: _register,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
