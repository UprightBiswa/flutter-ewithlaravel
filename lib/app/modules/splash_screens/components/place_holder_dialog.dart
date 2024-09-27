import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlaceholderDialog extends StatelessWidget {
  const PlaceholderDialog({
    this.image,
    this.title,
    this.message,
    this.actions = const [],
    Key? key,
  }) : super(key: key);

  final Image? image; // Change from Widget to Image
  final String? title;
  final String? message;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      contentPadding: EdgeInsets.zero, // Remove default padding
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 8.h,
          ),
          if (image != null) image!, // Show image if provided
          if (title != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                title!,
                textAlign: TextAlign.center,
              ),
            ),
          if (message != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                message!,
                textAlign: TextAlign.center,
              ),
            ),
          if (actions.isNotEmpty)
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: actions,
            ),
        ],
      ),
    );
  }
}
