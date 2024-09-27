import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:elearning/app/services/examApi.dart';
import 'package:elearning/app/modules/ui/pages/result_Page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Question {
  final int id;
  final String questionText;
  final List<AnswerOption> answerOptions;

  Question({
    required this.id,
    required this.questionText,
    required this.answerOptions,
  });
}

class AnswerOption {
  final int id;
  final String optionText;
  final bool isCorrect;

  AnswerOption({
    required this.id,
    required this.optionText,
    required this.isCorrect,
  });
}

class Quiz {
  final List<Question> questions;

  Quiz({required this.questions});
}

class QuizPage extends StatefulWidget {
  final Quiz quiz;
  final dynamic examDetails; // Define examDetails here
  final int examDuration; // Add exam duration parameter
  final int examId;

  QuizPage({
    required this.quiz,
    required this.examDetails,
    required this.examDuration,
    required this.examId,
  });

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentIndex = 0;
  List<int?> userAnswers = [];
  late Timer timer;
  bool isLastQuestion = false;
  bool isAnswerSubmitted = false;
  late List<dynamic> questions;
  late int remainingTime;
  bool isTimeOverDialogShown = false; // New flag to track the dialog
  late String userToken;
  List<String> optionsLetters = ["A.", "B.", "C.", "D."];
  bool isSubmitting = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    questions = widget.examDetails;
    initializeUserAnswers(); // Initialize userAnswers list
    remainingTime = widget.examDuration;
    startTimer();
    _retrieveToken();
    print('Total Questions: ${widget.quiz.questions.length}');
    print('Current Index: $currentIndex');
  }

  void initializeUserAnswers() {
    // Initialize userAnswers with null values for each question
    userAnswers =
        List<int?>.generate(widget.quiz.questions.length, (index) => null);
  }

