import 'package:flutter/material.dart';
import 'milestone_page.dart'; // Make sure this import is correct
import 'missions_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'utils/profile_header.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Add this enum at the top level, outside of your classes
enum SelectedTab { today, overview }

class OverviewPage extends StatefulWidget {
  @override
  _OverviewPageState createState() => _OverviewPageState();
}

// Placeholder for MissionsOverviewPage
class _OverviewPageState extends State<OverviewPage> {
  String _username = '';
  String _avatarurl = '';

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  Future<void> _loadInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ??
          'Big Dawg'; // Default to 'Big Dawg' if not set
      _avatarurl = prefs.getString('password') ?? 'assets/images/boomer.jpg';
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // The number of tabs
      child: Scaffold(
          appBar: AppBar(
            title: Text('Demi'),
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            bottom: TabBar(
              tabs: [
                Tab(text: 'Missions'),
                Tab(text: 'Overview'),
              ],
            ),
          ),
          body: Column(children: [
            ProfileHeader(
              userName: _username,
              avatarUrl: _avatarurl,
              title: 'Flutter Developer',
            ),
            Expanded(
                child: TabBarView(
              children: [
                MissionsPage(), // This will be your missions tab content
                MilestonesPage(), // This will be your milestones tab content
              ],
            ))
          ])),
    );
  }
}
