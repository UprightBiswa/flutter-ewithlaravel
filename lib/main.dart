// import 'package:elearning/ui/pages/login.dart';
// import 'package:elearning/ui/pages/navmenu/menu_dashboard_layout.dart';
// import 'package:elearning/ui/pages/onboarding1.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'package:shared_preferences/shared_preferences.dart';

// late SharedPreferences prefs;
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SharedPreferences prefs = await SharedPreferences.getInstance();

//   bool showOnboarding = prefs.getBool('showOnboarding') ?? true;

//   if (showOnboarding) {
//     await prefs.setBool('showOnboarding', false);
//   }

//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
//       .then((value) => runApp(
//             RestartWidget(
//               child: MyApp(showOnboarding: showOnboarding),
//             ),
//           ));
// }

// class MyApp extends StatelessWidget {
//   final bool showOnboarding;

//   MyApp({required this.showOnboarding});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
      
//       debugShowCheckedModeBanner: false,
//       home: FutureBuilder<String>(
//         future: SharedPreferences.getInstance().then((prefs) {
//           return prefs.getString('token') ?? ''; // Get the stored token
//         }),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             // Future is still loading
//             return CupertinoActivityIndicator();
//           } else {
//             // Future has completed
//             final token = snapshot.data ?? '';

//             // Based on the token, decide which screen to show
//             if (token.isNotEmpty) {
//               // User is logged in, show MenuDashboardLayout
//               return MenuDashboardLayout(userToken: token);
//             } else {
//               // User is not logged in, show LoginPage
//               return showOnboarding ? Onboarding() : LoginPage();
//             }
//           }
//         },
//       ),
//     );
//   }
// }

// class RestartWidget extends StatefulWidget {
//   RestartWidget({this.child});

//   final Widget? child;

//   static void restartApp(BuildContext context) {
//     context.findAncestorStateOfType<_RestartWidgetState>()!.restartApp();
//   }

//   @override
//   _RestartWidgetState createState() => _RestartWidgetState();
// }

// class _RestartWidgetState extends State<RestartWidget> {
//   Key key = UniqueKey();

//   void restartApp() {
//     setState(() {
//       key = UniqueKey();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return KeyedSubtree(
//       key: key,
//       child: widget.child!,
//     );
//   }
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';


import 'app/controllers/theme_controller.dart';
import 'app/data/constants/constants.dart';
import 'app/data/helpers/theme_helper.dart';
import 'app/modules/splash_screens/splash_screens.dart';
import 'app/provider/common_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
   SystemChrome.setSystemUIOverlayStyle(defaultOverlay);
    await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
 runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({superKey, });

   @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    debugPrint(themeController.theme);
    return MultiProvider(
      providers: [
        CommonProviders.connectionProvider(),
        CommonProviders.authStateProvider(),
        CommonProviders.loginProvider(),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 844),
        minTextAdapt: true,
        useInheritedMediaQuery: true,
        builder: (context, child) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: GetMaterialApp(
              title: 'Field Asistence',
              debugShowCheckedModeBanner: false,
              useInheritedMediaQuery: true,
              scrollBehavior: const ScrollBehavior()
                  .copyWith(physics: const BouncingScrollPhysics()),
              defaultTransition: Transition.fadeIn,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: getThemeMode(themeController.theme),
              home: const SplashScreen(),
            ),
          );
        },
      ),
    );
  }
}
