import 'package:flutter/material.dart';

class User {
  final String id;
  User({required this.id});
}

class UserNotifier with ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }
}
