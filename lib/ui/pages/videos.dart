// import 'dart:convert';

// import 'package:elearning/services/api.dart';
// import 'package:elearning/services/user_details_api_client.dart';
// import 'package:elearning/theme/config.dart' as config;
// import 'package:elearning/ui/widgets/sectionHeader.dart';
// import 'package:elearning/ui/widgets/topBar.dart';
// import 'package:elearning/ui/widgets/videoCard.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// class Video {
//   final int id;
//   final String videoSubject;
//   final String videoDate;
//   final String videoFile;
//   final int classId;
//   final String createdAt;

//   Video({
//     required this.id,
//     required this.videoSubject,
//     required this.videoDate,
//     required this.videoFile,
//     required this.classId,
//     required this.createdAt,
//   });

//   factory Video.fromJson(Map<String, dynamic> json) {
//     return Video(
//       id: json['id'],
//       videoSubject: json['video_subject'],
//       videoDate: json['video_date'],
//       videoFile: json['video_file'],
//       classId: json['class_id'],
//       createdAt: json['created_at'],
//     );
//   }
// }

// Future<List<String>> fetchSubjectNames() async {
//   try {
//     final prefs = await SharedPreferences.getInstance();
//     final userToken = prefs.getString('token');

//     if (userToken == null) {
//       print('Authentication token not found in SharedPreferences');
//       return [];
//     }

//     final apiUrl = Uri.parse('$baseURL/student/classes');

//     final response = await http.get(
//       apiUrl,
//       headers: {
//         'Authorization': 'Bearer $userToken',
//       },
//     );

//     if (response.statusCode == 200) {
//       final dynamic responseData = json.decode(response.body);
//       if (responseData is Map && responseData.containsKey('classes')) {
//         final List<dynamic> classes = responseData['classes'];

//         // Extract class names from each class object and cast them to String
//         final List<String> subjectNames = classes.map((classData) {
//           if (classData is Map && classData.containsKey('class_name')) {
//             return classData['class_name'] as String;
//           }
//           return ''; // Return an empty string if class_name is not available
//         }).toList();

//         return subjectNames;
//       }
//     }

//     // Handle other cases (failed request or invalid response)
//     return [];
//   } catch (e) {
//     print('Failed to fetch subject names: $e');
//     return [];
//   }
// }

// Future<List<Video>> fetchVideosForClass(int classId) async {
//   try {
//     final prefs = await SharedPreferences.getInstance();
//     final userToken = prefs.getString('token');

//     if (userToken == null) {
//       print('Authentication token not found in SharedPreferences');
//       return [];
//     }

//     final apiUrl = Uri.parse('$baseURL/student/videos/$classId');

//     final response = await http.get(
//       apiUrl,
//       headers: {
//         'Authorization': 'Bearer $userToken',
//       },
//     );

//     if (response.statusCode == 200) {
//       final dynamic responseData = json.decode(response.body);
//       if (responseData is Map && responseData.containsKey('videos')) {
//         final List<dynamic> videoData = responseData['videos'];

//         final List<Video> videos = videoData.map((videoJson) {
//           return Video.fromJson(videoJson);
//         }).toList();

//         return videos;
//       }
//     }

//     // Handle other cases (failed request or invalid response)
//     return [];
//   } catch (e) {
//     print('Failed to fetch videos for class: $e');
//     return [];
//   }
// }

// // class VideosPage extends StatelessWidget {
// //   VideosPage({
// //     Key? key,
// //     required this.onMenuTap,
// //     required this.user
// //   }) : super(key: key);
// //   final Function? onMenuTap;
// //   final User user;

