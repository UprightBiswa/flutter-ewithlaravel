import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:permission_handler/permission_handler.dart';

class PDFScreen extends StatefulWidget {
  final String? path;

  PDFScreen({Key? key, this.path}) : super(key: key);

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    // Request storage permission
    var status = await Permission.storage.request();
    if (status.isGranted) {
      print('Permission granted');
    } else {
      print('Permission denied');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF View'),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () {
              _downloadPDF(context, widget.path);
              print('Downloading PDF: ${widget.path}');
            },
          ),
        ],
      ),
      body: PDFView(
        filePath: widget.path,
        enableSwipe: true,
        swipeHorizontal: false,
        autoSpacing: false,
        pageFling: true,
        pageSnap: true,
        fitPolicy: FitPolicy.BOTH,
        preventLinkNavigation: false,
        onRender: (_pages) {},
        onError: (error) {
          print(error.toString());
        },
        onPageError: (page, error) {
          print('$page: ${error.toString()}');
        },
        onViewCreated: (PDFViewController pdfViewController) {},
        onLinkHandler: (String? uri) {
          print('goto uri: $uri');
        },
        onPageChanged: (int? page, int? total) {
          print('page change: $page/$total');
        },
      ),
    );
  }

  Future<void> _downloadPDF(BuildContext context, String? pdfPath) async {
    try {
      final file = File(pdfPath!);
      final directory = await path.getDownloadsDirectory();

      // Create a 'flutter/pdf_notes' directory if it doesn't exist
      final pdfNotesDirectory =
          Directory('${directory!.path}/flutter/pdf_notes');
      if (!pdfNotesDirectory.existsSync()) {
        pdfNotesDirectory.createSync(recursive: true);
      }

      // Copy the file to the 'flutter/pdf_notes' directory with the original name
      final newFile = await file
          .copy('${pdfNotesDirectory.path}/${file.uri.pathSegments.last}');
      print('Downloading PDF: ${newFile.path}');

      // Display a success message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('PDF Downloaded'),
          content: Text('The PDF has been downloaded to ${newFile.path}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    } catch (e) {
      // Handle download errors
      print('Error downloading PDF: $e');
    }
  }
}
