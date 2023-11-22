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
      id: 0, // Default values
      email: '',
      phone: '',
      name: '',
      token: '',
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<UserCubit>(
            create: (BuildContext context) => UserCubit(defaultUser)),
      ],
      child: MaterialApp(
        title: 'Bruh Moment',
        theme: AppTheme.themeData,
        routes: {
          AppRoutes.loginScreen: (context) => const LoginPage(),
          AppRoutes.registerScreen: (context) => const RegisterPage(),
          '/home': (context) => MyHomePage(),
          '/goal_selection': (context) => GoalsSelectionScreen(),
        },
      ),
    );
  }
}

/*
initialRoute: AppRoutes.loginScreen,
navigatorKey: AppConstants.navigationKey,
*/