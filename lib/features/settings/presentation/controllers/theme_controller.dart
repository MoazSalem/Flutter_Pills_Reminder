import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:pills_reminder/core/styles/theme.dart';

class ThemeController extends GetxController {
  ThemeController();
  late int themeIndex;
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;
  final Rx<ThemeData> lightTheme = ThemeData().obs;
  final Rx<ThemeData> darkTheme = ThemeData().obs;
  late Box box;

  @override
  Future<void> onInit() async {
    super.onInit();
    box = Hive.box('Themes');
    themeIndex = box.get('themeIndex') ?? 15;
    themeMode.value = getThemeMode(box.get('themeMode') ?? 0);
    lightTheme.value = AppThemes.lightThemes[themeIndex];
    darkTheme.value = AppThemes.darkThemes[themeIndex];
    update();
  }

  @override
  void onClose() {
    box.close();
    super.onClose();
  }

  ThemeMode getThemeMode(int index) {
    switch (index) {
      case 0:
        return themeMode.value = ThemeMode.system;
      case 1:
        return themeMode.value = ThemeMode.light;
      case 2:
        return themeMode.value = ThemeMode.dark;
      default:
        return themeMode.value = ThemeMode.system;
    }
  }

  void changeThemeMode(ThemeMode mode) {
    box.put('themeMode', mode.index);
    themeMode.value = mode;
    update();
  }

  void changeTheme(int index) {
    box.put('themeIndex', index);
    themeIndex = index;
    lightTheme.value = AppThemes.lightThemes[themeIndex];
    darkTheme.value = AppThemes.darkThemes[themeIndex];
    update();
  }
}
