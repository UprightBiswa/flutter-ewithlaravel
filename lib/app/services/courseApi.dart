// // course_api.dart
// import 'package:dio/dio.dart';
// import 'package:elearning/services/api.dart';

// class CourseApi {
//   static Dio _dio = Dio(
//     BaseOptions(
//       baseUrl: baseURL,
//       connectTimeout: Duration(milliseconds: 5000),
//       receiveTimeout: Duration(milliseconds: 5000),
//     ),
//   );

//   static Future<Map<String, dynamic>> enrollCourse(dynamic courseId) async {
//     try {
//       if (courseId is! int) {
//         // If courseId is not an integer, try to parse it
//         final parsedCourseId = int.tryParse(courseId.toString());

//         if (parsedCourseId == null) {
//           // Handle the case where courseId cannot be parsed
//           return {'message': 'Invalid course ID format.'};
//         }

//         // Use the parsed integer as the courseId
//         courseId = parsedCourseId;
//       }

//       final response = await _dio.post('/student/courses/$courseId/enroll');
//       return response.data;
//     } on DioError catch (e) {
//       if (e.response != null) {
//         return {'message': e.response!.data['message']};
//       } else {
//         return {
//           'message': 'Network error: Please check your internet connection.'
//         };
//       }
//     } catch (e) {
//       return {'message': 'An unexpected error occurred.'};
//     }
//   }
// }
// import 'dart:convert';
// import 'package:elearning/services/api.dart';
// import 'package:http/http.dart' as http;

// class CourseApi {

//   static Future<Map<String, dynamic>> enrollCourse(dynamic courseId) async {
//     try {
//       if (courseId is! int) {
//         final parsedCourseId = int.tryParse(courseId.toString());

//         if (parsedCourseId == null) {
//           return {'message': 'Invalid course ID format.'};
//         }

//         courseId = parsedCourseId;
//       }

//       final response = await http.post(
//         Uri.parse('$baseURL/student/courses/$courseId/enroll'),
//         // Additional headers or parameters can be added here
//       );

//       if (response.statusCode == 200) {
//         return json.decode(response.body);
//       } else {
//         return {'message': 'Failed to enroll in the course.'};
//       }
//     } catch (e) {
//       return {'message': 'An unexpected error occurred.'};
//     }
//   }
// }
import 'dart:convert';
import 'package:elearning/app/services/api.dart';
import 'package:http/http.dart' as http;

import '../data/constants/api_base_url.dart';

class CourseApi {
  static Future<Map<String, dynamic>> enrollCourse(
      dynamic courseId, String userToken) async {
    try {
      if (courseId is! int) {
        final parsedCourseId = int.tryParse(courseId.toString());

        if (parsedCourseId == null) {
          return {'message': 'Invalid course ID format.'};
        }

        courseId = parsedCourseId;
      }

      final response = await http.post(
        Uri.parse('${BaseURL.baseUrl}student/courses/$courseId/enroll'),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type':
              'application/json', // Add any additional headers as needed
        },
        // Additional headers or parameters can be added here
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'message': 'Failed to enroll in the course.'};
      }
    } catch (e) {
      return {'message': 'An unexpected error occurred.'};
    }
  }
   static Future<Map<String, dynamic>> getEnrolledClasses(
      dynamic courseId, String userToken) async {
    try {
      if (courseId is! int) {
        final parsedCourseId = int.tryParse(courseId.toString());

        if (parsedCourseId == null) {
          return {'message': 'Invalid course ID format.'};
        }

        courseId = parsedCourseId;
      }

      final response = await http.get(
        Uri.parse('${BaseURL.baseUrl}student/courses/$courseId/classes'),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type':
              'application/json', // Add any additional headers as needed
        },
        // Additional headers or parameters can be added here
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'message': 'Failed to fetch enrolled classes for the course.'};
      }
    } catch (e) {
      return {'message': 'An unexpected error occurred.'};
    }
  }

}
