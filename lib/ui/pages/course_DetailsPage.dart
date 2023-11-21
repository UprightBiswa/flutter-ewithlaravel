// import 'package:flutter/material.dart';

// class CourseDetailsPage extends StatefulWidget {
//   final Map<String, dynamic> course;

//   CourseDetailsPage({required this.course});

//   @override
//   State<CourseDetailsPage> createState() => _CourseDetailsPageState();
// }

// class _CourseDetailsPageState extends State<CourseDetailsPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Course Name: ${widget.course['course_name']}'),
//       ),
//       body: Center(
//         child: Text('Course Details'),
//       ),
//     );
//   }
// // }
// import 'package:elearning/services/courseApi.dart';
// import 'package:elearning/ui/widgets/card.dart';
// import 'package:flutter/material.dart';
// import 'package:elearning/theme/box_icons_icons.dart'; // Make sure to import the necessary icons

// class CourseDetailsPage extends StatefulWidget {
//   final Map<String, dynamic> course;

//   CourseDetailsPage({required this.course});

//   @override
//   State<CourseDetailsPage> createState() => _CourseDetailsPageState();
// }

// class _CourseDetailsPageState extends State<CourseDetailsPage> {
//   Future<void> _enrollInCourse() async {
//     final courseId = widget.course['id'];

//     try {
//       final response = await CourseApi.enrollCourse(courseId);

//       // Show the response message or handle accordingly
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(response['message']),
//         ),
//       );
//     } catch (e) {
//       // Handle exceptions
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('An unexpected error occurred.'),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Course Name: ${widget.course['course_name']}'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Display all information about the course
//             Text('Course ID: ${widget.course['id']}'),
//             Text('Course Code: ${widget.course['course_code']}'),
//             Text('Course Price: ${widget.course['course_price']}'),
//             Text('Course Duration: ${widget.course['course_duration']}'),
//             Text('Start Date: ${widget.course['start_from']}'),

//             // Add more details as needed

//             // Button to enroll in the course
//             Positioned(
//               bottom: 0,
//               left: 0,
//               child: CardWidget(
//                 button: true,
//                 gradient: true,
//                 height: 60,
//                 width: MediaQuery.of(context).size.width,
//                 child: InkWell(
//                   onTap: _enrollInCourse,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Text(
//                         "Enroll in this course ",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontFamily: 'Red Hat Display',
//                           fontSize: 18,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Icon(BoxIcons.bx_no_entry, color: Colors.white),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:elearning/services/courseApi.dart';
// import 'package:elearning/ui/widgets/card.dart';
// import 'package:flutter/material.dart';
// import 'package:elearning/theme/box_icons_icons.dart';

// class CourseDetailsPage extends StatefulWidget {
//   final Map<String, dynamic> course;

//   CourseDetailsPage({required this.course});

//   @override
//   State<CourseDetailsPage> createState() => _CourseDetailsPageState();
// }

// class _CourseDetailsPageState extends State<CourseDetailsPage> {

//   Future<void> _enrollInCourse() async {
//     try {
//       final courseId = widget.course['id'];
//       print('Enrolling in course with ID: $courseId');

//       final response = await CourseApi.enrollCourse(courseId);
//       print('Response: $response');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(response['message']),
//           backgroundColor: response.containsKey('error')
//               ? Colors.red
//               : Colors.green, // Adjust colors based on response
//         ),
//       );
//     } catch (e) {
//       print('Error: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('An unexpected error occurred.'),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Course Name: ${widget.course['course_name']}'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Display all information about the course
//             Text('Course ID: ${widget.course['id']}'),
//             Text('Course Code: ${widget.course['course_code']}'),
//             Text('Course Price: ${widget.course['course_price']}'),
//             Text('Course Duration: ${widget.course['course_duration']}'),
//             Text('Start Date: ${widget.course['start_from']}'),

//             // Add more details as needed

