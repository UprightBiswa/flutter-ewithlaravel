// ClassVideosPage.dart
import 'dart:io';

import 'package:elearning/app/modules/ui/pages/videoviewrpage.dart';
import 'package:elearning/app/modules/ui/widgets/customlisttile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ClassVideosPage extends StatelessWidget {
  final List<dynamic> videos;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ClassVideosPage({required this.videos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.purple[600],
        title: Text('Class Videos'),
      ),
      backgroundColor: Colors.purple[50],
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return Column(
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: CustomListTile(
                  serialNumber: index + 1,
                  title: video['video_subject'],
                  onPressed: () {
                    _openVideoView(context, video, video['video_file'],
                        video['video_subject']);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _openVideoView(BuildContext context, dynamic video, String videoFileUrl,
      String videoTitle) async {
    showDialog(
      context: _scaffoldKey.currentState?.context ?? context,
      barrierDismissible: false, // Prevents the user from dismissing the dialog
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 10),
              Text('Downloading Video...'),
            ],
          ),
        );
      },
    );

    try {
      // Download the VIDEO file
      final response = await http.get(Uri.parse(videoFileUrl));

      if (response.statusCode == 200) {
        // Save the VIDEO file to the device
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/$videoTitle.mp4');
        await file.writeAsBytes(response.bodyBytes);

        // Close the loading dialog
        Navigator.pop(context);
        // Log the path
        print('Video downloaded to: $file');

        // Open the VIDEO file using VideoView widget
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoView(
              path: file.path,
              video: video,
            ),
          ),
        );
      } else {
        // Close the loading dialog
        Navigator.pop(context);

        // Handle the case where the VIDEO file couldn't be downloaded
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to download the video file.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Close the loading dialog
      Navigator.pop(context);

      // Handle any other exceptions that might occur during the download
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
