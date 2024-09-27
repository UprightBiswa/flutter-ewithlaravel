import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'app/controllers/theme_controller.dart';
import 'app/data/constants/constants.dart';
import 'app/data/helpers/theme_helper.dart';
import 'app/modules/splash_screens/splash_screens.dart';
import 'app/modules/ui/pages/onboarding1.dart';
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
  const MyApp({superKey});

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
        designSize: const Size(375, 844), // Design size for your UI
        minTextAdapt: true,
        useInheritedMediaQuery: true,
        builder: (context, child) {
          return ResponsiveBreakpoints.builder(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: GetMaterialApp(
                title: 'Field Assistance',
                debugShowCheckedModeBanner: false,
                useInheritedMediaQuery: true,
                scrollBehavior: const ScrollBehavior()
                    .copyWith(physics: const BouncingScrollPhysics()),
                defaultTransition: Transition.fadeIn,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: getThemeMode(themeController.theme),
                home: const Onboarding(),
              ),
            ),
            breakpoints: [
              
              const Breakpoint(start: 0, end: 450, name: MOBILE),
              const Breakpoint(start: 451, end: 800, name: TABLET),
              const Breakpoint(start: 801, end: 1920, name: DESKTOP),
              const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
            ],
          );
        },
      ),
    );
  }
}
