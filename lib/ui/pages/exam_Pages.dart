// ClassExamsPage.dart
import 'package:elearning/ui/pages/quize_InstractionPage.dart';
import 'package:elearning/ui/widgets/customlisttile.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ClassExamsPage extends StatelessWidget {
  final List<dynamic> exams;

  ClassExamsPage({required this.exams});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Class Exams'),
      ),
      body: ListView.builder(
        itemCount: exams.length,
        itemBuilder: (context, index) {
          final exam = exams[index];
          return Column(
            children: [
              Gap(10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: CustomListTile(
                  serialNumber: index + 1,
                  title: exam['exam_subject'],
                  onPressed: () {
                   // Navigate to Exam Details page and pass exam data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExamDetailPage(
                          examId: exam['id'],
                          examSubject: exam['exam_subject'],
                          examDate: exam['exam_date'],
                          examDuration: exam['exam_duration'],
                          // Add more properties as needed
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


 