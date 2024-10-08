import 'package:flutter/material.dart';
import 'package:elearning/app/controllers/theme/config.dart' as config;

var skLightTheme = ThemeData(
  canvasColor: Colors.transparent,
  primaryColor: Colors.white,
  brightness: Brightness.light,
  focusColor: config.Colorss().mainColor(1),
  hintColor: config.Colorss().secondColor(1),
  textTheme: TextTheme(
    labelLarge: TextStyle(
      fontFamily: 'Red Hat Display',
      fontSize: 16,
      fontWeight: FontWeight.w800,
      color: Color(0xFFFFFFFF),
    ),
    headlineSmall: TextStyle(
      fontSize: 16.0,
      color: Colors.white.withOpacity(1),
      fontFamily: "Red Hat Display",
    ),
    headlineMedium: TextStyle(
        fontSize: 16,
        fontFamily: "Red Hat Display",
        fontWeight: FontWeight.w500,
        color: config.Colorss().accentColor(1)),
    displaySmall: TextStyle(
        fontSize: 20,
        fontFamily: "Red Hat Display",
        fontWeight: FontWeight.w500,
        color: Colors.black),
    displayMedium: TextStyle(
        fontSize: 24,
        fontFamily: "Red Hat Display",
        fontWeight: FontWeight.w500,
        color: Colors.black),
    displayLarge: TextStyle(
      fontFamily: 'Red Hat Display',
      color: config.Colorss().accentColor(1),
      fontSize: 50,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w900,
      color: config.Colorss().secondColor(1),
      fontFamily: "Roboto",
    ),
    titleLarge: TextStyle(
      fontSize: 13.0,
      color: Colors.white.withOpacity(.85),
      fontFamily: "Red Hat Display",
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Red Hat Display',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.white.withOpacity(.75),
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Red Hat Display',
      fontSize: 24,
      fontWeight: FontWeight.w500,
      color: Colors.white.withOpacity(1),
    ),
    bodySmall: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: config.Colorss().accentColor(1),
    ),
  ),
  colorScheme: ColorScheme.fromSwatch()
      .copyWith(secondary: config.Colorss().accentColor(1)),
);

var kDarkTheme = ThemeData(
  canvasColor: Colors.transparent,
  primaryColor: Color(0xFF181818),
  brightness: Brightness.dark,
  //accentColor: config.Colorss().accentDarkColor(1),
  focusColor: config.Colorss().mainDarkColor(1),
  hintColor: config.Colorss().secondDarkColor(1),
  textTheme: TextTheme(
    labelLarge: TextStyle(
      fontFamily: 'Red Hat Display',
      fontSize: 16,
      fontWeight: FontWeight.w800,
      color: Color(0xFF181818),
    ),
    headlineSmall: TextStyle(
      fontSize: 16.0,
      color: config.Colorss().accentDarkColor(1),
      fontFamily: "Red Hat Display",
    ),
    headlineMedium: TextStyle(
        fontSize: 16,
        fontFamily: "Red Hat Display",
        fontWeight: FontWeight.w500,
        color: config.Colorss().accentDarkColor(1)),
    displaySmall: TextStyle(
        fontSize: 20,
        fontFamily: "Red Hat Display",
        fontWeight: FontWeight.w500,
        color: Colors.white),
    displayMedium: TextStyle(
        fontSize: 24,
        fontFamily: "Red Hat Display",
        fontWeight: FontWeight.w500,
        color: Colors.white),
    displayLarge: TextStyle(
      fontFamily: 'Red Hat Display',
      color: config.Colorss().accentDarkColor(1),
      fontSize: 50,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w900,
      color: config.Colorss().secondDarkColor(1),
      fontFamily: "Roboto",
    ),
    titleLarge: TextStyle(
      fontSize: 14.0,
      color: config.Colorss().accentDarkColor(.85),
      fontFamily: "Red Hat Display",
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Red Hat Display',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: config.Colorss().accentDarkColor(.85),
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Red Hat Display',
      fontSize: 22,
      fontWeight: FontWeight.w500,
      color: config.Colorss().accentDarkColor(1),
    ),
    bodySmall: TextStyle(
      fontFamily: 'Roboto',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: config.Colorss().accentDarkColor(1),
    ),
  ),
);