// Update the onChanged method in your RadioListTile
  void onChanged(value) {
    setState(() {
      if (currentIndex < userAnswers.length) {
        userAnswers[currentIndex] = value; // Update the user's answer
        isAnswerSubmitted = true;

        // Check if an option is selected for the current question
        if (value != null) {
          isLastQuestion = currentIndex == widget.quiz.questions.length - 1;
        } else {
          isLastQuestion = false;
        }
      }
    });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
        } else {
          // Automatically submit the answers when the time ends
          if (!isTimeOverDialogShown) {
            Navigator.of(context).pop(); // Close the dialog

            // showConfirmationDialog(context);
            isTimeOverDialogShown = true;
            timer.cancel(); // Stop the timer when the dialog is shown
          }
        }

        // Ensure that remainingTime doesn't go below zero
        if (remainingTime < 0) {
          remainingTime = 0;
        }
      });
    });
  }

  Future<void> _retrieveToken() async {
    final prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString('token') ?? '';
  }

  Future<void> _fetchExamAnswer() async {
    setState(() {
      isSubmitting = true;
    });

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

      if (userToken.isEmpty) {
        print('Authentication token not found in SharedPreferences');
        return;
      }
      final examId = widget.examId;
      // final submitAnswers = <String, List<int?>>{};
      final List<Map<String, List<int?>>> submitAnswers = [];
      for (int i = 0; i < questions.length; i++) {
        final questionId = questions[i]['id'].toString();
        final answerId = userAnswers.length > i ? userAnswers[i] : null;
        // Include null for unanswered questions
        submitAnswers.add({
          questionId: [answerId]
        });
      }

      final response = await ExamQuestionsApi.submitAnswers(
        examId,
        userToken,
        // submitAnswers,
        Map.fromIterable(submitAnswers,
            key: (item) => item.keys.first, value: (item) => item.values.first),
      );

      print('Submit Answers: $submitAnswers');
      //  for (int i = 0; i < userAnswers.length; i++) {
      //   final questionId = questions[i]['id'].toString();
      //   final answerId = userAnswers[i];

      //   submitAnswers[questionId] = [answerId ?? 0];
      // }
      //   final response = await ExamQuestionsApi.submitAnswers(
      //       examId, userToken, submitAnswers);

      if (response.containsKey('total_score')) {
        int totalScore = 0;
        int correctAnswers = 0;
        int wrongAnswers = 0;
        int unattemptedQuestions = 0;

        for (int i = 0; i < widget.quiz.questions.length; i++) {
          final correctAnswerId = widget.quiz.questions[i].answerOptions
              .firstWhere((option) => option.isCorrect)
              .id;

          final userAnswerId = userAnswers[i];

          if (userAnswerId == null) {
            unattemptedQuestions++;
          } else if (userAnswerId == correctAnswerId) {
            correctAnswers++;
            totalScore +=
                1; // Assuming each correct answer adds 1 to the total score
          } else {
            wrongAnswers++;
          }
        }
        if (mounted) {
          // Navigate to ExamSubmissionPage with the calculated values
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ExamSubmissionPage(
                totalScore: totalScore,
                correctAnswers: correctAnswers,
                wrongAnswers: wrongAnswers,
                unattemptedQuestions: unattemptedQuestions,
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit exam answers.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack Trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected error occurred.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.purple[600],
        title: Text('Quiz Page'),
      ),
      backgroundColor: Colors.purple[50],
      body: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                // padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // if (isLoading)

                    // Container(
                    //   height: screenHeight * 0.5,
                    //   color: Colors.purple.withOpacity(0.5),
                    //   child: Center(
                    //     child: CircularProgressIndicator(),
                    //   ),
                    // ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      //height: MediaQuery.of(context).size.height * 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ColoredBox(
                            color: Colors.grey,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Question ${currentIndex + 1}/${widget.quiz.questions.length}:',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                            child: Icon(
                                              Icons.watch,
                                              size: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                ' Time Remaining: ${remainingTime}s',
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.quiz.questions[currentIndex].questionText,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            child: Column(
              children: [
                ...widget.quiz.questions[currentIndex].answerOptions
                    .asMap()
                    .entries
                    .map(
                      (entry) => Container(
                        color: entry.key % 2 == 0
                            ? Colors.purple[300]
                            : Colors.purple[200],
                        child: Column(
                          children: [
                            RadioListTile<int>(
                              title: Text(
                                '${optionsLetters[entry.key]} ${entry.value.optionText}',
                                overflow: TextOverflow.visible,
                              ),
                              value: entry.value.id,
                              groupValue: userAnswers.length > currentIndex
                                  ? userAnswers[currentIndex]
                                  : null,
                              onChanged: (value) {
                                setState(() {
                                  userAnswers.length = currentIndex + 1;
                                  userAnswers[currentIndex] = value;
                                  isAnswerSubmitted = true;
                                });
                              },
                            ),
                            // Divider(color: Colors.black),
                          ],
                        ),
                      ),
                    ),
              ],
            ),
          ),
          Container(
            height: screenHeight * 0.1,
            width: screenWidth,
            color: Colors.purple[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: currentIndex > 0
                      ? () {
                          switchButtonAction(ButtonAction.Previous);
                        }
                      : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        // Set color based on the button state
                        if (states.contains(MaterialState.disabled)) {
                          // Inactive color
                          return Colors.grey;
                        } else {
                          // Active color
                          return const Color.fromARGB(255, 206, 147, 216);
                        }
                      },
                    ),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: Text(
                    'Previous',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Red Hat Display',
                      fontSize: 18,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: isAnswerSubmitted && !isSubmitting
                      ? () {
                          if (isLastQuestion) {
                            switchButtonAction(ButtonAction.Finish);
                          } else {
                            switchButtonAction(ButtonAction.Next);
                          }
                        }
                      : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        // Set color based on the button state
                        if (states.contains(MaterialState.disabled)) {
                          // Inactive color
                          return Colors.grey;
                        } else {
                          // Active color
                          return const Color.fromARGB(255, 186, 104, 200);
                        }
                      },
                    ),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: Text(
                    isLastQuestion ? 'Finish' : 'Save & Next',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Red Hat Display',
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void switchButtonAction(ButtonAction action) {
    switch (action) {
      case ButtonAction.Finish:
        if (isAnswerSubmitted) {
          submitExam();
        }
        break;
      case ButtonAction.Next:
        moveToNextQuestion();
        break;
      case ButtonAction.Previous:
        moveToPreviousQuestion();
        break;
    }
  }

  void moveToNextQuestion() {
    setState(() {
      if (currentIndex < widget.quiz.questions.length - 1) {
        currentIndex++;

        // Check if currentIndex is within bounds and an answer has been submitted
        if ((currentIndex < userAnswers.length &&
                userAnswers[currentIndex] != null) &&
            isAnswerSubmitted == true) {
          isAnswerSubmitted = true;
        } else {
          isAnswerSubmitted = false;
        }

        isLastQuestion = currentIndex == widget.quiz.questions.length - 1;
      } else {
        isLastQuestion = true;
      }
    });
  }

  void moveToPreviousQuestion() {
    setState(() {
      if (currentIndex > 0) {
        currentIndex--;
        isAnswerSubmitted = userAnswers[currentIndex] != null;

        // Check if the user has selected an option for the previous question
        if (userAnswers[currentIndex] != null) {
          // If an option is selected, enable the "Next Question" button
          isLastQuestion = false;
        } else {
          // If no option is selected, disable the "Next Question" button
          isLastQuestion = true;
        }
      }
    });
  }

  void submitExam() async {
    // Check if the exam is already being submitted
    if (isSubmitting) {
      return;
    }

    setState(() {
      isLoading = true;
    });
    if (isLoading)
      showDialog(
        context: context,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );
    print('Selected Answers: $userAnswers');
    await _fetchExamAnswer();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}

enum ButtonAction { Next, Previous, Finish }
