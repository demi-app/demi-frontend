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

  Future<http.Response> register(
      String firstName, String lastName, String email, String password) async {
    var body = jsonEncode({
      'Email': email,
      'Password': password,
      'firstName': firstName,
      'lastName': lastName
    });

    http.Response response =
        await http.post(super.registerPath, headers: super.headers, body: body);

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
  String password;

  User(
      {required this.id,
      required this.email,
      required this.firstName,
      required this.lastName,
      required this.password});

  // Default constructor
  User.defaultUser()
      : id = 'default_id',
        email = 'default@example.com',
        firstName = 'Default',
        lastName = 'User',
        password = 'Password1234!';

  factory User.fromReqBody(String body) {
    Map<String, dynamic> json = jsonDecode(body);
    return User(
      id: json['ID'],
      email: json['Email'],
      firstName: json['FirstName'],
      lastName: json['LastName'],
      password: json['Password'],
    );
  }

  void printAttributes() {
    print("id: $id\n");
    print("email: $email\n");
    print("firstName: $firstName\n");
    print("lastName: $lastName\n");
  }
}

class UserCubit extends Cubit<User?> {
  UserCubit(User state) : super(state);

  void login(User user) => emit(user);

  void logout() => emit(null);
}
