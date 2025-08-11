import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
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
    String? title,
    required String body,
    required DateTime dateTime,
    NotificationType? notificationType,
    required bool isRepeating,
  }) async {
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(dateTime.toUtc(), tz.local),
      details,
      matchDateTimeComponents: isRepeating
          ? DateTimeComponents.dayOfMonthAndTime
          : null,
      androidScheduleMode:
          notificationType?.androidScheduleMode ??
          AndroidScheduleMode.inexactAllowWhileIdle,
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

    /// Initialize the notificationsIds box
    var box = await Hive.openBox('notificationsIds');
    final List subIds = box.get(id) ?? [];

    /// If no weekdays selected => schedule daily
    if (weekdays.isEmpty) {
      final tz.TZDateTime scheduledDate = TzDateHelper.nextInstanceOfTime(time);
      // Store sub ids to cancel later
      subIds.add(id + scheduledDate.hour + scheduledDate.minute);
      box.put(id, subIds);

      await _plugin.zonedSchedule(
        id + scheduledDate.hour + scheduledDate.minute, // unique ID per time
        title,
        body,
        tz.TZDateTime.from(scheduledDate.toUtc(), tz.local),
        details,
        matchDateTimeComponents: DateTimeComponents.time,
        androidScheduleMode:
            notificationType?.androidScheduleMode ??
            AndroidScheduleMode.inexactAllowWhileIdle,
      );
    } else {
      /// Schedule on each selected weekday
      for (final weekday in weekdays) {
        final tz.TZDateTime scheduledDate =
            TzDateHelper.nextInstanceOfDayAndTime(weekday, time);

        // Store sub ids for each weekday to cancel later
        subIds.add(
          id + weekday.index + scheduledDate.hour + scheduledDate.minute,
        );
        box.put(id, subIds);

        await _plugin.zonedSchedule(
          id +
              weekday.index +
              scheduledDate.hour +
              scheduledDate.minute, // unique ID per weekday and time
          title,
          body,
          tz.TZDateTime.from(scheduledDate.toUtc(), tz.local),
          details,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          androidScheduleMode:
              notificationType?.androidScheduleMode ??
              AndroidScheduleMode.inexactAllowWhileIdle,
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
}
