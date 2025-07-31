import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:pills_reminder/core/models/weekday.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pills_reminder/features/notifications/data/services/notification_service_impl.dart';
import 'package:pills_reminder/features/notifications/domain/repositories/notification_repo.dart';
import 'package:pills_reminder/features/notifications/domain/services/notification_service.dart';

class NotificationRepoImpl implements NotificationRepo {
  bool isNotificationPermissionGranted = false;
  late final NotificationService notificationService;
  @override
  Future<void> initNotificationService() async {
    final notificationsPlugin = FlutterLocalNotificationsPlugin();
    // Ensure plugin is initialized
    await notificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@drawable/icon'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    notificationService = NotificationServiceImpl(notificationsPlugin);
  }

  @override
  Future<void> requestNotificationPermission() async {
    if (isNotificationPermissionGranted) {
      return Future.value();
    }
    isNotificationPermissionGranted = true;
    final status = await Permission.notification.request();

    if (!status.isGranted) {
      isNotificationPermissionGranted = false;
      Get.snackbar(
        duration: const Duration(seconds: 5),
        'Permission Denied',
        'Notifications will not work until permission is granted.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        mainButton: TextButton(
          onPressed: () {
            openAppSettings();
          },
          child: Text(
            'Open Settings',
            style: TextStyle(color: Get.theme.colorScheme.onError),
          ),
        ),
      );
    }
  }

  @override
  Future<void> requestExactAlarmPermission() async {
    if (Platform.isAndroid) {
      const platform = MethodChannel('exact_alarm_channel');

      try {
        final isGranted = await platform.invokeMethod(
          'checkExactAlarmPermission',
        );

        if (!isGranted) {
          final intent = AndroidIntent(
            action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
          );
          await intent.launch();
        }
      } catch (e) {
        debugPrint('Error checking exact alarm permission: $e');
      }
    }
  }

  @override
  Future<void> cancelNotification(int id) async {
    await notificationService.cancelNotification(id);
  }

  @override
  Future<void> cancelAllNotificationForMedication(int id) async {
    var box = await Hive.openBox('notificationsIds');
    var ids = box.get(id) ?? [];
    for (var id in ids) {
      await notificationService.cancelNotification(id);
    }
    box.delete(id);
  }

  @override
  Future<void> normalNotification({
    required String title,
    required String body,
  }) async {
    await requestNotificationPermission();
    await notificationService.normalNotification(title: title, body: body);
  }

  @override
  Future<void> scheduleNotificationOnce({
    required DateTime dateTime,
    required int id,
    String? title,
    String? body,
    required String medicationName,
  }) async {
    await requestNotificationPermission();
    await notificationService.scheduleMedicationNotificationOnce(
      id: id,
      title: title ?? 'Take Your Medication',
      body: body ?? 'Time to take your $medicationName pill',
      dateTime: dateTime,
    );
    debugPrint("Notification scheduled with id $id at $dateTime");
  }

  @override
  Future<void> scheduleDailyOrWeeklyNotification({
    required int id,
    String? title,
    String? body,
    required String medicationName,
    required TimeOfDay time,
    required List<Weekday> weekdays,
  }) async {
    await requestNotificationPermission();
    await notificationService.scheduleDailyOrWeeklyNotification(
      id: id,
      title: title ?? 'Take Your Medication',
      body: body ?? 'Time to take your $medicationName pill',
      time: time,
      weekdays: weekdays,
    );
    debugPrint(
      "Weekly Notification scheduled with id $id at $time at $weekdays",
    );
  }
}
