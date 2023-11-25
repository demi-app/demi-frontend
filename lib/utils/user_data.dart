import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'BaseAPI.dart';
import 'package:http/http.dart' as http;

class AuthAPI extends BaseAPI {
  Future<http.Response> signUp(
      String firstName, String lastName, String email, String password) async {
    var body = jsonEncode({
      'user': {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'password': password,
      }
    });

    http.Response response =
        await http.post(super.usersPath, headers: super.headers, body: body);
    return response;
  }

  Future<http.Response> login(String email, String password) async {
    var body = jsonEncode({'email': email, 'password': password});

    http.Response response =
        await http.post(super.loginPath, headers: super.headers, body: body);

    return response;
  }

  Future<http.Response> getUser(String id) async {
    var body = jsonEncode({'id': id});

    http.Response response =
        await http.post(super.usersPath, headers: super.headers, body: body);

    return response;
  }

  Future<http.Response> logout(String id) async {
    var body = jsonEncode({'id': id});

    http.Response response =
        await http.post(super.logoutPath, headers: super.headers, body: body);

    return response;
  }
}

class User {
  String id;
  String email;
  String firstName;
  String lastName;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  // Default constructor
  User.defaultUser()
      : id = 'default_id',
        email = 'default@example.com',
        firstName = 'Default',
        lastName = 'User';

  factory User.fromReqBody(String body) {
    Map<String, dynamic> json = jsonDecode(body);

    return User(
      id: json['id'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }

  void printAttributes() {
    print("id: ${this.id}\n");
    print("email: ${this.email}\n");
    print("firstName: ${this.firstName}\n");
    print("lastName: ${this.lastName}\n");
  }
}

class UserCubit extends Cubit<User?> {
  UserCubit(User state) : super(state);

  void login(User user) => emit(user);

  void logout() => emit(null);
}
