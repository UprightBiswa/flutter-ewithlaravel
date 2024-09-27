import 'dart:convert';
import 'package:http/http.dart' as http;

import '../data/constants/api_base_url.dart';

class UserDetailsApiClient {

  Future<Map<String, dynamic>> getUserDetails(String token) async {
    final url = Uri.parse('${BaseURL.baseUrl}student/dashboard');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print('User Details Response: $token');
      print('User Details Response: $url');
      return data;
    } else {
      print('User Details Response: $token');
      print('User Details Response: $url'); // This line is causing the error
      // This line is causing the error
      throw Exception('Failed to load user details');
    }
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final String address;
  final int status;
  final int roleId;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.status,
    required this.roleId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    print('User JSON: $json'); // Debug print
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      status: json['status'],
      roleId: json['role_id'],
      // createdAt: DateTime.parse(json['created_at']),
      // updatedAt: DateTime.parse(json['updated_at']),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

// Static method for creating a default user
  static User defaultUser() {
    return User(
      id: 0,
      name: 'Default User',
      email: '',
      phoneNumber: '',
      address: '',
      status: 0,
      roleId: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'address': address,
      'status': status,
      'role_id': roleId,
      'createdAt': createdAt.toIso8601String(), // Convert DateTime to string
      'updatedAt': updatedAt.toIso8601String(), // Convert DateTime to string
    };
  }
}
