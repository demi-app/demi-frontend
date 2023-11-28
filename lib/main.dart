import 'package:flutter/material.dart';
import 'package:frontend/pages/goal_selection_page.dart';
import 'package:frontend/pages/home_page.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/pages/register_page.dart';
import 'package:frontend/pages/missions_page.dart';
//import 'resources/app_theme.dart';
//import 'pages/login_page.dart';
//import 'utils/secure_storage.dart';
//import 'pages/register_page.dart';
import 'utils/screen_arguments.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == HomePage.routeName) {
          final args = settings.arguments as ScreenArguments;
          return MaterialPageRoute(
            builder: (context) {
              return HomePage(
                userId: args.userId,
              );
            },
          );
        } else if (settings.name == MissionsPage.routeName) {
          // Handle MissionsPage routing
          final args = settings.arguments as ScreenArguments;
          return MaterialPageRoute(
            builder: (context) {
              return MissionsPage(
                userId: args.userId,
              );
            },
          );
        } else if (settings.name == GoalSelection.routeName) {
          // Handle MissionsPage routing
          final args = settings.arguments as ScreenArguments;
          return MaterialPageRoute(
            builder: (context) {
              return GoalSelection(
                userId: args.userId,
              );
            },
          );
        }
        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
      title: 'Navigation with Arguments',
    );
  }
}
