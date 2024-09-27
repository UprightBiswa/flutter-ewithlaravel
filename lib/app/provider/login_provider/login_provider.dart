import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../data/constants/api_base_url.dart';
import '../../model/login_response_model.dart';
import '../../model/user_model.dart';
import 'auth_token.dart';

// Error: DioException [connection timeout]: The request connection took longer than 0:00:00.000000. It was aborted.
// I/flutter (17567): Error: SocketException: Connection timed out (OS Error: Connection timed out, errno = 110), address = 192.168.29.48, port = 43168
// D/InputConnectionAdaptor(17567): The input method toggled cursor monitoring on
// Restarted application in 3,537ms.
class LoginProvider extends ChangeNotifier {
  final Dio _dio = Dio();
  bool _isLoading = false;
  User? _userDetails;

  bool get isLoading => _isLoading;
  User? get userDetails => _userDetails;

  Future<bool> _checkInternet() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<LoginResponseModel?> loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    if (await _checkInternet()) {
      _setLoading(true);

      final data = {
        'email': email,
        'password': password,
      };

      try {
//         Error: DioException [connection timeout]: The request connection took longer than 0:00:00.000000. It was aborted.
// I/flutter (17567): Error: SocketException: Connection timed out (OS Error: Connection timed out, errno = 110), address = 192.168.29.48, port = 43168
// D/InputConnectionAdaptor(17567): The input method toggled cursor monitoring on
// Restarted application in 3,537ms.

        final response = await _dio.post(
          '${BaseURL.baseUrl}student/login',
          data: data,
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ),
        );

        final loginResponse = LoginResponseModel.fromJson(response.data);
        print(loginResponse.success);

        if (loginResponse.success) {
          Provider.of<AuthState>(context, listen: false)
              .setAccessToken(loginResponse.token);
          // SharedPreferences prefs = await SharedPreferences.getInstance();
          // await prefs.setString('token', loginResponse.token);

          // Fetch user details after successful login
          await fetchUserDetails(loginResponse.token, context);
        }

        _setLoading(false);
        return loginResponse;
      } catch (e) {
        print('Error: $e');
        _setLoading(false);
        return null;
      }
    } else {
      print('No internet connection');
      return null;
    }
  }

  Future<void> fetchUserDetails(String token, BuildContext context) async {
    try {
      final response = await _dio.get(
        '${BaseURL.baseUrl}student/dashboard',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.statusCode == 200 && response.data['success']) {
        final Map<String, dynamic> responseBody = json.decode(response.data);
        final user = User.fromJson(responseBody['user']);
        _userDetails = user;
        notifyListeners();
        // // Handle user data as needed, e.g., save to local storage
        // DatabaseHelper databaseHelper = DatabaseHelper();
        // await databaseHelper.openDatabase();
        // await databaseHelper.insertUser(user);
        Provider.of<AuthState>(context, listen: false).setUser(user);
      } else {
        throw Exception('Failed to load user details');
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  Future<LoginResponseModel?> registerUser({
    required String name,
    required String email,
    required String password,
    required String phoneNumber,
    required String address,
  }) async {
    if (await _checkInternet()) {
      _setLoading(true);

      final data = {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
        'phone_number': phoneNumber,
        'address': address,
      };

      try {
        final response = await _dio.post(
          '${BaseURL.baseUrl}student/register',
          data: data,
          options: Options(
            headers: {'Content-Type': 'application/json'},
          ),
        );

        final registerResponse = LoginResponseModel.fromJson(response.data);

        _setLoading(false);
        return registerResponse;
      } catch (e) {
        print('Error: $e');
        _setLoading(false);
        return null;
      }
    } else {
      print('No internet connection');
      return null;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
