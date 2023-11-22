import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/user_data.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  void upDateSharedPreferences(String token, int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    prefs.setInt('id', id);
  }

  @override
  Widget build(BuildContext context) {
    AuthAPI authAPI = AuthAPI();
    return BlocBuilder<UserCubit, User?>(
        buildWhen: (previous, current) => previous != current,
        builder: (BuildContext context, User? state) {
          checkPrefsForUser() async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            var sharedToken = prefs.getString('token');
            var sharedId = prefs.getInt('id');
            if (sharedToken != null && sharedId != null) {
              try {
                var req = await authAPI.getUser(sharedId, sharedToken);
                if (req.statusCode == 202) {
                  var user = User.fromReqBody(req.body);
                  BlocProvider.of<UserCubit>(context).login(user);
                  upDateSharedPreferences(user.token, user.id);
                }
              } on Exception {
                print("fuck");
              }
            }
          }

          if (state == null) {
            checkPrefsForUser();
          }
          return Scaffold();
        });
  }
}
