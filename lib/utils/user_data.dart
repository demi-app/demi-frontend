import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'BaseAPI.dart';
import 'package:http/http.dart' as http;

class AuthAPI extends BaseAPI {
  Future<http.Response> signup(
      String firstName, String lastName, String email,  String phone, String password,) async {
    var body = jsonEncode({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'password': password,
    });
    http.Response response =
        await http.post(super.signupPath, headers: super.headers, body: body);
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
  String phone;
  String firstName;
  String lastName;
  String password;

  User(
      {required this.id,
      required this.email,
      required this.phone,
      required this.firstName,
      required this.lastName,
      required this.password});

  // Default constructor
  User.defaultUser()
      : id = 'default_id',
        email = 'default@example.com',
        phone = '3051231234',
        firstName = 'Default',
        lastName = 'User',
        password = 'Password1234!';

  factory User.fromReqBody(String body) {
    Map<String, dynamic> json = jsonDecode(body);
    return User(
      id: json['id'],
      email: json['email'],
      phone: json ['phone'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      password: json['password'],
    );
  }

  void printAttributes() {
    print("id: $id\n");
    print("email: $email\n");
    print("phone: $phone\n");
    print("firstName: $firstName\n");
    print("lastName: $lastName\n");
  }
}

class UserCubit extends Cubit<User?> {
  UserCubit(User state) : super(state);

  void login(User user) => emit(user);

  void logout() => emit(null);
}
