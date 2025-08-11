import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:pills_reminder/core/models/notification_model.dart';
import 'package:pills_reminder/core/models/notification_type.dart';
import 'package:pills_reminder/core/models/weekday.dart';
import 'package:pills_reminder/core/utils/tz_date_helper.dart';
import 'package:pills_reminder/features/notifications/domain/services/notification_service.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationServiceImpl implements NotificationService {
  final FlutterLocalNotificationsPlugin _plugin;
  static final List<AndroidNotificationAction> actionsList = [
    AndroidNotificationAction(
      'remind_again',
      'remindAgain'.tr,
      showsUserInterface: false,
      cancelNotification: true,
    ),
  ];
  static final details = NotificationDetails(
    android: AndroidNotificationDetails(
      'meds_channel',
      'Medications Notifications',
      channelDescription: 'medication reminders',
      importance: Importance.max,
      priority: Priority.high,
      actions: actionsList,
    ),
  );

  NotificationServiceImpl(this._plugin);

  @override
  Future<void> normalNotification({
    required String title,
    required String body,
  }) {
    return _plugin.show(0, title, body, details);
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
    );

    /// Add notification to box if repeating
    if (isRepeating) {
      var box = await Hive.openBox('notifications');
      final List<NotificationModel> notifications = box.get(id) ?? [];
      notifications.add(notification);
      await box.put(id, notifications);
    }

    await _plugin.zonedSchedule(
      notification.id,
      notification.title,
      notification.body,
      notification.time,
      details,
      matchDateTimeComponents: notification.matchComponents,
      androidScheduleMode: notification.androidScheduleMode,
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
    var box = await Hive.openBox('notifications');
    final List<NotificationModel> notifications = box.get(id) ?? [];

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
      );
      // Store notification, for later handling
      notifications.add(notification);
      box.put(id, notifications);

      await _plugin.zonedSchedule(
        notification.id, // unique ID per weekday and time
        notification.title,
        notification.body,
        notification.time,
        details,
        matchDateTimeComponents: notification.matchComponents,
        androidScheduleMode: notification.androidScheduleMode,
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
        );

        // Store notification, for later handling
        notifications.add(notification);
        box.put(id, notifications);

        await _plugin.zonedSchedule(
          notification.id, // unique ID per weekday and time
          notification.title,
          notification.body,
          notification.time,
          details,
          matchDateTimeComponents: notification.matchComponents,
          androidScheduleMode: notification.androidScheduleMode,
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
      details,
      matchDateTimeComponents: notification.matchComponents,
      androidScheduleMode: notification.androidScheduleMode,
    );
    debugPrint('Notification rescheduled');
  }
}
