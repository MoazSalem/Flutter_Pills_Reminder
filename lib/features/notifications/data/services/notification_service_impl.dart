import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:pills_reminder/core/models/notification_type.dart';
import 'package:pills_reminder/core/models/weekday.dart';
import 'package:pills_reminder/features/notifications/domain/services/notification_service.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationServiceImpl implements NotificationService {
  final FlutterLocalNotificationsPlugin _plugin;
  static const List<AndroidNotificationAction> actionsList = [
    AndroidNotificationAction(
      'remind_again',
      'Remind Again in 30 minutes',
      showsUserInterface: false,
      cancelNotification: true,
    ),
  ];
  NotificationServiceImpl(this._plugin);

  @override
  Future<void> normalNotification({
    required String title,
    required String body,
  }) {
    return _plugin.show(
      0,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails('med_channel', 'Medications'),
      ),
    );
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
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'med_channel',
          'Medications',
          actions: actionsList,
        ),
      ),
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

    /// Helper function to get the next notification time
    tz.TZDateTime nextInstanceOfTime(TimeOfDay time) {
      final now = tz.TZDateTime.now(tz.local);
      tz.TZDateTime scheduled = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );
      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }
      return scheduled;
    }

    /// Helper function to get the weekday from the index
    timeZonesDayToWeekday(int index) {
      switch (index) {
        case 1:
          return Weekday.monday;
        case 2:
          return Weekday.tuesday;
        case 3:
          return Weekday.wednesday;
        case 4:
          return Weekday.thursday;
        case 5:
          return Weekday.friday;
        case 6:
          return Weekday.saturday;
        case 7:
          return Weekday.sunday;
        default:
          return Weekday.monday;
      }
    }

    /// Helper function to get the notifications for each weekday
    tz.TZDateTime nextInstanceOfDayAndTime(Weekday weekday, TimeOfDay time) {
      tz.TZDateTime scheduled = nextInstanceOfTime(time);
      while (timeZonesDayToWeekday(scheduled.weekday) != weekday) {
        scheduled = scheduled.add(const Duration(days: 1));
      }
      return scheduled;
    }

    // If no weekdays selected => schedule daily
    if (weekdays.isEmpty) {
      final tz.TZDateTime scheduledDate = nextInstanceOfTime(time);
      // Store sub ids to cancel later
      subIds.add(id + scheduledDate.hour + scheduledDate.minute);
      box.put(id, subIds);

      await _plugin.zonedSchedule(
        id + scheduledDate.hour + scheduledDate.minute, // unique ID per time
        title,
        body,
        tz.TZDateTime.from(scheduledDate.toUtc(), tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_channel',
            'Daily Notifications',
            channelDescription: 'Daily medication reminders',
            importance: Importance.max,
            priority: Priority.high,
            actions: actionsList,
          ),
        ),
        matchDateTimeComponents: DateTimeComponents.time,
        androidScheduleMode:
            notificationType?.androidScheduleMode ??
            AndroidScheduleMode.inexactAllowWhileIdle,
      );
    } else {
      // Schedule on each selected weekday
      for (final weekday in weekdays) {
        final tz.TZDateTime scheduledDate = nextInstanceOfDayAndTime(
          weekday,
          time,
        );

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
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'weekly_channel',
              'Weekly Notifications',
              channelDescription: 'Weekly medication reminders',
              importance: Importance.max,
              priority: Priority.high,
              actions: actionsList,
            ),
          ),
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
