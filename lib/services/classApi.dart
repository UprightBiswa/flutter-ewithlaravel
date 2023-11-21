import 'dart:convert';
import 'package:elearning/services/api.dart';
import 'package:http/http.dart' as http;

class ClasseApi {
  static Future<Map<String, dynamic>> classDetails(
      dynamic classId, String userToken) async {
    try {
      if (classId is! int) {
        final parsedClassId = int.tryParse(classId.toString());

        if (parsedClassId == null) {
          return {'message': 'Invalid class ID format.'};
        }

        classId = parsedClassId;
      }

      final response = await http.get(
        Uri.parse('$baseURL/student/classes/$classId/details'),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'message': 'Failed to fetch class details.'};
      }
    } catch (e) {
      return {'message': 'An unexpected error occurred.'};
    }
  }
}
