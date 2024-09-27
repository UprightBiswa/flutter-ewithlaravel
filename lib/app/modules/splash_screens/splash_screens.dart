import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/constants/constants.dart';
import '../../model/user_model.dart';
import '../../provider/connction_provider/connectivity_provider.dart';
import '../../provider/login_provider/auth_token.dart';
import '../../provider/login_provider/login_provider.dart';
import '../auth/login.dart';
import '../ui/pages/navmenu/menu_dashboard_layout.dart';
import '../ui/pages/onboarding1.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

void showToast(String message, BuildContext context) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoAnimation;

  late LoginProvider loginProvider;
  User? userDetails;
  late ConnectivityProvider connectivityProvider;

  @override
  void initState() {
    super.initState();
    connectivityProvider =
        Provider.of<ConnectivityProvider>(context, listen: false);
    loginProvider = Provider.of<LoginProvider>(context, listen: false);
    getUserInfo();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _logoAnimation = Tween<double>(begin: -150, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.forward().whenComplete(
      () async {
        bool isFirstLaunch = await checkFirstLaunch();
        if (isFirstLaunch) {
          Navigator.pushReplacement(
            // ignore: duplicate_ignore
            context,
            MaterialPageRoute(builder: (context) => const Onboarding()),
          );
        } else {
          navigateBasedOnLoginStatus();
        }
      },
    ).catchError((error) {
      print('Error checking first launch: $error');
      // Handle error if necessary
    });
  }

  Future<void> getUserInfo() async {
    try {
      String? accessToken = AuthState().accessToken;
      if (accessToken != null) {
        await loginProvider.fetchUserDetails(accessToken, context);
        setState(() async {
          userDetails = loginProvider.userDetails;
        });
        if (kDebugMode) {
          print('User details: $userDetails');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      setState(() {
        userDetails = null;
      });
    }
  }

  void navigateBasedOnLoginStatus() async {
    bool isLoggedIn = AuthState().accessToken != null;
    if (userDetails != null && isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          // builder: (context) => LandingPage(userDetails: userDetails!),
          builder: (context) =>
              MenuDashboardLayout(userToken: AuthState().accessToken!),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  Future<bool> checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('firstLaunch') ?? true;
    if (isFirstLaunch) {
      prefs.setBool('firstLaunch', false);
    }
    return isFirstLaunch;
  }

// Initialize the provider here
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loginProvider = Provider.of<LoginProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    connectivityProvider = Provider.of<ConnectivityProvider>(context);
    bool isDarkMode(BuildContext context) =>
        Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
          isDarkMode(context) ? AppColors.kDarkBackground : AppColors.kPrimary,
      appBar: AppBar(
        backgroundColor: isDarkMode(context)
            ? AppColors.kDarkBackground
            : AppColors.kPrimary,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: AnimatedBuilder(
                animation: _logoAnimation,
                builder: (context, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.translate(
                        offset: Offset(0, _logoAnimation.value),
                        child: Column(
                          children: [
                            Image.asset(
                              AppAssets.kLogo,
                              fit: BoxFit.contain,
                              width: 100,
                              height: 100,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'e-Learning App',
                              style: AppTypography.kBold12.copyWith(
                                color: isDarkMode(context)
                                    ? AppColors.kWhite
                                    : AppColors.kDarkBackground,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Learn, Practice, and Excel',
                              style: AppTypography.kMedium10.copyWith(
                                color: isDarkMode(context)
                                    ? AppColors.kWhite
                                    : AppColors.kDarkBackground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isDarkMode(context)
              ? AppColors.kDarkBackground
              : AppColors.kPrimary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Powered by:', style: AppTypography.kMedium14),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
