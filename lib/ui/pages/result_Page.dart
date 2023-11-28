import 'package:flutter/material.dart';

class ExamSubmissionPage extends StatelessWidget {
  final int totalScore;
  final int correctAnswers;
  final int wrongAnswers;
  final int unattemptedQuestions;

  // You can add more parameters as needed

  const ExamSubmissionPage({
    Key? key,
    required this.totalScore,
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.unattemptedQuestions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.purple[600],
        title: Text('Exam Submission'),
      ),
      backgroundColor: Colors.purple[50],
      body: Stack(children: [
        Container(
          height: screenHeight * 10.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 100,
                ),
                SizedBox(height: 16),
                Text(
                  'Congratulations! You have completed the quiz successfully.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(16),
                  width: double.infinity,
                  color: Colors.green[50],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Summary:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total Score: $totalScore'),
                          // Add more details as needed
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Correct Answers: $correctAnswers'),
                          Text('Wrong Answers: $wrongAnswers'),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text('Unattempted Questions: $unattemptedQuestions'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Implement navigation to the previous screen or any other action
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(16),
                  backgroundColor: Colors.purpleAccent,
                ),
                child: Text(
                  'Go Back',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
