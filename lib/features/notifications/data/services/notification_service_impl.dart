import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:pills_reminder/core/models/weekday.dart';
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
  Future<void> scheduleMedicationNotificationOnce({
    required int id,
    String? title,
    required String body,
    required DateTime dateTime,
  }) async {
    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(dateTime.toUtc(), tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails('med_channel', 'Medications'),
      ),
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  @override
  Future<void> scheduleDailyOrWeeklyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
    required List<Weekday> weekdays,
  }) async {
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
        case 0:
          return Weekday.monday;
        case 1:
          return Weekday.tuesday;
        case 2:
          return Weekday.wednesday;
        case 3:
          return Weekday.thursday;
        case 4:
          return Weekday.friday;
        case 5:
          return Weekday.saturday;
        case 6:
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
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_channel',
            'Daily Notifications',
            channelDescription: 'Daily medication reminders',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        matchDateTimeComponents: DateTimeComponents.time,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
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
          scheduledDate,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'weekly_channel',
              'Weekly Notifications',
              channelDescription: 'Weekly medication reminders',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      }
    }
  }

  @override
  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }
}
