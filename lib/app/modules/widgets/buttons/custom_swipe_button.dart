import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';

import '../../../data/constants/constants.dart';

class CustomSwipeButton extends StatelessWidget {
  final VoidCallback onSwipe;
  const CustomSwipeButton({required this.onSwipe, super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode(BuildContext context) =>
        Theme.of(context).brightness == Brightness.dark;

    return SwipeButton(
      borderRadius: BorderRadius.circular(8),
      activeTrackColor: Colors.transparent,
      width: double.maxFinite,
      activeThumbColor:
          isDarkMode(context) ? AppColors.kSecondary : AppColors.kPrimary,
      thumb: Padding(
        padding: EdgeInsets.all(15.h),
        child: Icon(
          AppAssets.kArrowForward,
          color:
              isDarkMode(context) ? AppColors.kPrimary : AppColors.kSecondary,
        ),
      ),
      onSwipe: onSwipe,
      child: const SizedBox(),
    );
  }
}
