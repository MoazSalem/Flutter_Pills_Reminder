import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:pills_reminder/core/styles/theme.dart';

class SettingsController extends GetxController {
  SettingsController();
  late int themeIndex;
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;
  final Rx<ThemeData> lightTheme = ThemeData().obs;
  final Rx<ThemeData> darkTheme = ThemeData().obs;
  final Rx<Locale> locale = Locale('en').obs;
  late Box box;

  @override
  Future<void> onInit() async {
    super.onInit();
    box = Hive.box('Settings');
    themeIndex = box.get('themeIndex') ?? 15;
    locale.value = Locale(box.get('lang') ?? 'en');
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

  void changeLocale(String lang) {
    box.put('lang', lang);
    locale.value = Locale(lang);
    Get.updateLocale(locale.value);
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
