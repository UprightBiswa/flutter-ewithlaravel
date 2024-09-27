import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/constants/api_base_url.dart';
import '../../../data/internet/connectivity_services.dart';



class AppInfoController extends GetxController {
  final Dio _dio = Dio();

  var isLoading = false.obs;
  var appInfoResponse = Rxn<AppInfo>();
  final ConnectivityService _connectivityService = ConnectivityService();

  Future<void> getAppInfo({
    required BuildContext context,
  }) async {
    isLoading(true);
    try {
      bool isConnected = await _connectivityService.checkInternet();
      if (!isConnected) {
        throw Exception('No internet connection');
      }

      final response = await _dio.post(
        '${BaseURL.baseUrl}emp_app_info', 
      );

      if (response.statusCode == 200) {
        print('Successful Response: ${response.data}');
        final responseData = response.data['data'];
        appInfoResponse.value = AppInfo.fromJson(responseData);
      } else {
        print('Error Response: ${response.data}');
      }
    } catch (e) {
      print('Exception: $e');
    } finally {
      isLoading(false);
    }
  }
}

class AppInfo {
  final int id;
  final String appName;
  final String appVersion;
  final String remarks;
  final String priority;
  final String appLink;

  AppInfo({
    required this.id,
    required this.appName,
    required this.appVersion,
    required this.remarks,
    required this.priority,
    required this.appLink,
  });

  factory AppInfo.fromJson(Map<String, dynamic> json) {
    return AppInfo(
      id: json['id'],
      appName: json['app_name'],
      appVersion: json['app_version'].toString(),
      remarks: json['remarks'],
      priority: json['priority'].toString(),
      appLink: json['app_link'],
    );
  }
}
