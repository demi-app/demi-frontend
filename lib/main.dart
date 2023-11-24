import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'values/app_theme.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
//import 'values/app_routes.dart';
import 'pages/goal_selection_page.dart';
import 'utils/user_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  Future<void> updateSharedPreferences(String id) async {
    String token = "Buttcheeks"; //delete later
    final _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('token', token);
    await _prefs.setString('id', id);
  }

  Future<User?> checkPrefsForUser() async {
    final prefs = await SharedPreferences.getInstance();
    final sharedId = prefs.getString('id');
    if (sharedId != null) {
      final authAPI = AuthAPI();
      try {
        final req = await authAPI.getUser(sharedId);
        if (req.statusCode == 202) {
          final user = User.fromReqBody(req.body);
          await updateSharedPreferences(user.id);
          return user;
        }
      } on Exception {
        print("An error occurred while fetching user data.");
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: checkPrefsForUser(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        return MultiBlocProvider(
          providers: [
            BlocProvider<UserCubit>(
              create: (context) => UserCubit(user ?? User.defaultUser()),
            ),
          ],
          child: MaterialApp(
            title: 'Your App Title',
            theme: AppTheme.themeData,
            // Decide which initial route to show based on user presence
            initialRoute: user == null ? '/login' : '/home',
            routes: {
              '/login': (context) => LoginPage(),
              '/register': (context) => RegisterPage(),
              '/home': (context) => HomePage(),
              '/goal_selection': (context) => GoalsSelectionScreen(),
              // Add other routes here
            },
          ),
        );
      },
    );
  }
}
