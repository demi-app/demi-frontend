import 'package:flutter/material.dart';
import 'login_page.dart'; // Make sure this is the correct path to your login page file
import 'overview_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/user_profile.dart';
import 'package:provider/provider.dart';

// add profile header import and replace profile header defn here with it

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? true; //false;

  runApp(ChangeNotifierProvider(
      create: (context) => UserNotifier(),
      child: MyApp(
        isLoggedIn: isLoggedIn,
      )));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({Key? key, required this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? OverviewPage() : LoginPage(),
    );
  }
}
