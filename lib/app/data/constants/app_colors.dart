import 'package:flutter/material.dart';

class AppColors {
  static const Color kPrimary = Color(0xFF329494);
  // static const Color kSecondary = Color(0xFF8BC34A); //0xFFCABDFF
  static const Color kWarning = Color(0xFFF4BF4B);
  static const Color kBackground = Color(0xFFF9F9F9);
  static const Color kAccent1 = Color(0xFFFCCBB9);
  static const Color kAccent2 = Color(0xFFB9C2FC);
  static const Color kAccent3 = Color(0xFFEEB8D8);
  static const Color kAccent4 = Color(0xFF6AC6C5);
  static const Color kAccent7 = Color(0xFFFF0000);
  static const Color kAccent8 = Color(0xFFFB9B9B);
  // static const Color kSecondary = Color(0xFF1D2445);
  static const Color kSecondary = Color(0xFF1D2445);
  static const Color kDarkContiner = Color(0xFF18202E);

  static const Color kSuccess = Color(0xFF329447);
  static const Color kGrey = Color(0xFF00004D);
  static const Color kLine = Color(0xFF1D2453);
  static const Color kWhite = Color(0xFFFFFFFF);
  static const Color kInput = Color(0xFFF5F5F5);
  static const Color kHint = Color(0xFFBDBDBD);
  static const Color kLightPink = Color(0xFFF5D3BB);
  static const Color kLightPink2 = Color(0xFFFFE2CD);
  static const Color kLightBrown = Color(0xFF73665C);
  static const Color kNeutral = Color(0xFF9A9FA5);
  static const Color kNeutral01 = Color(0xFFFCFCFC);
  static const Color kNeutral03 = Color(0xFFEFEFEF);
  static const Color kNeutral04 = Color(0xFF6F767E);
  static const Color kGradienttop = Color(0xFFFFFFED);
  static const Color kGradientbottom = Color(0xFFD0EFCE);

  // Dark.
  static const Color kDarkBackground = Color(0xFF0F1621);
  static const Color kDarkSurfaceColor = Color(0xFF18202E);
  static const Color kDarkInput = Color(0xFF18202E);
  static const Color kDarkHint = Color(0xFF2F3643);
  static const Color kContentColor = Color(0xFF2F3643);

  static BoxShadow defaultShadow = BoxShadow(
    color: AppColors.kPrimary.withOpacity(0.2),
    blurRadius: 7,
    offset: const Offset(0, 5),
  );

  static BoxShadow darkShadow = BoxShadow(
    color: AppColors.kSecondary.withOpacity(0.2),
    blurRadius: 7,
    offset: const Offset(0, 5),
  );
}
