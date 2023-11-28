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

//         // Extract class names and IDs from each class object
//         final List<String> subjectNames = [];
//         for (final classData in classes) {
//           if (classData is Map && classData.containsKey('class_name')) {
//             final className = classData['class_name'] as String;
//             final classId = classData['id'] as int;
//             print('Class Name: $className, Class ID: $classId');
//             subjectNames.add(className);
//           }
//         }

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

// Future<List<Video>> fetchVideosForClass(String className, int classId) async {
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

//         // Log video names for this class
//         print('Class Name: $className, Class ID: $classId');
//         for (final video in videos) {
//           print('Video Name: ${video.videoSubject}, Video ID: ${video.id}, Class ID: $classId');
//         }
//         return videos; // Return the list of videos
//       }
//     }
//     return []; // Return an empty list
//     // Handle other cases (failed request or invalid response)
//   } catch (e) {
//     print('Failed to fetch videos for class $className: $e');
//     return []; // Return an empty list
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
//         // Fetch videos for each class
//         for (final subjectName in subjectNames) {
//           fetchVideos(subjectName);
//         }
//       });
//     });
//   }

//   Future<void> fetchVideos(String className) async {
//     final classId = videosMap.length + 1; // Simulate class IDs based on the order
//     final List<Video> fetchedVideos = await fetchVideosForClass(className, classId);
//     setState(() {
//       // Ensure the value assigned to videosMap[className] is a List<Video>
//       videosMap[className] = fetchedVideos;
//       // Log class name and video names
//       print('Class Name: $className, Class ID: $classId');
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
//                         if (videosMap.containsKey(className) && videosMap[className]!.isNotEmpty)
//                           Container(
//                             width: MediaQuery.of(context).size.width,
//                             height: 245,
//                             child: ListView.builder(
//                               scrollDirection: Axis.horizontal,
//                               itemCount: videosMap[className]?.length ?? 0,
//                               itemBuilder: (context, index) {
//                                 return VideoCardclass(
//                                   long: false,
//                                   title: videosMap[className]![index].videoSubject,
//                                   videoDate: videosMap[className]![index].videoDate,
//                                   videoSubject: className,
//                                 );
//                               },
//                             ),
//                           ),
//                         if (videosMap.containsKey(className) && videosMap[className]!.isEmpty)
//                           Container(
//                             alignment: Alignment.center,
//                             child: Text("No videos found for this class."),
//                           ),
//                         if (!videosMap.containsKey(className))
//                           Container(
//                             alignment: Alignment.center,
//                             child: Text("Loading..."),
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
//               userName: widget.user.name,
//             ),
//           ),
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
//   List<String> enrolledSubjectNames = [];
//   Map<String, List<Video>> videosMap = {};

//   @override
//   void initState() {
//     super.initState();
//     print("hi run vieo");
//     fetchEnrolledSubjectNames().then((names) {
//       setState(() {
//         enrolledSubjectNames = names;
//         print("hi run vieo");
//       });
//     });
//   }

//   Future<void> fetchVideos(String className, int classId) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final userToken = prefs.getString('token');

//       if (userToken == null) {
//         print('Authentication token not found in SharedPreferences');
//         return;
//       }

//       final apiUrlVideos =
//           Uri.parse('$baseURL/student/classes/$classId/videos');

//       final responseVideos = await http.get(
//         apiUrlVideos,
//         headers: {
//           'Authorization': 'Bearer $userToken',
//         },
//       );

//       if (responseVideos.statusCode == 200) {
//         final dynamic responseDataVideos = json.decode(responseVideos.body);
//         if (responseDataVideos is Map &&
//             responseDataVideos.containsKey('videos')) {
//           final List<dynamic> videoData = responseDataVideos['videos'];

//           final List<Video> videos = videoData.map((videoJson) {
//             return Video.fromJson(videoJson);
//           }).toList();

//           // Log class name and video names
//           print('Class Name: $className, Class ID: $classId');
//           for (final video in videos) {
//             print(
//                 'Video Name: ${video.videoSubject}, Video ID: ${video.id}, Class ID: $classId');
//           }

//           setState(() {
//             // Ensure the value assigned to videosMap[className] is a List<Video>
//             videosMap[className] = videos;
//           });
//         }
//       }
//     } catch (e) {
//       print('Failed to fetch videos for class $className: $e');
//     }
//   }

