import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'BaseAPI.dart';
import 'package:http/http.dart' as http;

class AuthAPI extends BaseAPI {
  Future<http.Response> signUp(
      String firstName, String lastName, String email, String password) async {
    var body = jsonEncode({
      'user': {
        'FirstName': firstName,
        'LastName': lastName,
        'Email': email,
        //'Phone': phone,
        'Password': password,
      }
    });

    http.Response response =
        await http.post(super.usersPath, headers: super.headers, body: body);
    return response;
  }

  Future<http.Response> login(String email, String password) async {
    var body = jsonEncode({'Email': email, 'Password': password});

    http.Response response =
        await http.post(super.loginPath, headers: super.headers, body: body);

    return response;
  }

  Future<http.Response> getUser(String id, String token) async {
    var body = jsonEncode({'ID': id, 'token': token});

    http.Response response =
        await http.post(super.usersPath, headers: super.headers, body: body);

    return response;
  }

  Future<http.Response> logout(String id, String token) async {
    var body = jsonEncode({'ID': id, 'token': token});

    http.Response response = await http.post(super.logoutPath as Uri,
        headers: super.headers, body: body);

    return response;
  }
}

class User {
  String id;
  String email;
  String firstName;
  String lastName;
  String token;

  User(
      {required this.id,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.token});

  factory User.fromReqBody(String body) {
    Map<String, dynamic> json = jsonDecode(body);

    return User(
        id: json['ID'],
        email: json['Email'],
        firstName: json['FirstName'],
        lastName: json['LastName'],
        token: "Buttcheeks");
  }

  void printAttributes() {
    print("id: ${this.id}\n");
    print("email: ${this.email}\n");
    print("name: ${this.firstName}\n");
    print("token: ${this.lastName}\n");
  }
}

class UserCubit extends Cubit<User?> {
  UserCubit(User state) : super(state);

  void login(User user) => emit(user);

  void logout() => emit(null);
}
