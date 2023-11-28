// import 'package:elearning/main.dart';
import 'package:elearning/services/user_details_api_client.dart';
import 'package:elearning/theme/config.dart';
import 'package:elearning/ui/widgets/overlay.dart';
import 'package:elearning/theme/box_icons_icons.dart';
// import 'package:elearning/theme/config.dart';
import 'package:elearning/ui/pages/leaderboard.dart';
import 'package:elearning/ui/pages/planner.dart';
import 'package:elearning/ui/pages/videos.dart';
import 'package:elearning/ui/widgets/sectionHeader.dart';
import 'package:elearning/ui/widgets/topBar.dart';
import 'package:elearning/ui/widgets/videoCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final onMenuTap;
  final User user; // Received user details
  Home({required this.onMenuTap, required this.user});
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int tabNo = 0;
  late bool overlayVisible;
  CupertinoTabController? controller;
  @override
  void initState() {
    overlayVisible = false;
    controller = CupertinoTabController(initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        CupertinoTabScaffold(
          backgroundColor: Colorss().secondColor(1),
          // backgroundColor:
          //     Colors.blue, // Example, replace with the desired color

          controller: controller,
          tabBar: CupertinoTabBar(
            onTap: (value) {
              setState(() {
                tabNo = value;
              });
            },
            activeColor: material.Colors.lightBlue,
            inactiveColor: Color(0xFFADADAD),
            items: [
              BottomNavigationBarItem(
                  icon: Icon(BoxIcons.bx_home_circle),
                  label: tabNo == 0 ? "Home" : null),
              BottomNavigationBarItem(
                  icon: Icon(BoxIcons.bx_calendar),
                  label: tabNo == 1 ? "Planner" : null),
              BottomNavigationBarItem(icon: Container()),
              BottomNavigationBarItem(
                  icon: Icon(BoxIcons.bxs_videos),
                  label: tabNo == 3 ? "Videos" : null),
              BottomNavigationBarItem(
                  icon: Icon(BoxIcons.bx_stats),
                  label: tabNo == 4 ? "Leaderboard" : null),
            ],
          ),
          tabBuilder: (context, index) => (index == 0)
              ? HomePage(
                  onMenuTap: widget.onMenuTap,
                  user: widget.user, // Pass the user object
                )
              : (index == 1)
                  ? PlannerPage(
                      onMenuTap: widget.onMenuTap,
                      user: widget.user, // Pass the user object
                    )
                  : (index == 2)
                      ? Container(
                          color: CupertinoColors.activeOrange,
                        )
                      : (index == 3)
                          ? VideosPage(
                              onMenuTap: widget.onMenuTap,
                              user: widget.user, // Pass the user object
                            )
                          : LeaderboardPage(
                              onMenuTap: widget.onMenuTap,
                              user: widget.user, // Pass the user object
                            ),
        ),
        Positioned(
            bottom: 0,
            child: GestureDetector(
              child: SizedBox(
                height: 60,
                width: 80,
                child: Text(""),
              ),
              onTap: () {},
            )),
        overlayVisible ? OverlayWidget() : Container(),
        Positioned(
            bottom: 20,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFABDCFF),
                      Color(0xFF0396FF),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 25,
                        color: Color(0xFF03A9F4).withOpacity(0.4),
                        offset: Offset(0, 4))
                  ],
                  borderRadius: BorderRadius.circular(500)),
              child: material.FloatingActionButton(
                  elevation: 0,
                  highlightElevation: 0,
                  backgroundColor: material.Colors.transparent,
                  child: overlayVisible
                      ? Icon(material.Icons.close)
                      : Icon(BoxIcons.bx_pencil),
                  onPressed: () {
                    setState(() {
                      overlayVisible = !overlayVisible;
                    });
                  }),
            )),
      ],
    );
  }
}

class HomePage extends StatefulWidget {
  final onMenuTap;
  final User user; // Receive the user object
  HomePage({Key? key, required this.onMenuTap, required this.user})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController();
  // final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  //     GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return CupertinoPageScaffold(
      backgroundColor: CupertinoTheme.brightnessOf(context) == Brightness.dark
          ? CupertinoColors.systemCyan.highContrastColor
          : CupertinoColors.white,

      // backgroundColor: Colors.blue, // Example, replace with the desired color

      child: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SafeArea(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverFixedExtentList(
                    delegate: SliverChildListDelegate.fixed([Container()]),
                    itemExtent: screenHeight * 0.43,
                  ),
                  SliverToBoxAdapter(
                    child: SectionHeader(
                      text: 'Recommended Lectures',
                      onPressed: () {},
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 245,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 1,
                        itemBuilder: (context, index) {
                          return VideoCard(long: false);
                        },
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SectionHeader(
                      text: 'Revision Lectures',
                      onPressed: () {},
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 245,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return VideoCard(long: false);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 0,
              child: TopBar(
                controller: controller,
                expanded: true,
                onMenuTap: widget.onMenuTap,
                userName: widget.user.name, // Provide the user's name here
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future<void> _refreshData() async {
  //   await Future.delayed(Duration(seconds: 2));
  //   // Trigger a rebuild of the UI only if this page is the topmost route
  //   if (ModalRoute.of(context)?.isCurrent == true) {
  //     setState(() {});
  //   }
  //   // Restart the app using RestartWidget
  //   RestartWidget.restartApp(context);
  // }
}
