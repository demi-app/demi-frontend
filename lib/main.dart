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
        future: _getUserID(context),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // If the Future is still running, show a loading indicator
            return Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            // If we ran into an error, show an error message
            return Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            // If we have data, go to the HomePage
            return HomePage(userId: snapshot.data!); 
          } else {
            // If the userId is null or empty, go to the LoginPage
            return LoginPage();
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
    );}

  Future<String?> _getUserID(context) async {
    if (!context.mounted) {
          _getUserID(context);
        }
    return await SecureStorage().read('userId');
  }
}