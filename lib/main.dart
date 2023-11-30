import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/pages/goal_selection_page.dart';
import 'package:frontend/pages/home_page.dart';
import 'package:frontend/pages/login_page.dart';
import 'package:frontend/pages/missions_page.dart';
import 'package:frontend/pages/register_page.dart';
import 'package:frontend/utils/screen_arguments.dart';
import 'utils/user_data.dart';
import '../utils/secure_storage.dart';

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
      home: FutureBuilder<String?>(
        future: _getUserID(),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Loading indicator
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return HomePage(userId: snapshot.data!); // Pass userId to HomePage
          } else {
            return LoginPage(); // User is not logged in, show LoginPage
          }
        },
      ),
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

  Future<String?> _getUserID() async {
    return await SecureStorage().read('userId');
  }
}