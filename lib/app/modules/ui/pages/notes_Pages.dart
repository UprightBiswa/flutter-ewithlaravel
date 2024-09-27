// import 'package:elearning/ui/pages/pdfviewrpage.dart';
// import 'package:elearning/ui/widgets/customlisttile.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';

// class ClassNotesPage extends StatelessWidget {
//   final List<dynamic> notes;

//   ClassNotesPage({required this.notes});

//   @override
//   Widget build(BuildContext context) {
//     // Log the data before returning the Scaffold
//     print('Notes Data: $notes');
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Class Notes'),
//       ),
//       body: ListView.builder(
//         itemCount: notes.length,
//         itemBuilder: (context, index) {
//           final note = notes[index];
//           return Column(
//             children: [
//               SizedBox(height: 10),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: CustomListTile(
//                   serialNumber: index + 1,
//                   title: note['note_subject'],
//                   onPressed: () {
//                     _openPdfView(context, note['note_file'], note['note_subject']);
//                     print('Downloading PDF: ${note['note_file']}');
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   void _openPdfView(BuildContext context, String? pdfFileUrl, String? title) async {
//     // Download the PDF file
//     final response = await http.get(Uri.parse(pdfFileUrl!));

//     if (response.statusCode == 200) {
//       // Save the PDF file to the device
//       final dir = await getTemporaryDirectory();
//       final file = File('${dir.path}/$title.pdf');
//       await file.writeAsBytes(response.bodyBytes);

//       // Open the PDF file using PDFScreen widget
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => PDFScreen(path: file.path),
//         ),
//       );
//     } else {
//       // Handle the case where the PDF file couldn't be downloaded
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text('Error'),
//             content: Text('Failed to download the PDF file.'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: Text('OK'),
//               ),
//             ],
//           );
//         },
//       );
//     }
//   }
// }
import 'package:elearning/app/modules/ui/pages/pdfviewrpage.dart';
import 'package:elearning/app/modules/ui/widgets/customlisttile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ClassNotesPage extends StatelessWidget {
  final List<dynamic> notes;

  ClassNotesPage({required this.notes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.purple[600],
        title: Text('Class Notes'),
      ),
      backgroundColor: Colors.purple[50],
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return Column(
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: CustomListTile(
                  serialNumber: index + 1,
                  title: note['note_subject'],
                  onPressed: () {
                    _openPdfView(
                        context, note['note_file'], note['note_subject']);
                    print('Downloading PDF: ${note['note_file']}');
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _openPdfView(
      BuildContext context, String? pdfFileUrl, String? title) async {
    showDialog(
      context: context,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      // Download the PDF file
      final response = await http.get(Uri.parse(pdfFileUrl!));

      if (response.statusCode == 200) {
        // Save the PDF file to the device
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/$title.pdf');
        await file.writeAsBytes(response.bodyBytes);

        // Close the loading dialog
        Navigator.pop(context);

        // Open the PDF file using PDFScreen widget
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PDFScreen(path: file.path),
          ),
        );
      } else {
        // Close the loading dialog
        Navigator.pop(context);

        // Handle the case where the PDF file couldn't be downloaded
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Failed to download the PDF file.'),
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
    } catch (error) {
      // Close the loading dialog
      Navigator.pop(context);

      // Handle any other errors that might occur during the process
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred: $error'),
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
