import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final int serialNumber;
  final String title;
  final VoidCallback? onPressed;

  const CustomListTile({
    Key? key,
    required this.serialNumber,
    required this.title,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[300],
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: CircleAvatar(child: Text(serialNumber.toString())),
        title: Text(
          title,
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
        trailing: IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