//   Future<List<String>> fetchEnrolledSubjectNames() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final userToken = prefs.getString('token');

//       if (userToken == null) {
//         print('Authentication token not found in SharedPreferences');
//         return [];
//       }

//       final apiUrl =
//           Uri.parse('$baseURL/student/classes/enrolledclasses/userclass');

//       final response = await http.get(
//         apiUrl,
//         headers: {
//           'Authorization': 'Bearer $userToken',
//         },
//       );

//       if (response.statusCode == 200) {
//         final dynamic responseData = json.decode(response.body);
//         if (responseData is Map &&
//             responseData.containsKey('enrolled_classes')) {
//           final List<dynamic> enrolledClasses =
//               responseData['enrolled_classes'];

//           // Extract class names from each enrolled class object
//           final List<String> enrolledSubjectNames = [];
//           for (final enrolledClass in enrolledClasses) {
//             if (enrolledClass is Map && enrolledClass.containsKey('classes')) {
//               final List<dynamic> classes = enrolledClass['classes'];
//               for (final classData in classes) {
//                 if (classData is Map && classData.containsKey('class_name')) {
//                   final className = classData['class_name'] as String;
//                   final classId = classData['id'] as int;
//                   print('Enrolled Class Name: $className,Class ID: $classId');
//                   enrolledSubjectNames.add(className);
//                   // Fetch videos for each class using the actual class ID
//                   fetchVideos(className, classId);
//                 }
//               }
//             }
//           }

//           return enrolledSubjectNames;
//         }
//       }

//       // Handle other cases (failed request or invalid response)
//       return [];
//     } catch (e) {
//       print('Failed to fetch enrolled subject names: $e');
//       return [];
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//       backgroundColor: config.Colorss().secondColor(1),
//       child: Stack(
//         alignment: Alignment.center,
//         children: <Widget>[
//           SafeArea(
//             child: CustomScrollView(
//               slivers: <Widget>[
//                 SliverFixedExtentList(
//                   delegate: SliverChildListDelegate.fixed([Container()]),
//                   itemExtent: MediaQuery.of(context).size.height * 0.22,
//                 ),
//                 for (final className in enrolledSubjectNames)
//                   SliverToBoxAdapter(
//                     child: Column(
//                       children: <Widget>[
//                         SectionHeader(
//                           text: 'Best of $className',
//                           onPressed: () {},
//                         ),
//                         if (videosMap.containsKey(className) &&
//                             videosMap[className]!.isNotEmpty)
//                           Container(
//                             width: MediaQuery.of(context).size.width,
//                             height: 245,
//                             child: ListView.builder(
//                               scrollDirection: Axis.horizontal,
//                               itemCount: videosMap[className]?.length ?? 0,
//                               itemBuilder: (context, index) {
//                                 return VideoCardclass(
//                                   long: false,
//                                   title:
//                                       videosMap[className]![index].videoSubject,
//                                   videoDate:
//                                       videosMap[className]![index].videoDate,
//                                   videoSubject: className,
//                                 );
//                               },
//                             ),
//                           ),
//                         if (videosMap.containsKey(className) &&
//                             videosMap[className]!.isEmpty)
//                           Container(
//                             alignment: Alignment.center,
//                             child: Text("No videos found for this class."),
//                           ),
//                         if (!videosMap.containsKey(className))
//                           Container(
//                             alignment: Alignment.center,
//                             child: Text("Loading..."),
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
//               userName: widget.user.name,
//             ),
//           ),
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
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'package:shimmer/shimmer.dart';

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
//   List<String> enrolledSubjectNames = [];
//   Map<String, List<Video>> videosMap = {};

//   @override
//   void initState() {
//     super.initState();
//     fetchEnrolledSubjectNames().then((names) {
//       setState(() {
//         enrolledSubjectNames = names;
//       });
//     });
//   }

//   Future<void> fetchVideos(String className, int classId) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final userToken = prefs.getString('token');

//       if (userToken == null) {
//         print('Authentication token not found in SharedPreferences');
//         return;
//       }

//       final apiUrlVideos =
//           Uri.parse('$baseURL/student/classes/$classId/videos');

//       final responseVideos = await http.get(
//         apiUrlVideos,
//         headers: {
//           'Authorization': 'Bearer $userToken',
//         },
//       );

//       if (responseVideos.statusCode == 200) {
//         final dynamic responseDataVideos = json.decode(responseVideos.body);
//         if (responseDataVideos is Map &&
//             responseDataVideos.containsKey('videos')) {
//           final List<dynamic> videoData = responseDataVideos['videos'];

