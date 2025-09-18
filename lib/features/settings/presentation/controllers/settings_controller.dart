import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:pills_reminder/core/models/notification_model.dart';
import 'package:pills_reminder/core/styles/theme.dart';
import 'package:pills_reminder/features/notifications/presentation/controllers/notifications_controller.dart';

class SettingsController extends GetxController {
  final Box box;
  SettingsController(this.box);
  late int themeIndex;
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;
  final Rx<ThemeData> lightTheme = ThemeData().obs;
  final Rx<ThemeData> darkTheme = ThemeData().obs;
  final Rx<bool> groupedNotifications = false.obs;
  final Rx<Locale> locale = Locale('en').obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    themeIndex = box.get('themeIndex') ?? 15;
    locale.value = Locale(box.get('lang') ?? 'en');
    themeMode.value = getThemeMode(box.get('themeMode') ?? 0);
    lightTheme.value = AppThemes.lightThemes[themeIndex];
    darkTheme.value = AppThemes.darkThemes[themeIndex];
    groupedNotifications.value = box.get('groupedNotifications') ?? false;
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

  Future<void> changeNotificationMode(bool value) async {
    if (value) {
      Get.find<NotificationsController>().convertNormalToGrouped(
        normalBox: await Hive.openBox<NotificationList>('notifications'),
        groupedBox: await Hive.openBox('groupedNotifications'),
      );
    } else {
      Get.find<NotificationsController>().convertGroupedToNormal(
        normalBox: await Hive.openBox<NotificationList>('notifications'),
        groupedBox: await Hive.openBox('groupedNotifications'),
      );
    }
    groupedNotifications.value = value;
    box.put('groupedNotifications', groupedNotifications.value);
    update();
  }
}
