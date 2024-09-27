// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class VideoView extends StatefulWidget {
//   final String? path;
//   final dynamic video;

//   const VideoView({Key? key, this.path, required this.video}) : super(key: key);

//   @override
//   _VideoViewState createState() => _VideoViewState();
// }

// class _VideoViewState extends State<VideoView> {
//   late VideoPlayerController _controller;
//   late Future<void> _initializeVideoPlayerFuture;

//   @override
//   void initState() {
//     super.initState();

//     // Initialize the VideoPlayerController with the provided video URL
//     _controller = VideoPlayerController.networkUrl(Uri.parse(widget.path ?? ''));
//     _initializeVideoPlayerFuture = _controller.initialize();

//     // Ensure the first frame is shown after the video is initialized
//     _controller.setLooping(true);
//   }

//   @override
//   void dispose() {
//     // Dispose of the VideoPlayerController when the widget is disposed
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title:  Text(widget.video['video_subject']),
//       ),
//       body: Center(
//         child: FutureBuilder(
//           future: _initializeVideoPlayerFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.done) {
//               // If the VideoPlayerController has finished initialization, use it to display the video
//               return AspectRatio(
//                 aspectRatio: _controller.value.aspectRatio,
//                 child: VideoPlayer(_controller),
//               );
//             } else {
//               // If the VideoPlayerController is still initializing, show a loading spinner
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Play or pause the video when the FloatingActionButton is pressed
//           setState(() {
//             if (_controller.value.isPlaying) {
//               _controller.pause();
//             } else {
//               _controller.play();
//             }
//           });
//         },
//         child: Icon(
//           _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  final String? path;
  final dynamic video;

  const VideoView({Key? key, this.path, required this.video}) : super(key: key);

  @override
  _VideoViewState createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    // Initialize the VideoPlayerController with the provided video URL
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.path ?? ''));
    // VideoPlayerController.networkUrl(
    //     Uri.parse(widget.video["video_file"] ?? ''));
    _initializeVideoPlayerFuture = _controller.initialize();

    // Ensure the first frame is shown after the video is initialized
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    // Dispose of the VideoPlayerController when the widget is disposed
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoTheme.brightnessOf(context) == Brightness.light
          ? CupertinoColors.systemBlue.highContrastColor
          : CupertinoColors.systemGrey,
      appBar: AppBar(
        title: Text(widget.video['video_subject']),
      ),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the VideoPlayerController has finished initialization, use it to display the video
                  return AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  );
                } else {
                  // If the VideoPlayerController is still initializing, show a loading spinner
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          // Video progress bar
          VideoProgressIndicator(
            _controller,
            allowScrubbing: true,
            padding: EdgeInsets.symmetric(vertical: 8),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                onPressed: () {
                  // Play or pause the video when the FloatingActionButton is pressed
                  setState(() {
                    if (_controller.value.isPlaying) {
                      _controller.pause();
                    } else {
                      _controller.play();
                    }
                  });
                },
                child: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
              ),
              MaterialButton(
                onPressed: () {
                  // Skip the video by 10 seconds
                  _controller.seekTo(
                      _controller.value.position + Duration(seconds: 10));
                },
                child: Icon(Icons.skip_next),
              ),
              MaterialButton(
                onPressed: () {
                  // Full-screen functionality
                  _controller.play();
                  _showFullScreenDialog();
                },
                child: Icon(Icons.fullscreen),
              ),
            ],
          ),

          SizedBox(height: 16),
          // Video details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Subject: ${widget.video["video_subject"]}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text("Date: ${widget.video["video_date"]}"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Show full-screen dialog
  void _showFullScreenDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.video['video_subject']),
          ),
          body: RotatedBox(
            quarterTurns: 1, // Rotate 90 degrees (1 quarter turn)
            child: AspectRatio(
              aspectRatio: 16 / 9, // Set the aspect ratio to 9:16
              child: VideoPlayer(_controller),
            ),
          ),
        );
      },
    ).then((_) {
      // Resume video when exiting full screen
      _controller.play();
    });
  }
}