// //   final TextEditingController controller = TextEditingController();
// //   @override
// //   Widget build(BuildContext context) {
// //     return CupertinoPageScaffold(
// //       backgroundColor: config.Colors().secondColor(1),
// //       child: Stack(
// //         alignment: Alignment.center,
// //         children: <Widget>[
// //           SafeArea(
// //             child: CustomScrollView(
// //               slivers: <Widget>[
// //                 SliverFixedExtentList(
// //                     delegate: SliverChildListDelegate.fixed([Container()]),
// //                     itemExtent: MediaQuery.of(context).size.height * 0.16),
// //                 SliverToBoxAdapter(
// //                   child: SectionHeader(
// //                     text: 'Best of Physics',
// //                     onPressed: () {},
// //                   ),
// //                 ),
// //                 SliverToBoxAdapter(
// //                   child: Container(
// //                     width: MediaQuery.of(context).size.width,
// //                     height: 245,
// //                     child: ListView.builder(
// //                       scrollDirection: Axis.horizontal,
// //                       itemCount: 4,
// //                       itemBuilder: (context, index) {
// //                         return VideoCard(long: false);
// //                       },
// //                     ),
// //                   ),
// //                 ),
// //                 SliverToBoxAdapter(
// //                   child: SectionHeader(
// //                     text: 'Best of Chemistry',
// //                     onPressed: () {},
// //                   ),
// //                 ),
// //                 SliverToBoxAdapter(
// //                   child: Container(
// //                     width: MediaQuery.of(context).size.width,
// //                     height: 245,
// //                     child: ListView.builder(
// //                       scrollDirection: Axis.horizontal,
// //                       itemCount: 4,
// //                       itemBuilder: (context, index) {
// //                         return VideoCard(long: false);
// //                       },
// //                     ),
// //                   ),
// //                 ),
// //                 SliverToBoxAdapter(
// //                   child: SectionHeader(
// //                     text: 'Best of Maths',
// //                     onPressed: () {},
// //                   ),
// //                 ),
// //                 SliverToBoxAdapter(
// //                   child: Container(
// //                     width: MediaQuery.of(context).size.width,
// //                     height: 245,
// //                     child: ListView.builder(
// //                       scrollDirection: Axis.horizontal,
// //                       itemCount: 4,
// //                       itemBuilder: (context, index) {
// //                         return VideoCard(long: false);
// //                       },
// //                     ),
// //                   ),
// //                 ),
// //                 SliverToBoxAdapter(
// //                   child: SectionHeader(
// //                     text: 'Best of Biology',
// //                     onPressed: () {},
// //                   ),
// //                 ),
// //                 SliverToBoxAdapter(
// //                   child: Container(
// //                     width: MediaQuery.of(context).size.width,
// //                     height: 245,
// //                     child: ListView.builder(
// //                       scrollDirection: Axis.horizontal,
// //                       itemCount: 4,
// //                       itemBuilder: (context, index) {
// //                         return VideoCard(long: false);
// //                       },
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Positioned(
// //             top: 0,
// //             child: TopBar(
// //               controller: controller,
// //               expanded: false,
// //               onMenuTap: onMenuTap,
// //                userName: user.name, // Use user.name directly here
// //             ),
// //           )
// //         ],
// //       ),
// //     );
// //   }
// // }
// // class VideosPage extends StatefulWidget {
// //   VideosPage({
// //     Key? key,
// //     required this.onMenuTap,
// //     required this.user,
// //   }) : super(key: key);

// //   final Function? onMenuTap;
// //   final User user;

// //   @override
// //   _VideosPageState createState() => _VideosPageState();
// // }

// // class _VideosPageState extends State<VideosPage> {
// //   final TextEditingController controller = TextEditingController();
// //   List<String> subjectNames = [];

// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchSubjectNames().then((names) {
// //       setState(() {
// //         subjectNames = names;
// //       });
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return CupertinoPageScaffold(
// //       backgroundColor: config.Colors().secondColor(1),
// //       child: Stack(
// //         alignment: Alignment.center,
// //         children: <Widget>[
// //           SafeArea(
// //             child: CustomScrollView(
// //               slivers: <Widget>[
// //                 SliverFixedExtentList(
// //                     delegate: SliverChildListDelegate.fixed([Container()]),
// //                     itemExtent: MediaQuery.of(context).size.height * 0.16),
// //                 for (final subjectName in subjectNames)
// //                   SliverToBoxAdapter(
// //                     child: SectionHeader(
// //                       text: 'Best of $subjectName',
// //                       onPressed: () {},
// //                     ),
// //                   ),
// //                 SliverToBoxAdapter(
// //                   child: Container(
// //                     width: MediaQuery.of(context).size.width,
// //                     height: 245,
// //                     child: ListView.builder(
// //                       scrollDirection: Axis.horizontal,
// //                       itemCount: 4,
// //                       itemBuilder: (context, index) {
// //                         return VideoCard(long: false);
// //                       },
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Positioned(
// //             top: 0,
// //             child: TopBar(
// //               controller: controller,
// //               expanded: false,
// //               onMenuTap: widget.onMenuTap,
// //               userName: widget.user.name, // Use user.name directly here
// //             ),
// //           )
// //         ],
// //       ),
// //     );
// //   }
// // }
// class VideosPage extends StatefulWidget {
//   VideosPage({
//     Key? key,
//     required this.onMenuTap,
//     required this.user,
//   }) : super(key: key);

//   final Function? onMenuTap;
//   final User user;

//   @override
//   _VideosPageState createState() => _VideosPageState();
// }

// class _VideosPageState extends State<VideosPage> {
//   final TextEditingController controller = TextEditingController();
//   List<String> subjectNames = [];
//   List<Video> videos = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchSubjectNames().then((names) {
//       setState(() {
//         subjectNames = names;
//       });
//     });
//   }

//   Future<void> fetchVideos(int classId) async {
//     final fetchedVideos = await fetchVideosForClass(classId);
//     setState(() {
//       videos = fetchedVideos;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//       backgroundColor: config.Colors().secondColor(1),
//       child: Stack(
//         alignment: Alignment.center,
//         children: <Widget>[
//           SafeArea(
//             child: CustomScrollView(
//               slivers: <Widget>[
//                 SliverFixedExtentList(
//                     delegate: SliverChildListDelegate.fixed([Container()]),
//                     itemExtent: MediaQuery.of(context).size.height * 0.16),
//                 for (final subjectName in subjectNames)
//                   SliverToBoxAdapter(
//                     child: Column(
//                       children: <Widget>[
//                         SectionHeader(
//                           text: 'Best of $subjectName',
//                           onPressed: () {},
//                         ),
//                         Container(
//                           width: MediaQuery.of(context).size.width,
//                           height: 245,
//                           child: ListView.builder(
//                             scrollDirection: Axis.horizontal,
//                             itemCount: 4,
//                             itemBuilder: (context, index) {
//                               return VideoCardclass(
//                                 long: false,
//                                 title: "Stars - What are they made up of ?",
//                                 videoDate: "2023-08-26",
//                                 videoSubject: "larevl",
//                               );
//                             },
//                           ),
//                         ),
//                         // Add class-specific content here, e.g., additional videos
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           Positioned(
//             top: 0,
//             child: TopBar(
//               controller: controller,
//               expanded: false,
//               onMenuTap: widget.onMenuTap,
//               userName: widget.user.name, // Use user.name directly here
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
// import 'dart:convert';

// import 'package:elearning/services/api.dart';
// import 'package:elearning/services/user_details_api_client.dart';
// import 'package:elearning/theme/config.dart' as config;
// import 'package:elearning/ui/widgets/sectionHeader.dart';
// import 'package:elearning/ui/widgets/topBar.dart';
// import 'package:elearning/ui/widgets/videoCard.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;

// class Video {
//   final int id;
//   final String videoSubject;
//   final String videoDate;
//   final String videoFile;
//   final int classId;
//   final String createdAt;

//   Video({
//     required this.id,
//     required this.videoSubject,
//     required this.videoDate,
//     required this.videoFile,
//     required this.classId,
//     required this.createdAt,
//   });

//   factory Video.fromJson(Map<String, dynamic> json) {
//     return Video(
//       id: json['id'],
//       videoSubject: json['video_subject'],
//       videoDate: json['video_date'],
//       videoFile: json['video_file'],
//       classId: json['class_id'],
//       createdAt: json['created_at'],
//     );
//   }
// }

// Future<List<String>> fetchSubjectNames() async {
//   try {
//     final prefs = await SharedPreferences.getInstance();
//     final userToken = prefs.getString('token');

//     if (userToken == null) {
//       print('Authentication token not found in SharedPreferences');
//       return [];
//     }

//     final apiUrl = Uri.parse('$baseURL/student/classes');

//     final response = await http.get(
//       apiUrl,
//       headers: {
//         'Authorization': 'Bearer $userToken',
//       },
//     );

//     if (response.statusCode == 200) {
//       final dynamic responseData = json.decode(response.body);
//       if (responseData is Map && responseData.containsKey('classes')) {
//         final List<dynamic> classes = responseData['classes'];

//         // Extract class names from each class object and cast them to String
//         final List<String> subjectNames = classes.map((classData) {
//           if (classData is Map && classData.containsKey('class_name')) {
//             print('Class Name: $classData');
//             return classData['class_name'] as String;
//           }
//           return ''; // Return an empty string if class_name is not available
//         }).toList();

//         return subjectNames;
//       }
//     }

//     // Handle other cases (failed request or invalid response)
//     return [];
//   } catch (e) {
//     print('Failed to fetch subject names: $e');
//     return [];
//   }
// }

// Future<List<Video>> fetchVideosForClass(int classId) async {
//   try {
//     final prefs = await SharedPreferences.getInstance();
//     final userToken = prefs.getString('token');

//     if (userToken == null) {
//       print('Authentication token not found in SharedPreferences');
//       return [];
//     }

//     final apiUrl = Uri.parse('$baseURL/student/classes/$classId/videos');

//     final response = await http.get(
//       apiUrl,
//       headers: {
//         'Authorization': 'Bearer $userToken',
//       },
//     );

//     if (response.statusCode == 200) {
//       final dynamic responseData = json.decode(response.body);
//       if (responseData is Map && responseData.containsKey('videos')) {
//         final List<dynamic> videoData = responseData['videos'];

//         final List<Video> videos = videoData.map((videoJson) {
//           return Video.fromJson(videoJson);
//         }).toList();

//         return videos;
//       }
//     }

//     // Handle other cases (failed request or invalid response)
//     return [];
//   } catch (e) {
//     print('Failed to fetch videos for class: $e');
//     return [];
//   }
// }

// class VideosPage extends StatefulWidget {
//   VideosPage({
//     Key? key,
//     required this.onMenuTap,
//     required this.user,
//   }) : super(key: key);

//   final Function? onMenuTap;
//   final User user;

//   @override
//   _VideosPageState createState() => _VideosPageState();
// }

// class _VideosPageState extends State<VideosPage> {
//   final TextEditingController controller = TextEditingController();
//   List<String> subjectNames = [];
//   Map<String, List<Video>> videosMap = {};

//   @override
//   void initState() {
//     super.initState();
//     fetchSubjectNames().then((names) {
//       setState(() {
//         subjectNames = names;
//         print('Class Name: $subjectNames');
//         // Fetch videos for each class
//         for (final subjectName in subjectNames) {
//           print('subject Name: $subjectNames');

//           fetchVideos(subjectName);
//         }
//       });
//     });
//   }

//   Future<void> fetchVideos(String subjectName) async {
//     final classId = subjectNames.indexOf(subjectName) + 1;
//     final fetchedVideos = await fetchVideosForClass(classId);
//     setState(() {
//       videosMap[subjectName] = fetchedVideos;
//       // Log class name and video names
//       print('Class Name: $subjectName');
//       for (final video in fetchedVideos) {
//         print('Video Name: ${video.videoSubject}, Class ID: ${video.classId}');
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//       backgroundColor: config.Colors().secondColor(1),
//       child: Stack(
//         alignment: Alignment.center,
//         children: <Widget>[
//           SafeArea(
//             child: CustomScrollView(
//               slivers: <Widget>[
//                 SliverFixedExtentList(
//                   delegate: SliverChildListDelegate.fixed([Container()]),
//                   itemExtent: MediaQuery.of(context).size.height * 0.16,
//                 ),
//                 for (final className in subjectNames)
//                   SliverToBoxAdapter(
//                     child: Column(
//                       children: <Widget>[
//                         SectionHeader(
//                           text: 'Best of $className',
//                           onPressed: () {},
//                         ),
//                         if (videosMap.containsKey(className))
//                           Container(
//                             width: MediaQuery.of(context).size.width,
//                             height: 245,
//                             child: ListView.builder(
//                               scrollDirection: Axis.horizontal,
//                               itemCount: videosMap[className]?.length ?? 0,
//                               itemBuilder: (context, index) {
//                                 return VideoCardclass(
//                                   // Use the VideoCard widget
//                                   long: false,
//                                   title: 'hi',
//                                   videoDate: '1/2/2',
//                                   videoSubject: 'kdfbksfbk',
//                                   // title: videosMap[className]![index].videoSubject,
//                                   // videoDate: videosMap[className]![index].videoDate,
//                                   // videoSubject: className,
//                                 );
//                               },
//                             ),
//                           ),
//                         if (!videosMap.containsKey(className))
//                           Container(
//                             alignment: Alignment.center,
//                             child: Text("No videos found for this class."),
//                           ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           ),
//           Positioned(
//             top: 0,
//             child: TopBar(
//               controller: controller,
//               expanded: false,
//               onMenuTap: widget.onMenuTap,
//               userName: widget.user.name, // Use user.name directly here
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:convert';

import 'package:elearning/services/api.dart';
import 'package:elearning/services/user_details_api_client.dart';
import 'package:elearning/theme/config.dart' as config;
import 'package:elearning/ui/widgets/sectionHeader.dart';
import 'package:elearning/ui/widgets/topBar.dart';
import 'package:elearning/ui/widgets/videoCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Video {
  final int id;
  final String videoSubject;
  final String videoDate;
  final String videoFile;
  final int classId;
  final String createdAt;

  Video({
    required this.id,
    required this.videoSubject,
    required this.videoDate,
    required this.videoFile,
    required this.classId,
    required this.createdAt,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      videoSubject: json['video_subject'],
      videoDate: json['video_date'],
      videoFile: json['video_file'],
      classId: json['class_id'],
      createdAt: json['created_at'],
    );
  }
}

Future<List<String>> fetchSubjectNames() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString('token');

    if (userToken == null) {
      print('Authentication token not found in SharedPreferences');
      return [];
    }

    final apiUrl = Uri.parse('$baseURL/student/classes');

    final response = await http.get(
      apiUrl,
      headers: {
        'Authorization': 'Bearer $userToken',
      },
    );

    if (response.statusCode == 200) {
      final dynamic responseData = json.decode(response.body);
      if (responseData is Map && responseData.containsKey('classes')) {
        final List<dynamic> classes = responseData['classes'];

        // Extract class names and IDs from each class object
        final List<String> subjectNames = [];
        for (final classData in classes) {
          if (classData is Map && classData.containsKey('class_name')) {
            final className = classData['class_name'] as String;
            final classId = classData['id'] as int;
            print('Class Name: $className, Class ID: $classId');
            subjectNames.add(className);
          }
        }

        return subjectNames;
      }
    }

    // Handle other cases (failed request or invalid response)
    return [];
  } catch (e) {
    print('Failed to fetch subject names: $e');
    return [];
  }
}

Future<List<Video>> fetchVideosForClass(String className, int classId) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final userToken = prefs.getString('token');

    if (userToken == null) {
      print('Authentication token not found in SharedPreferences');
      return [];
    }

    final apiUrl = Uri.parse('$baseURL/student/classes/$classId/videos');

    final response = await http.get(
      apiUrl,
      headers: {
        'Authorization': 'Bearer $userToken',
      },
    );

    if (response.statusCode == 200) {
      final dynamic responseData = json.decode(response.body);
      if (responseData is Map && responseData.containsKey('videos')) {
        final List<dynamic> videoData = responseData['videos'];

        final List<Video> videos = videoData.map((videoJson) {
          return Video.fromJson(videoJson);
        }).toList();

        // Log video names for this class
        print('Class Name: $className, Class ID: $classId');
        for (final video in videos) {
          print('Video Name: ${video.videoSubject}, Video ID: ${video.id}');
        }
        return videos; // Return the list of videos
      }
    }
    return []; // Return an empty list
    // Handle other cases (failed request or invalid response)
  } catch (e) {
    print('Failed to fetch videos for class $className: $e');
    return []; // Return an empty list
  }
}