//             // Button to enroll in the course
//             Spacer(),
//             CardWidget(
//               button: true,
//               gradient: true,
//               height: 60,
//               width: MediaQuery.of(context).size.width,
//               child: InkWell(
//                 onTap: _enrollInCourse,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Text(
//                       "Enroll in this course ",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontFamily: 'Red Hat Display',
//                         fontSize: 18,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Icon(BoxIcons.bx_no_entry, color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:elearning/services/courseApi.dart';
import 'package:elearning/ui/pages/class_DetailsPage.dart';
import 'package:elearning/ui/widgets/card.dart';
import 'package:elearning/ui/widgets/cardinfo.dart';
import 'package:flutter/material.dart';
import 'package:elearning/theme/box_icons_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseDetailsPage extends StatefulWidget {
  final Map<String, dynamic> course;

  CourseDetailsPage({required this.course});

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  late String userToken;
  List<dynamic> enrolledClasses = [];

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
    _fetchEnrolledClasses();
  }

  Future<void> _enrollInCourse() async {
    try {
      // Check if the token is available
      if (userToken.isEmpty) {
        print('Authentication token not found in SharedPreferences');
        return;
      }

      final courseId = widget.course['id'];
      print('Enrolling in course with ID: $courseId');

      final response = await CourseApi.enrollCourse(courseId, userToken);
      print('Response: $response');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message']),
          backgroundColor: response.containsKey('error')
              ? Colors.red
              : Colors.green, // Adjust colors based on response
        ),
      );
      // If enrollment is successful, fetch the enrolled classes again
      if (!response.containsKey('error')) {
        _fetchEnrolledClasses();
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An unexpected error occurred.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _fetchEnrolledClasses() async {
    try {
      // Check if userToken is not null before using it
      if (userToken.isEmpty) {
        print('Authentication token not found in SharedPreferences');
        return;
      }

      // Fetch enrolled classes for the given course ID
      final courseId = widget.course['id'];
      final response = await CourseApi.getEnrolledClasses(courseId, userToken);

      // Update the state with the fetched enrolled classes
      setState(() {
        enrolledClasses = response['enrolled_course_classes'] ?? [];
      });
    } catch (e) {
      print('Error fetching enrolled classes: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course Id: ${widget.course['id']}'),
      ),
      body:
// Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             CardInfo(
//               title:
//                   'Name: ${widget.course['course_name'].toString().toUpperCase()}',
//               body:
//                   'Course Description: ${widget.course['course_description']}\n'
//                   'Course Code: ${widget.course['course_code']}\n'
//                   'Course Price: ${widget.course['course_price']}\n'
//                   'Course Duration: ${widget.course['course_duration']}Months',

//               onMoreTap: () {
//                 // Handle more tap
//               },
//               subInfoTitle: 'Start Date',
//               subInfoText: widget.course['start_from'],
//               subIcon: Icon(Icons
//                   .date_range_rounded), // Replace with your custom icon widget
//             ),

//             // Display all information about the course
//             // Text('Course ID: ${widget.course['id']}'),
//             // Text('Course Code: ${widget.course['course_code']}'),
//             // Text('Course Price: ${widget.course['course_price']}'),
//             // Text('Course Duration: ${widget.course['course_duration']}'),
//             // Text('Start Date: ${widget.course['start_from']}'),
// // Display enrolled classes
//             if (enrolledClasses.isNotEmpty)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 8),
//                   Text(
//                     'Enrolled Classes:',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   // Display enrolled classes using ListView.builder
//                   ListView.builder(
//                     shrinkWrap: true,
//                     itemCount: enrolledClasses.length,
//                     itemBuilder: (context, index) {
//                       final enrolledClass = enrolledClasses[index];
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 16.0),
//                         child: CardWidget(
//                           button: true,
//                           gradient: true,
//                           height: 80,
//                           width: MediaQuery.of(context).size.width,
//                           child: InkWell(
//                             onTap: () {
//                               // Handle card press for each enrolled class
//                             },
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: <Widget>[
//                                 Icon(BoxIcons.bx_no_entry),
//                                 Text(
//                                     'Class Name: ${enrolledClass['class_name']}'),
//                                 Text(
//                                     'Class Date: ${enrolledClass['class_date']}'),
//                                 Text(
//                                     'Class Time: ${enrolledClass['class_time']}'),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             Spacer(),
//             CardWidget(
//               button: true,
//               gradient: true,
//               height: 60,
//               width: MediaQuery.of(context).size.width,
//               child: InkWell(
//                 onTap: _enrollInCourse,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Text(
//                       "Enroll in this course ",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontFamily: 'Red Hat Display',
//                         fontSize: 18,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Icon(BoxIcons.bx_no_entry, color: Colors.white),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//           SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CardInfo(
//                 title:
//                     'Name: ${widget.course['course_name'].toString().toUpperCase()}',
//                 body:
//                     'Course Description: ${widget.course['course_description']}\n'
//                     'Course Code: ${widget.course['course_code']}\n'
//                     'Course Price: ${widget.course['course_price']}\n'
//                     'Course Duration: ${widget.course['course_duration']}Months',
//                 onMoreTap: () {
//                   // Handle more tap
//                 },
//                 subInfoTitle: 'Start Date',
//                 subInfoText: widget.course['start_from'],
//                 subIcon: Icon(Icons.date_range_rounded),
//               ),

//               // Display enrolled classes
//               if (enrolledClasses.isNotEmpty)
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 8),
//                     Text(
//                       'Enrolled Classes:',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 8),
//                     // Display enrolled classes using ListView.builder
//                     ListView.builder(
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       itemCount: enrolledClasses.length,
//                       itemBuilder: (context, index) {
//                         final enrolledClass = enrolledClasses[index];
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 16.0),
//                           child: CardWidget(
//                             button: true,
//                             gradient: true,
//                             height: 80,
//                             width: MediaQuery.of(context).size.width,
//                             child: InkWell(
//                               onTap: () {
//                                 // Handle card press for each enrolled class
//                               },
//                               child: Column(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: <Widget>[
//                                   Icon(BoxIcons.bx_no_entry),
//                                   Text(
//                                       'Class Name: ${enrolledClass['class_name']}'),
//                                   Text(
//                                       'Class Date: ${enrolledClass['class_date']}'),
//                                   Text(
//                                       'Class Time: ${enrolledClass['class_time']}'),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),

