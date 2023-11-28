import 'dart:async';

import 'package:elearning/main.dart';
import 'package:elearning/services/api.dart';
import 'package:elearning/services/user_details_api_client.dart';
import 'package:elearning/theme/config.dart' as config;
import 'package:elearning/ui/pages/home.dart';
import 'package:elearning/ui/widgets/sectionHeader.dart';
import 'package:flutter/material.dart';
import 'package:elearning/ui/pages/navmenu/dashboard.dart';
import 'package:shimmer/shimmer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'menu.dart';

final Color backgroundColor = Colors.lightBlue;

enum ScreenState { Loading, Loaded, Error, Empty }

class MenuDashboardLayout extends StatefulWidget {
  final String userToken; // Pass the user token to this screen
  MenuDashboardLayout({required this.userToken});
  @override
  _MenuDashboardLayoutState createState() => _MenuDashboardLayoutState();
}

// const String baseURL = "http://10.0.2.2:8000/api";

//  const String baseURL = "http://192.168.29.48/api";

class _MenuDashboardLayoutState extends State<MenuDashboardLayout>
    with SingleTickerProviderStateMixin {
  User? user; // Define the variable to hold user details
  bool isCollapsed = true;
  double? screenWidth, screenHeight;
  final Duration duration = const Duration(milliseconds: 100);
  late AnimationController _controller;
  Animation<double>? _scaleAnimation;
  Animation<double>? _menuScaleAnimation;
  Animation<Offset>? _slideAnimation;
  String userName = 'user'; // Add this variable
  ScreenState screenState = ScreenState.Loading; // Add this variable
  late Timer _periodicTimer;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    _scaleAnimation = Tween<double>(begin: 1, end: 0.75).animate(_controller);
    _menuScaleAnimation =
        Tween<double>(begin: 0.5, end: 1).animate(_controller);
    _slideAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0))
        .animate(_controller);
    _startPeriodicTimer();
    _fetchUserDetails();
  }

  void _startPeriodicTimer() {
    _periodicTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _checkInternetAndFetchUserDetails();
    });
  }

  Future<void> _checkInternetAndFetchUserDetails() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _setScreenState(ScreenState.Error);
      return;
    }

    //  _fetchUserDetails();
  }

  void _fetchUserDetails() async {
    try {
      final userDetails = await UserDetailsApiClient(baseUrl: baseURL)
          .getUserDetails(widget.userToken);
      if (userDetails.containsKey('user') && userDetails['user'] != null) {
        print('User JSON: ${userDetails['user']}');
        user =
            User.fromJson(userDetails['user']); // Assign fetched user details

        final newUser = User.fromJson(userDetails['user']);
        setState(() {
          user = newUser;
          userName = newUser.name; // Set the user name
        });
        _setScreenState(ScreenState.Loaded); // Set state to Loaded
      } else {
        print('User JSON is null or not present.');
        _setScreenState(ScreenState.Empty); // Set state to Empty
      }

      print('User Details Response: $userDetails'); // Log the response details

      // Print the entire userDetails map
      print('User Details Map: $userDetails');
    } catch (e) {
      print('Error fetching user details: $e');
      _setScreenState(ScreenState.Error); // Set state to Error
    }
  }

  void _setScreenState(ScreenState state) {
    setState(() {
      screenState = state;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _cancelPeriodicTimer();
    super.dispose();
  }

  void _cancelPeriodicTimer() {
    // Check if the timer is active before canceling
    if (_periodicTimer != null && _periodicTimer!.isActive) {
      _periodicTimer!.cancel();
    }
  }

  void onMenuTap() {
    setState(() {
      if (isCollapsed)
        _controller.forward();
      else
        _controller.reverse();

      isCollapsed = !isCollapsed;
    });
  }

  void onMenuItemClicked() {
    setState(() {
      _controller.reverse();
    });

    isCollapsed = !isCollapsed;
  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    screenHeight = size.height;
    screenWidth = size.width;
// Function to show exit confirmation dialog
    Future<bool> showExitPopup() async {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Exit App'),
              content: Text('Do you want to exit the app?'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('No'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Yes'),
                ),
              ],
            ),
          ) ??
          false;
    }

    return WillPopScope(
      onWillPop: showExitPopup,
      child: RestartWidget(
        child: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: _refreshData,
          child: Scaffold(
            backgroundColor: backgroundColor,
            body: Stack(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    gradient: config.Colorss().waves,
                  ),
                ),
                Menu(
                    onMenuTap: onMenuTap,
                    slideAnimation: _slideAnimation,
                    menuAnimation: _menuScaleAnimation,
                    onMenuItemClicked: onMenuItemClicked,
                    userName: userName),
                Dashboard(
                  duration: duration,
                  onMenuTap: onMenuTap,
                  scaleAnimation: _scaleAnimation,
                  isCollapsed: isCollapsed,
                  screenWidth: screenWidth,
                  child: _buildScreen(),
                  // child: user != null
                  //     ? Home(
                  //         onMenuTap: onMenuTap,
                  //         user: user!,
                  //       )
                  //     // : Center(
                  //     //     child: CircularProgressIndicator(),
                  //     //   ),
                  //     : LoadingDashboard(),
                  // child: Home(
                  //   onMenuTap: onMenuTap,
                  //   user: user ?? User.defaultUser(),
                  // ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScreen() {
    switch (screenState) {
      case ScreenState.Loading:
        return LoadingDashboard();
      case ScreenState.Loaded:
        return user != null
            ? Home(
                onMenuTap: onMenuTap,
                user: user!,
              )
            : LoadingDashboard();
      case ScreenState.Error:
        return _buildErrorScreen();
      case ScreenState.Empty:
        return Center(
          child: Text('No data found.'),
        );
      default:
        return Container();
    }
  }

  Widget _buildErrorScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'An unexpected error occurred.',
            style: TextStyle(color: Colors.red),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              // Check internet connectivity
              var connectivityResult = await Connectivity().checkConnectivity();
              if (connectivityResult == ConnectivityResult.none) {
                // If no internet, show message to turn on internet
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please turn on your internet connection.'),
                    duration: Duration(seconds: 3),
                  ),
                );
              } else {
                // If internet is available, retry fetching user details
                _checkInternetAndFetchUserDetails();
                _fetchUserDetails();
              }
            },
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshData() async {
    await Future.delayed(Duration(seconds: 2));
    // Trigger a rebuild of the UI only if this page is the topmost route
    if (ModalRoute.of(context)?.isCurrent == true) {
      setState(() {});
    }
    // Restart the app using RestartWidget
    RestartWidget.restartApp(context);
  }
}

class LoadingDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [Colors.grey[900]!, Colors.grey[500]!],
        //     begin: Alignment(-1, -1),
        //     end: Alignment(1, 1),
        //   ),
        // ),
        child: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SafeArea(
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverFixedExtentList(
                      delegate: SliverChildListDelegate.fixed([Container()]),
                      itemExtent: screenHeight * 0.36,
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
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            return VideoCardPlaceholder();
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
                            return VideoCardPlaceholder();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                child: TopBarr(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopBarr extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.36,
      color: Colors.grey[200],
      child: Card(
        color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: 16, top: 16, bottom: 16),
              child: Icon(
                Icons.face,
                size: 50,
                color: Colors.white,
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 16, top: 16, bottom: 16),
              child: Text(
                ".........",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 100,
                height: 40,
                margin: EdgeInsets.only(left: 8, top: 16, bottom: 16),
                alignment: FractionalOffset.bottomLeft,
                child: Text(
                  "........",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoCardPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      width: 150,
      height: 200,
      color: Colors.grey[200],
    );
  }
}
