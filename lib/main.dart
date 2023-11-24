import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'values/app_theme.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'values/app_routes.dart';
import 'pages/home_page.dart';
import 'pages/goal_selection_page.dart';
import 'utils/user_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User defaultUser = User(
      id: '0', // Default values
      email: '',
      firstName: '',
      lastName: '',
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<UserCubit>(
            create: (BuildContext context) => UserCubit(defaultUser)),
      ],
      child: MaterialApp(
        title: 'Bruh Moment',
        theme: AppTheme.themeData,
        initialRoute: '/', // Assuming you want to show the LoginPage first.
        routes: {
          '/': (context) => const LoginPage(), // Default route
          '/register': (context) => const RegisterPage(),
          '/home': (context) => MyHomePage(),
          '/goal_selection': (context) => GoalsSelectionScreen(),
          // Add other routes here
        },
      ),
    );
  }
}
