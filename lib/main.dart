import 'package:flutter/material.dart';
import 'overview_page.dart'; // Make sure this import is correct
import 'missions_page.dart';
// add profile header import and replace profile header defn here with it

void main() {
  runApp(MyApp());
}

// Add this enum at the top level, outside of your classes
enum SelectedTab { today, overview }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
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
        body: TabBarView(
          children: [
            MissionsTabContent(), // This will be your missions tab content
            OverviewPage(), // This will be your overview tab content
          ],
        ),
      ),
    );
  }
}
