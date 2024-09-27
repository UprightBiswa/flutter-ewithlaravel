import 'package:elearning/app/services/classApi.dart';
import 'package:elearning/app/modules/ui/pages/exam_Pages.dart';
import 'package:elearning/app/modules/ui/pages/notes_Pages.dart';
import 'package:elearning/app/modules/ui/pages/video_Pages.dart';
import 'package:elearning/app/modules/ui/widgets/card.dart';
import 'package:elearning/app/modules/ui/widgets/cardinfo.dart';
import 'package:flutter/material.dart';
import 'package:elearning/app/controllers/theme/box_icons_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClassDetailsPage extends StatefulWidget {
  final Map<String, dynamic> enrolledClasses;

  ClassDetailsPage({required this.enrolledClasses});

  @override
  State<ClassDetailsPage> createState() => _ClassDetailsPageState();
}

class _ClassDetailsPageState extends State<ClassDetailsPage> {
  late String userToken;
  List<dynamic> classesDetails = [];
  List<dynamic> notes = []; // Add this line
  List<dynamic> videos = []; // Add this line
  List<dynamic> exams = []; // Add this line
  @override
  void initState() {
    super.initState();
    // Retrieve the token from SharedPreferences when the widget is initialized
    _retrieveToken();
  }

  Future<void> _retrieveToken() async {
    final prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString('token') ?? '';
    // Fetch enrolled classes for the course
    _fetchClassesDetails();
    print('response: ' + widget.enrolledClasses['id'].toString());
  }

  Future<void> _fetchClassesDetails() async {
    try {
      // Check if userToken is not null before using it
      if (userToken.isEmpty) {
        print('Authentication token not found in SharedPreferences');
        return;
      }

      // Fetch enrolled classes for the given course ID
      final classId = widget.enrolledClasses['id'].toString();
      final response = await ClasseApi.classDetails(classId, userToken);
      print('response: $classId');

      // Check if 'class_details' is a Map
      if (response['class_details'] is Map<String, dynamic>) {
        // Update the state with the fetched enrolled classes
        setState(() {
          classesDetails = [response['class_details']];
          notes = response['class_details']['notes'] ?? [];
          videos = response['class_details']['videos'] ?? [];
          exams = response['class_details']['exams'] ?? [];
        });
      } else {
        print('Invalid response format: class_details is not a Map');
      }
    } catch (e) {
      print('Error fetching class details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.purple[600],
        title: Text('Class Name: ${widget.enrolledClasses['class_name']}'),
      ),
      backgroundColor: Colors.purple[50],
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CardInfo(
                        title:
                            'Class Id: ${widget.enrolledClasses['id'].toString().toUpperCase()}',
                        body:
                            'Class Name: ${widget.enrolledClasses['class_name']}\n'
                            'Class Date: ${widget.enrolledClasses['class_date']}\n'
                            'Class Time: ${widget.enrolledClasses['class_time']} Months',
                        onMoreTap: () {
                          // Handle more tap
                        },
                        subInfoTitle: 'Start Date',
                        subInfoText: widget.enrolledClasses['class_date'],
                        subIcon: Icon(Icons.date_range_rounded),
                      ),
                      // Buttons for Notes, Videos, and Exams
                      if (classesDetails.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Text(
                              'Classes Details:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ClassNotesPage(
                                      notes: notes,
                                    ),
                                  ),
                                );
                              },
                              child: CardWidget(
                                button: true,
                                gradient: true,
                                height: 80,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Icon(BoxIcons.bx_no_entry),
                                    Text('Class Notes'),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ClassVideosPage(
                                      videos: videos,
                                    ),
                                  ),
                                );
                              },
                              child: CardWidget(
                                button: true,
                                gradient: true,
                                height: 80,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Icon(BoxIcons.bx_no_entry),
                                    Text('Class Videos'),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ClassExamsPage(
                                      exams: exams,
                                    ),
                                  ),
                                );
                              },
                              child: CardWidget(
                                button: true,
                                gradient: true,
                                height: 80,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Icon(BoxIcons.bx_no_entry),
                                    Text('Class Exams'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
