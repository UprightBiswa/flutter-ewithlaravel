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
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.purple[300],
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          leading: CircleAvatar(
            child: Text(serialNumber.toString()),
            backgroundColor: Colors.purple[600],
          ),
          title: Text(
            title,
            style: TextStyle(fontSize: 14, color: Colors.black),
          ),
          trailing: Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
