import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'BaseAPI.dart';
import 'package:http/http.dart' as http;

class AuthAPI extends BaseAPI {
  Future<http.Response> signUp(String name, String email, String phone,
      String password, String passwordConfirmation) async {
    var body = jsonEncode({
      'user': {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'password_confirmation': passwordConfirmation
      }
    });

    http.Response response = await http.post(super.usersPath as Uri,
        headers: super.headers, body: body);
    return response;
  }

  Future<http.Response> login(String email, String password) async {
    var body = jsonEncode({'Email': email, 'Password': password});

    http.Response response = await http.post(super.authPath as Uri,
        headers: super.headers, body: body);

    return response;
  }

  Future<http.Response> getUser(int id, String token) async {
    var body = jsonEncode({'id': id, 'token': token});

    http.Response response = await http.post(super.usersPath as Uri,
        headers: super.headers, body: body);

    return response;
  }

  Future<http.Response> logout(int id, String token) async {
    var body = jsonEncode({'id': id, 'token': token});

    http.Response response = await http.post(super.logoutPath as Uri,
        headers: super.headers, body: body);

    return response;
  }
}

class User {
  int id;
  String email;
  String phone;
  String name;
  String token;

  User(
      {required this.id,
      required this.email,
      required this.phone,
      required this.name,
      required this.token});

  factory User.fromReqBody(String body) {
    Map<String, dynamic> json = jsonDecode(body);

    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      token: json['token'],
    );
  }

  void printAttributes() {
    print("id: ${this.id}\n");
    print("email: ${this.email}\n");
    print("phone: ${this.phone}\n");
    print("name: ${this.name}\n");
    print("token: ${this.token}\n");
  }
}

class UserCubit extends Cubit<User?> {
  UserCubit(User state) : super(state);

  void login(User user) => emit(user);

  void logout() => emit(null);
}

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}
