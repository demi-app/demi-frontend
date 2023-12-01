import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/pages/goal_selection_page.dart';
import 'package:frontend/pages/home_page.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/pages/missions_page.dart';
import 'package:frontend/pages/register_page.dart';
import 'package:frontend/utils/screen_arguments.dart';
import 'utils/user_data.dart';
import 'pages/splash_page.dart';

void main() {
  runApp(
    BlocProvider<UserCubit>(
      create: (context) => UserCubit(User.defaultUser()),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navigation with Arguments',
      home: SplashPage(),
      routes: {
        '/register': (context) => RegisterPage(),
        '/login': (context) => LoginPage(),
        // Add other routes here as needed
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
    );
  }
}
