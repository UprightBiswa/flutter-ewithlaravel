import 'package:elearning/app/services/examApi.dart';
import 'package:elearning/app/modules/ui/pages/quizepage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class ExamDetailPage extends StatefulWidget {
  final int examId;
  final String examSubject;
  final String examDate;
  final int examDuration;

  ExamDetailPage({
    required this.examId,
    required this.examSubject,
    required this.examDate,
    required this.examDuration,
  });

  @override
  State<ExamDetailPage> createState() => _ExamDetailPageState();
}

class _ExamDetailPageState extends State<ExamDetailPage> {
  late String userToken;
  List<dynamic> questions = [];
  bool isLoading = false;
  String _totalQuestions = '';
  String _totalMarks = '';

  @override
  void initState() {
    super.initState();
    _retrieveToken();
  }

  Future<void> _retrieveToken() async {
    final prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString('token') ?? '';
    _fetchExamQuestions();
  }

  Future<void> _fetchExamQuestions() async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No internet connection.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        isLoading = true;
      });

      if (userToken.isEmpty) {
        print('Authentication token not found in SharedPreferences');
        return;
      }

      final examId = widget.examId;
      final response = await ExamQuestionsApi.questions(examId, userToken);

      if (response.containsKey('questions')) {
        setState(() {
          questions = response['questions'];
          //answeroption = response['questions']['answer_option'] ?? [];
          int totalQuestions = questions.length;
          int totalMarks = totalQuestions; // Assuming 1 mark per question

          _totalQuestions = totalQuestions.toString();
          _totalMarks = totalMarks.toString();
          // print('$answeroption');
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No questions found for the exam.'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack Trace: $stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unexpected error occurred.'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    // double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.purple[600],
        title: Text('Exam Details'),
      ),
      backgroundColor: Colors.purple[50],
      body: Stack(
        children: [
          Container(
            height: screenHeight * 10.0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Colors.purple[200],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.examSubject,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Published on: ${widget.examDate}',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  Text(
                                    'Duration: ${widget.examDuration}',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 176, 124, 182),
                                  border: Border.all(
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.question_answer,
                                    size: 36,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Colors.purple[200],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildDetailCard('Total Questions', _totalQuestions),
                          _buildDetailCard('Total Marks', _totalMarks),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Colors.purple[200],
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Instructions:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '1. All questions are for 1 mark.',
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            '2. This is a time-bound quiz, so make sure to finish and submit within the given time.',
                            style: TextStyle(color: Colors.black),
                          ),
                          Text(
                            '3. Make sure you review your submissions before moving onto the next qustion.',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  if (questions.isEmpty)
                    _buildButton('Back Quiz', () {
                      Navigator.pop(context);
                    }),
                  if (questions.isNotEmpty)
                    SizedBox(height: 16), // Adjust spacing
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildButton('Start Quiz', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizPage(
                    quiz: Quiz(
                      questions: List<Question>.from(
                        questions.map(
                          (questionData) => Question(
                            id: questionData['id'],
                            questionText: questionData['question_text'],
                            answerOptions: List<AnswerOption>.from(
                              questionData['answer_option'].map(
                                (optionData) => AnswerOption(
                                  id: optionData['id'],
                                  optionText: optionData['option_text'],
                                  isCorrect:
                                      optionData['is_correct_option'] == 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    examDetails: questions,
                    examDuration: widget.examDuration,
                    examId: widget.examId,
                  ),
                ),
              );
            }),
          ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }

// ... (rest of the code remains unchanged)

  Widget _buildDetailCard(String title, String value) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.purple[100],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildDetailItem(title, value),
      ),
    );
  }

  Widget _buildDetailItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(value),
      ],
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.purpleAccent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MaterialButton(
          onPressed: onPressed,
          padding: EdgeInsets.all(8),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
