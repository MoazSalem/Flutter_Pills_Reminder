import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/core/styles/theme.dart';

class ThemeController extends GetxController {
  ThemeController();
  late ThemeMode themeMode;
  late ThemeData lightTheme;
  late ThemeData darkTheme;

  @override
  void onInit() {
    super.onInit();
    themeMode = ThemeMode.system;
    lightTheme = AppTheme.lightTheme;
    darkTheme = AppTheme.darkTheme;
  }
}
