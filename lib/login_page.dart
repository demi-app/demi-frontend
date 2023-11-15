import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'overview_page.dart'; // Assuming this is the correct import for your MissionsTabContent
import 'package:frontend/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  // Place the _login method here inside your state class

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true; // show the loading indicator
    });
    
    final email = _emailController.text;
    final password = _passwordController.text;
    
    try{
      // Here you would send a request to your backend for authentication
      // For this example, let's mock the response as successful
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'password': password,
        }),
      );

      setState(() {
        _isLoading = false; // hide the loading indicator
      });

      if (response.statusCode == 200) {
      // Decode the JSON data
      final responseData = json.decode(response.body);
      
      // Assuming the response includes a "data" field with user details
      final userData = responseData['data'];

      // Get the name (and any other data) from the response
      final String name = userData['name'];
      final String avatarUrl = userData['avatarUrl'];

        // Save login state
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('name', name);
        await prefs.setString('avatarUrl', avatarUrl);

        // Navigate to the missions page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => OverviewPage()),
        );
    } else {
      // If the login attempt fails, show an error.
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Login failed. Please try again."),
      ));
    }
  }catch (e) {
  // If there's an error sending the request, show an error.
  _showErrorSnackBar('Fuck you.');
} finally {
  setState(() {
    _isLoading = false; // Hide the loading indicator
  });
}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Center(
                child: Container(
                    width: 200,
                    height: 150,
                    /*decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(50.0)),*/
                    child: Image.asset('/home/rpupo/demi-frontend/assets/images/boomer.jpg')),
              ),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(

                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter secure password'),
              ),
            ),
            TextButton(
              onPressed: (){
                //TODO FORGOT PASSWORD SCREEN GOES HERE
              },
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: _login,  // Call the _login method when the button is pressed
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            ),
            Text('New User? Create Account')
          ],
        ),
      ),
    );
  }
}