//           final List<Video> videos = videoData.map((videoJson) {
//             return Video.fromJson(videoJson);
//           }).toList();

//           print('Class Name: $className, Class ID: $classId');
//           for (final video in videos) {
//             print(
//                 'Video Name: ${video.videoSubject}, Video ID: ${video.id}, Class ID: $classId');
//           }

//           setState(() {
//             videosMap[className] = videos;
//           });
//         }
//       }
//     } catch (e) {
//       print('Failed to fetch videos for class $className: $e');
//     }
//   }

//   Future<List<String>> fetchEnrolledSubjectNames() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final userToken = prefs.getString('token');

//       if (userToken == null) {
//         print('Authentication token not found in SharedPreferences');
//         return [];
//       }

//       final apiUrl =
//           Uri.parse('$baseURL/student/classes/enrolledclasses/userclass');

//       final response = await http.get(
//         apiUrl,
//         headers: {
//           'Authorization': 'Bearer $userToken',
//         },
//       );

//       if (response.statusCode == 200) {
//         final dynamic responseData = json.decode(response.body);
//         if (responseData is Map &&
//             responseData.containsKey('enrolled_classes')) {
//           final List<dynamic> enrolledClasses =
//               responseData['enrolled_classes'];

//           final List<String> enrolledSubjectNames = [];
//           for (final enrolledClass in enrolledClasses) {
//             if (enrolledClass is Map && enrolledClass.containsKey('classes')) {
//               final List<dynamic> classes = enrolledClass['classes'];
//               for (final classData in classes) {
//                 if (classData is Map && classData.containsKey('class_name')) {
//                   final className = classData['class_name'] as String;
//                   final classId = classData['id'] as int;
//                   print('Enrolled Class Name: $className,Class ID: $classId');
//                   enrolledSubjectNames.add(className);
//                   fetchVideos(className, classId);
//                 }
//               }
//             }
//           }

//           return enrolledSubjectNames;
//         }
//       }

