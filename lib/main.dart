import 'package:flutter/material.dart';
import 'login_page.dart'; // Make sure this is the correct path to your login page file

// add profile header import and replace profile header defn here with it

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {'/': (context) => LoginPage()},
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(), // Use the LoginPage as the home of the app
    );
  }
}