//               // Button to enroll in the course
//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: CardWidget(
//                   button: true,
//                   gradient: true,
//                   height: 60,
//                   child: InkWell(
//                     onTap: _enrollInCourse,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         Text(
//                           "Enroll in this course ",
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontFamily: 'Red Hat Display',
//                             fontSize: 18,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child:
//                               Icon(BoxIcons.bx_no_entry, color: Colors.white),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
          Stack(
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
                            'Name: ${widget.course['course_name'].toString().toUpperCase()}',
                        body:
                            'Course Description: ${widget.course['course_description']}\n'
                            'Course Code: ${widget.course['course_code']}\n'
                            'Course Price: ${widget.course['course_price']}\n'
                            'Course Duration: ${widget.course['course_duration']}Months',
                        onMoreTap: () {
                          // Handle more tap
                        },
                        subInfoTitle: 'Start Date',
                        subInfoText: widget.course['start_from'],
                        subIcon: Icon(Icons.date_range_rounded),
                      ),

                      // Display enrolled classes
                      if (enrolledClasses.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 8),
                            Text(
                              'Enrolled Classes:',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            // Display enrolled classes using ListView.builder
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: enrolledClasses.length,
                              itemBuilder: (context, index) {
                                final enrolledClass = enrolledClasses[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: CardWidget(
                                    button: true,
                                    gradient: true,
                                    height: 80,
                                    width: MediaQuery.of(context).size.width,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ClassDetailsPage(
                                              enrolledClasses: enrolledClass,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Icon(BoxIcons.bx_no_entry),
                                          Text(
                                              'Class Name: ${enrolledClass['class_name']}'),
                                          Text(
                                              'Class Time: ${enrolledClass['class_time']}'),
                                          Text(
                                              'Class Date: ${enrolledClass['class_date']}'),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            //SizedBox(height: 70),
                          ],
                        ),
                      if (enrolledClasses.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Center(
                              child:
                                  Text("You are not enrolled in this Course!")),
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Button to enroll in the course
          if (enrolledClasses.isEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CardWidget(
                  button: true,
                  gradient: false,
                  color: Colors.orange,
                  height: 60,
                  child: InkWell(
                    onTap: _enrollInCourse,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Enroll in this course ",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Red Hat Display',
                            fontSize: 18,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child:
                              Icon(BoxIcons.bx_no_entry, color: Colors.black),
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
