import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/user_model.dart';
import 'login_provider.dart';

class AuthState with ChangeNotifier {
  String? _accessToken;
  User? _user;
  String? get accessToken => _accessToken;
  User? get user => _user;
  Future<void> setAccessToken(String token) async {
    _accessToken = token;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', _accessToken!);

    notifyListeners();
  }

  Future<void> setUser(User user) async {
    _user = user;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', json.encode(_user!.toJson()));

    notifyListeners();
  }

  Future<void> loadAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('accessToken');

    notifyListeners();
  }

  Future<void> loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    if (userJson != null) {
      _user = User.fromJson(json.decode(userJson));
    }

    notifyListeners();
  }

  Future<void> clearAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');

    _accessToken = null;

    notifyListeners();
  }

  Future<void> clearUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');

    _user = null;

    notifyListeners();
  }

  
}