//       return [];
//     } catch (e) {
//       print('Failed to fetch enrolled subject names: $e');
//       return [];
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CupertinoPageScaffold(
//       backgroundColor: config.Colorss().secondColor(1),
//       child: Stack(
//         alignment: Alignment.center,
//         children: <Widget>[
//           SafeArea(
//             child: CustomScrollView(
//               slivers: <Widget>[
//                 SliverFixedExtentList(
//                   delegate: SliverChildListDelegate.fixed([Container()]),
//                   itemExtent: MediaQuery.of(context).size.height * 0.22,
//                 ),
//                 for (final className in enrolledSubjectNames)
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
//                             child: videosMap[className] != null
//                                 ? VideoList(
//                                     videos: videosMap[className]!,
//                                   )
//                                 : LoadingVideoShimmer(), // Show shimmer while loading
//                           ),
//                         if (!videosMap.containsKey(className))
//                           Container(
//                             alignment: Alignment.center,
//                             child: Text("Loading..."),
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
//               userName: widget.user.name,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class LoadingVideoShimmer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: 245,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: 4,
//         itemBuilder: (context, index) {
//           return VideoCardShimmer();
//         },
//       ),
//     );
//   }
// }

// class VideoCardShimmer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey[300]!,
//       highlightColor: Colors.grey[100]!,
//       child: Container(
//         margin: EdgeInsets.all(8.0),
//         width: 150,
//         height: 200,
//         color: Colors.grey[200],
//       ),
//     );
//   }
// }

// class VideoList extends StatelessWidget {
//   final List<Video> videos;

//   VideoList({required this.videos});

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       scrollDirection: Axis.horizontal,
//       itemCount: videos.length,
//       itemBuilder: (context, index) {
//         final video = videos[index];
//         return VideoCardclass(
//           long: false,
//           title: video.videoSubject,
//           videoDate: video.videoDate,
//           videoSubject: "ClassName", // Update with the actual class name
//         );
//       },
//     );
//   }
// }

// class VideoCardclass extends StatelessWidget {
//   final bool long;
//   final String title;
//   final String videoDate;
//   final String videoSubject;

//   VideoCardclass({
//     required this.long,
//     required this.title,
//     required this.videoDate,
//     required this.videoSubject,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.all(8.0),
//       width: 150,
//       height: 200,
//       color: Colors.black,
//       // Your video card UI here
//     );
//   }
// }
import 'dart:convert';
import 'package:elearning/services/api.dart';
import 'package:elearning/services/user_details_api_client.dart';
import 'package:elearning/theme/config.dart' as config;
import 'package:elearning/ui/pages/navmenu/menu_dashboard_layout.dart';
import 'package:elearning/ui/widgets/sectionHeader.dart';
import 'package:elearning/ui/widgets/topBar.dart';
import 'package:elearning/ui/widgets/videoCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: EdgeInsets.all(8.0),
        width: 150,
        height: 200,
        color: Colors.grey[200],
      ),
    );
  }
}

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
  List<String> enrolledSubjectNames = [];
  Map<String, List<Video>> videosMap = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEnrolledSubjectNames().then((names) {
      setState(() {
        enrolledSubjectNames = names;
        isLoading = false; // Set loading to false when data is loaded
      });
    });
  }

  Future<void> fetchVideos(String className, int classId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userToken = prefs.getString('token');

      if (userToken == null) {
        print('Authentication token not found in SharedPreferences');
        return;
      }

      final apiUrlVideos =
          Uri.parse('$baseURL/student/classes/$classId/videos');

      final responseVideos = await http.get(
        apiUrlVideos,
        headers: {
          'Authorization': 'Bearer $userToken',
        },
      );

      if (responseVideos.statusCode == 200) {
        final dynamic responseDataVideos = json.decode(responseVideos.body);
        if (responseDataVideos is Map &&
            responseDataVideos.containsKey('videos')) {
          final List<dynamic> videoData = responseDataVideos['videos'];

          final List<Video> videos = videoData.map((videoJson) {
            return Video.fromJson(videoJson);
          }).toList();

          print('Class Name: $className, Class ID: $classId');
          for (final video in videos) {
            print(
                'Video Name: ${video.videoSubject}, Video ID: ${video.id}, Class ID: $classId');
          }

          setState(() {
            videosMap[className] = videos;
          });
        }
      }
    } catch (e) {
      print('Failed to fetch videos for class $className: $e');
    }
  }

  Future<List<String>> fetchEnrolledSubjectNames() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userToken = prefs.getString('token');

      if (userToken == null) {
        print('Authentication token not found in SharedPreferences');
        return [];
      }

      final apiUrl =
          Uri.parse('$baseURL/student/classes/enrolledclasses/userclass');

      final response = await http.get(
        apiUrl,
        headers: {
          'Authorization': 'Bearer $userToken',
        },
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        if (responseData is Map &&
            responseData.containsKey('enrolled_classes')) {
          final List<dynamic> enrolledClasses =
              responseData['enrolled_classes'];

          final List<String> enrolledSubjectNames = [];
          for (final enrolledClass in enrolledClasses) {
            if (enrolledClass is Map && enrolledClass.containsKey('classes')) {
              final List<dynamic> classes = enrolledClass['classes'];
              for (final classData in classes) {
                if (classData is Map && classData.containsKey('class_name')) {
                  final className = classData['class_name'] as String;
                  final classId = classData['id'] as int;
                  print('Enrolled Class Name: $className,Class ID: $classId');
                  enrolledSubjectNames.add(className);
                  fetchVideos(className, classId);
                }
              }
            }
          }

          return enrolledSubjectNames;
        }
      }

      return [];
    } catch (e) {
      print('Failed to fetch enrolled subject names: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: config.Colorss().secondColor(1),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          if (isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LoadingDashboard(),
            ),
          SafeArea(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverFixedExtentList(
                  delegate: SliverChildListDelegate.fixed([Container()]),
                  itemExtent: MediaQuery.of(context).size.height * 0.22,
                ),
                for (final className in enrolledSubjectNames)
                  SliverToBoxAdapter(
                    child: Column(
                      children: <Widget>[
                        SectionHeader(
                          text: 'Best of $className',
                          onPressed: () {},
                        ),
                        if (videosMap.containsKey(className) &&
                            videosMap[className]!.isNotEmpty)
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
                        if (videosMap.containsKey(className) &&
                            videosMap[className]!.isEmpty)
                          Container(
                            alignment: Alignment.center,
                            child: Text("No videos found for this class."),
                          ),
                        if (!videosMap.containsKey(className))
                          Container(
                            alignment: Alignment.center,
                            child: LoadingWidget(),
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
