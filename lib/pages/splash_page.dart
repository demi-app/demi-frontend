import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/utils/screen_arguments.dart';
import 'package:frontend/utils/secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/pages/home_page.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SplashPageState();
  }
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("../../assets/images/demi-logo.jpg"),
              fit: BoxFit.cover),
        ),
      ),
    );
  }

  void startTimer() {
    Timer(Duration(seconds: 3), () {
      navigateUser(); //It will redirect  after 3 seconds
    });
  }

  void navigateUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    print(status);
    if (status) {
      if (!context.mounted) {
        return;
      }
      ;
      String userId = await SecureStorage().read('userId');
      if (!context.mounted) {
        return;
      }
      ;
      Navigator.pushNamed(context, HomePage.routeName,
          arguments: ScreenArguments(userId));
    } else {
      if (!context.mounted) {
        return;
      }
      Navigator.pushNamed(context, LoginPage.routeName);
    }
  }
}