class VideosPage extends StatefulWidget {
  VideosPage({
    Key? key,
    required this.onMenuTap,
    required this.user,
  }) : super(key: key);

  final Function? onMenuTap;
  final User user;

  @override
  _VideosPageState createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  final TextEditingController controller = TextEditingController();
  List<String> subjectNames = [];
  Map<String, List<Video>> videosMap = {};

  @override
  void initState() {
    super.initState();
    fetchSubjectNames().then((names) {
      setState(() {
        subjectNames = names;
        // Fetch videos for each class
        for (final subjectName in subjectNames) {
          fetchVideos(subjectName);
        }
      });
    });
  }

  Future<void> fetchVideos(String className) async {
    final classId =
        videosMap.length + 1; // Simulate class IDs based on the order
    final List<Video> fetchedVideos =
        await fetchVideosForClass(className, classId);
    setState(() {
      // Ensure the value assigned to videosMap[className] is a List<Video>
      videosMap[className] = fetchedVideos;
      // Log class name and video names
      print('Class Name: $className, Class ID: $classId');
      for (final video in fetchedVideos) {
        print('Video Name: ${video.videoSubject}, Class ID: ${video.classId}');
      }
    });
  }
// https://topcem.indigierp.com/
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: config.Colors().secondColor(1),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SafeArea(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverFixedExtentList(
                  delegate: SliverChildListDelegate.fixed([Container()]),
                  itemExtent: MediaQuery.of(context).size.height * 0.16,
                ),
                for (final className in subjectNames)
                  SliverToBoxAdapter(
                    child: Column(
                      children: <Widget>[
                        SectionHeader(
                          text: 'Best of $className',
                          onPressed: () {},
                        ),
                        if (videosMap.containsKey(className))
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 245,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: videosMap[className]?.length ?? 0,
                              itemBuilder: (context, index) {
                                return VideoCardclass(
                                  long: false,
                                  title:
                                      videosMap[className]![index].videoSubject,
                                  videoDate:
                                      videosMap[className]![index].videoDate,
                                  videoSubject: className,
                                );
                              },
                            ),
                          ),
                        if (!videosMap.containsKey(className))
                          Container(
                            alignment: Alignment.center,
                            child: Text("No videos found for this class."),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: TopBar(
              controller: controller,
              expanded: false,
              onMenuTap: widget.onMenuTap,
              userName: widget.user.name,
            ),
          ),
        ],
      ),
    );
  }
}
