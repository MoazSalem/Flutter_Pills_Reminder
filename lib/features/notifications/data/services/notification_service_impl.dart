import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:pills_reminder/core/models/notification_model.dart';
import 'package:pills_reminder/core/models/notification_type.dart';
import 'package:pills_reminder/core/models/weekday.dart';
import 'package:pills_reminder/core/utils/notifications_helper.dart';
import 'package:pills_reminder/core/utils/tz_date_helper.dart';
import 'package:pills_reminder/features/notifications/domain/services/notification_service.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationServiceImpl implements NotificationService {
  final FlutterLocalNotificationsPlugin _plugin;
  NotificationServiceImpl(this._plugin);

  @override
  Future<void> normalNotification({
    required String title,
    required String body,
  }) {
    return _plugin.show(0, title, body, NotificationDetails());
  }

  @override
  Future<void> scheduleMedicationNotification({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
    NotificationType? notificationType,
    required bool isRepeating,
  }) async {
    final NotificationModel notification = NotificationModel(
      id: id,
      title: title,
      body: body,
      time: tz.TZDateTime.from(dateTime.toUtc(), tz.local),
      matchComponents: isRepeating
          ? DateTimeComponents.dayOfMonthAndTime
          : null,
      androidScheduleMode:
          notificationType?.androidScheduleMode ??
          AndroidScheduleMode.alarmClock,
      payload: Get.locale?.languageCode ?? '',
    );

    /// Add notification to box if repeating
    if (isRepeating) {
      Box box = Hive.box<NotificationList>('notifications');
      final NotificationList notifications =
          box.get(id) ?? NotificationList(items: []);
      notifications.items.add(notification);
      await box.put(id, notifications);
    }

    await _plugin.zonedSchedule(
      notification.id,
      notification.title,
      notification.body,
      notification.time,
      NotificationsHelper.getNotificationDetails(locale: notification.payload),
      matchDateTimeComponents: notification.matchComponents,
      androidScheduleMode: notification.androidScheduleMode,
      payload: notification.payload,
    );
  }

  @override
  Future<void> scheduleDailyOrWeeklyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
    required List<Weekday> weekdays,
    NotificationType? notificationType,
  }) async {
    final String localTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimeZone));

    /// Initialize the notifications box
    Box box = Hive.box<NotificationList>('notifications');
    final NotificationList notifications =
        box.get(id) ?? NotificationList(items: []);

    /// If no weekdays selected => schedule daily
    if (weekdays.isEmpty) {
      final tz.TZDateTime scheduledDate = TzDateHelper.nextInstanceOfTime(time);
      final NotificationModel notification = NotificationModel(
        id: (id + scheduledDate.hour + scheduledDate.minute).toInt(),
        title: title,
        body: body,
        time: tz.TZDateTime.from(scheduledDate.toUtc(), tz.local),
        matchComponents: DateTimeComponents.time,
        androidScheduleMode:
            notificationType?.androidScheduleMode ??
            AndroidScheduleMode.alarmClock,
        payload: Get.locale?.languageCode ?? '',
      );
      // Store notification, for later handling
      notifications.items.add(notification);
      box.put(id, notifications);

      await _plugin.zonedSchedule(
        notification.id, // unique ID per weekday and time
        notification.title,
        notification.body,
        notification.time,
        NotificationsHelper.getNotificationDetails(
          locale: notification.payload,
        ),
        matchDateTimeComponents: notification.matchComponents,
        androidScheduleMode: notification.androidScheduleMode,
        payload: notification.payload,
      );
    } else {
      /// Schedule on each selected weekday
      for (final weekday in weekdays) {
        final tz.TZDateTime scheduledDate =
            TzDateHelper.nextInstanceOfDayAndTime(weekday, time);

        final NotificationModel notification = NotificationModel(
          id: id + weekday.index + scheduledDate.hour + scheduledDate.minute,
          title: title,
          body: body,
          time: tz.TZDateTime.from(scheduledDate.toUtc(), tz.local),
          matchComponents: DateTimeComponents.dayOfWeekAndTime,
          androidScheduleMode:
              notificationType?.androidScheduleMode ??
              AndroidScheduleMode.alarmClock,
          payload: Get.locale?.languageCode ?? '',
        );

        // Store notification, for later handling
        notifications.items.add(notification);
        box.put(id, notifications);

        await _plugin.zonedSchedule(
          notification.id, // unique ID per weekday and time
          notification.title,
          notification.body,
          notification.time,
          NotificationsHelper.getNotificationDetails(
            locale: notification.payload,
          ),
          matchDateTimeComponents: notification.matchComponents,
          androidScheduleMode: notification.androidScheduleMode,
          payload: notification.payload,
        );
      }
    }
  }

  @override
  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }

  @override
  Future<void> requestExactAlarmPermission() async {
    if (Platform.isAndroid) {
      final bool? granted;
      granted = await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
      debugPrint(granted.toString());
    }
  }

  @override
  Future<void> rescheduleNotification({
    required NotificationModel notification,
  }) async {
    await _plugin.zonedSchedule(
      notification.id, // unique ID per weekday and time
      notification.title,
      notification.body,
      notification.time,
      NotificationsHelper.getNotificationDetails(
        locale: Get.locale?.languageCode ?? '',
      ),
      matchDateTimeComponents: notification.matchComponents,
      androidScheduleMode: notification.androidScheduleMode,
      payload: Get.locale?.languageCode ?? '',
    );
  }
}
