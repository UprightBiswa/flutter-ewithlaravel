// ClassExamsPage.dart
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


 