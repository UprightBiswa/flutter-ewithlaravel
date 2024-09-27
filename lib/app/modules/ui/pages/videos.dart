import 'dart:convert';
import 'package:elearning/app/data/helpers/databasehelper/detabasehelper.dart';
import 'package:elearning/app/services/user_details_api_client.dart';
import 'package:elearning/app/controllers/theme/config.dart' as config;
import 'package:elearning/app/modules/ui/pages/navmenu/menu_dashboard_layout.dart';
import 'package:elearning/app/modules/ui/widgets/sectionHeader.dart';
import 'package:elearning/app/modules/ui/widgets/topBar.dart';
import 'package:elearning/app/modules/ui/widgets/videoCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

import '../../../data/constants/api_base_url.dart';

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
  // Add toJson method if needed
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'video_subject': videoSubject,
      'video_date': videoDate,
      'video_file': videoFile,
      'class_id': classId,
      'created_at': createdAt,
    };
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
      final dbHelper = DatabaseHelper();
      await dbHelper.initialize();
// Now you can use other methods like insertVideos, getVideosByClass, etc.

      final prefs = await SharedPreferences.getInstance();
      final userToken = prefs.getString('token');

      if (userToken == null) {
        print('Authentication token not found in SharedPreferences');
        return;
      }

      final apiUrlVideos =
          Uri.parse('${BaseURL.baseUrl}student/classes/$classId/videos');

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
          // Save videos to the local database
          await DatabaseHelper().insertVideos(className, videos);
          if (mounted) {
            setState(() {
              videosMap[className] = videos;
            });
          }
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
          Uri.parse('${BaseURL.baseUrl}student/classes/enrolledclasses/userclass');

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
