import 'dart:io';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:pills_reminder/core/models/notification_type.dart';
import 'package:pills_reminder/core/models/weekday.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pills_reminder/features/notifications/data/services/notification_service_impl.dart';
import 'package:pills_reminder/features/notifications/domain/repositories/notification_repo.dart';
import 'package:pills_reminder/features/notifications/domain/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationRepoImpl implements NotificationRepo {
  bool isNotificationPermissionGranted = false;
  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  late final NotificationService notificationService;

  @override
  Future<void> initNotificationService() async {
    // Ensure plugin is initialized
    await notificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@drawable/icon'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveBackgroundNotificationResponse: notificationBackgroundHandler,
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
        'permissionDenied'.tr,
        'notificationsWillNotWork'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        mainButton: TextButton(
          onPressed: () {
            openAppSettings();
          },
          child: Text(
            'openSettings'.tr,
            style: TextStyle(color: Get.theme.colorScheme.onError),
          ),
        ),
      );
    }
  }

  @override
  Future<void> requestExactAlarmPermission() async {
    await notificationService.requestExactAlarmPermission();
  }

  @override
  Future<void> cancelNotification(int id) async {
    await notificationService.cancelNotification(id);
  }

  @override
  Future<void> cancelAllNotificationForMedication(int id) async {
    var box = await Hive.openBox('notifications');
    var notifications = box.get(id) ?? [];
    for (var notification in notifications) {
      await notificationService.cancelNotification(notification.id);
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
  Future<void> scheduleNotification({
    required DateTime dateTime,
    required int id,
    String? title,
    String? body,
    required String medicationName,
    NotificationType? notificationType,
    required bool isRepeating,
  }) async {
    await requestNotificationPermission();
    if (Platform.isAndroid && notificationType != NotificationType.inexact) {
      await requestExactAlarmPermission();
    }
    await notificationService.scheduleMedicationNotification(
      id: id,
      title: title ?? '${'notificationTitle'.tr} $medicationName',
      body: body ?? 'notificationBody'.tr,
      dateTime: dateTime,
      notificationType: notificationType,
      isRepeating: isRepeating,
    );
  }

  @override
  Future<void> scheduleDailyOrWeeklyNotification({
    required int id,
    String? title,
    String? body,
    required String medicationName,
    required TimeOfDay time,
    required List<Weekday> weekdays,
    NotificationType? notificationType,
  }) async {
    await requestNotificationPermission();
    if (Platform.isAndroid && notificationType != NotificationType.inexact) {
      await requestExactAlarmPermission();
    }
    await notificationService.scheduleDailyOrWeeklyNotification(
      id: id,
      title: title ?? '${"notificationTitle".tr} $medicationName',
      body: body ?? 'notificationBody'.tr,
      time: time,
      weekdays: weekdays,
      notificationType: notificationType,
    );
  }
}

@pragma('vm:entry-point')
void notificationBackgroundHandler(NotificationResponse response) async {
  if (response.actionId == 'remind_again') {
    final plugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@drawable/icon');

    final InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
    );
    tz.initializeTimeZones();
    await plugin.initialize(
      initSettings,
      onDidReceiveBackgroundNotificationResponse: notificationBackgroundHandler,
    );
    final String localTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimeZone));
    final now = DateTime.now().add(const Duration(minutes: 30));
    final tzTime = tz.TZDateTime.from(now, tz.local);

    await plugin.zonedSchedule(
      UniqueKey().hashCode,
      'reminder'.tr,
      'reminderDescription'.tr,
      tzTime,
      NotificationServiceImpl.details,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
    );
  }
}
