import 'dart:convert';
import 'dart:math';
import 'package:elearning/services/api.dart';
import 'package:elearning/theme/box_icons_icons.dart';
import 'package:elearning/ui/widgets/card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TopBar extends StatefulWidget {
  const TopBar({
    Key? key,
    required this.controller,
    required this.expanded,
    required this.onMenuTap,
    required this.userName,
  }) : super(key: key);

  final TextEditingController controller;
  final bool expanded;
  final onMenuTap;
  final String userName;

  @override
  _TopBarState createState() => _TopBarState();
}

final List<IconData> courseIcons = [
  BoxIcons.bx_book,
  BoxIcons.bx_globe,
  BoxIcons.bx_polygon,
  // Add more icons as needed
];

final List<Color> courseColors = [
  Colors.red,
  Colors.blue,
  Colors.green,
  // Add more colors as needed
];

IconData getRandomIcon(int index) {
  final random = Random();
  return courseIcons[random.nextInt(courseIcons.length)];
}

Color getRandomColor(int index) {
  final random = Random();
  return courseColors[random.nextInt(courseColors.length)];
}

class _TopBarState extends State<TopBar> {
  int tab = 0;
  List<dynamic> courseData = []; // Initialize the course data list

  @override
  void initState() {
    super.initState();
    // Fetch course data when the widget is initialized
    fetchDataFromAPI();
  }

  Future<void> fetchDataFromAPI() async {
    try {
      // Retrieve the token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userToken = prefs.getString('token');

      if (userToken == null) {
        // Handle the case where the token is not available in SharedPreferences
        print('Authentication token not found in SharedPreferences');
        return;
      }

      // Replace with your API endpoint
      // final apiUrl = Uri.parse('http://192.168.29.48/api/student/courses');

      final apiUrl = Uri.parse('$baseURL/student/courses');

      final response = await http.get(
        apiUrl,
        headers: {
          'Authorization': 'Bearer $userToken', // Replace with your token
        },
      );

      if (response.statusCode == 200) {
        final contentType = response.headers['content-type'];
        if (contentType != null && contentType.contains('application/json')) {
          final dynamic responseData = json.decode(response.body);

          if (responseData is Map && responseData.containsKey('courses')) {
            // Process the list of courses
            setState(() {
              courseData = responseData['courses'];
            });
          } else {
            // Handle the case where 'courses' key is not found in the response
            print('No "courses" key found in the response.');
          }
        } else {
          // Handle the case where the response is not JSON
          print('Response does not contain JSON data');
        }
      } else {
        // Handle the case where the response status code is not 200
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle anyother exceptions that may occur during the request
      print('Failed to fetch data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.white,
      width: MediaQuery.of(context).size.width,
      height: widget.expanded
          ? MediaQuery.of(context).size.height * 0.36
          : MediaQuery.of(context).size.height * 0.19,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "Hi, ${widget.userName}.",
                    style: TextStyle(
                      color: Color(0xFF343434),
                      fontSize: 24,
                      fontFamily: 'Red Hat Display',
                      fontWeight: material.FontWeight.w600,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: GestureDetector(
                    child: material.CircleAvatar(
                      backgroundImage: AssetImage('assets/images/user.png'),
                    ),
                    onTap: widget.onMenuTap,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: CupertinoTextField(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: material.Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 25,
                    offset: Offset(0, 10),
                    color: Color(0x1A636363),
                  ),
                ],
              ),
              padding: EdgeInsets.all(10),
              style: TextStyle(
                color: Color(0xFF343434),
                fontSize: 18,
                fontFamily: 'Red Hat Display',
              ),
              enableInteractiveSelection: true,
              controller: widget.controller,
              expands: false,
              inputFormatters: [
                FilteringTextInputFormatter.singleLineFormatter
              ],
              keyboardType: TextInputType.text,
              suffix: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  BoxIcons.bx_search,
                  color: Color(0xFFADADAD),
                ),
              ),
              textInputAction: TextInputAction.search,
              textCapitalization: TextCapitalization.words,
              placeholder: "Search",
              placeholderStyle: TextStyle(
                color: Color(0xFFADADAD),
                fontSize: 18,
                fontFamily: 'Red Hat Display',
              ),
            ),
          ),
          widget.expanded
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.165,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: courseData.length,
                    itemBuilder: (context, index) {
                      final course = courseData[index];
                      final icon = getRandomIcon(index);
                      final color = getRandomColor(index);

                      return Padding(
                        padding: const EdgeInsets.fromLTRB(15, 15, 10, 30),
                        child: CardWidget(
                          gradient: false,
                          button: true,
                          duration: 200,
                          border: tab == index
                              ? Border(
                                  bottom: BorderSide(
                                    color: color,
                                    width: 5,
                                  ),
                                )
                              : null,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Icon(icon),
                                Text(course['course_name']),
                              ],
                            ),
                          ),
                          func: () {
                            setState(() {
                              tab = index;
                            });
                          },
                        ),
                      );
                    },
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
