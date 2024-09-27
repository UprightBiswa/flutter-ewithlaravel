import 'dart:convert';
import 'package:http/http.dart' as http;

import '../data/constants/api_base_url.dart';

class ExamQuestionsApi {
  static Future<Map<String, dynamic>> questions(
      dynamic examId, String userToken) async {
    try {
      if (examId is! int) {
        final parsedExamId = int.tryParse(examId.toString());

        if (parsedExamId == null) {
          return {'message': 'Invalid exam ID format.'};
        }

        examId = parsedExamId;
      }

      final response = await http.get(
        Uri.parse('${BaseURL.baseUrl}student/exams/$examId/questions'),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'message': 'Failed to fetch questions.'};
      }
    } catch (e) {
      return {'message': 'An unexpected error occurred.'};
    }
  }

  static Future<Map<String, dynamic>> submitAnswers(
    dynamic examId,
    String userToken,
    Map<String, List<int?>> answers,
  ) async {
    try {
      if (examId is! int) {
        final parsedExamId = int.tryParse(examId.toString());

        if (parsedExamId == null) {
          return {'message': 'Invalid exam ID format.'};
        }

        examId = parsedExamId;
      }

      final response = await http.post(
        Uri.parse('${BaseURL.baseUrl}student/exams/$examId/questions/submit'),
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(answers), // Wrap answers in 'questions' key
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'error': 'Failed to submit answers. ${response.reasonPhrase}'};
      }
    } catch (e) {
      return {'error': 'An unexpected error occurred: $e'};
    }
  }
}
