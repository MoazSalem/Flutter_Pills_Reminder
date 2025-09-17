import 'dart:convert';
import 'dart:io';

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
    final NotificationModel notification =
        NotificationsHelper.buildNotification(
          id: id,
          title: title,
          body: body,
          time: tz.TZDateTime.from(dateTime.toUtc(), tz.local),
          matchComponents: isRepeating
              ? DateTimeComponents.dayOfMonthAndTime
              : null,
          type: notificationType,
        );

    /// Add notification to box if repeating
    if (isRepeating) {
      Box box = Hive.box<NotificationList>('notifications');
      final NotificationList notifications =
          box.get(id) ?? NotificationList(items: []);
      notifications.items.add(notification);
      await box.put(id, notifications);
    }

    await scheduleNotification(notification: notification);
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
    debugPrint('scheduleDailyOrWeeklyNotification');
    final String localTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimeZone));

    /// Initialize the notifications box
    Box box = Hive.box<NotificationList>('notifications');
    final NotificationList notifications =
        box.get(id) ?? NotificationList(items: []);

    /// If no weekdays selected => schedule daily
    if (weekdays.isEmpty) {
      final tz.TZDateTime scheduledDate = TzDateHelper.nextInstanceOfTime(time);
      final NotificationModel notification =
          NotificationsHelper.buildNotification(
            id: id + scheduledDate.hour + scheduledDate.minute,
            medicationId: "$id",
            title: title,
            body: body,
            time: tz.TZDateTime.from(scheduledDate.toUtc(), tz.local),
            matchComponents: DateTimeComponents.time,
            type: notificationType,
          );
      // Store notification, for later handling
      notifications.items.add(notification);
      box.put(id, notifications);
      // Schedule the notification
      await scheduleNotification(notification: notification);
    } else {
      /// Schedule on each selected weekday
      for (final weekday in weekdays) {
        final tz.TZDateTime scheduledDate =
            TzDateHelper.nextInstanceOfDayAndTime(weekday, time);
        final NotificationModel
        notification = NotificationsHelper.buildNotification(
          id: id + weekday.index + scheduledDate.hour + scheduledDate.minute,
          medicationId: "$id",
          title: title,
          body: body,
          time: tz.TZDateTime.from(scheduledDate.toUtc(), tz.local),
          matchComponents: DateTimeComponents.dayOfWeekAndTime,
          type: notificationType,
        );
        // Store notification, for later handling
        notifications.items.add(notification);
        box.put(id, notifications);
        // Schedule the notification
        await scheduleNotification(notification: notification);
      }
    }
  }

  @override
  Future<void> scheduleGroupedDailyOrWeeklyNotification({
    required int id,
    required String title,
    required String body,
    required String medicationName,
    required TimeOfDay time,
    required List<Weekday> weekdays,
    NotificationType? notificationType,
  }) async {
    debugPrint('scheduleGroupedDailyOrWeeklyNotification');
    final String localTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimeZone));
    late final NotificationModel notification;

    /// Initialize the grouped notifications box
    final Box box = Hive.box('groupedNotifications');

    /// If no weekdays selected => schedule daily
    if (weekdays.isEmpty) {
      final tz.TZDateTime scheduledDate = TzDateHelper.nextInstanceOfTime(time);
      final tz.TZDateTime finalTime = tz.TZDateTime.from(
        scheduledDate.toUtc(),
        tz.local,
      );
      NotificationModel? groupedNotification = box.get(
        '${scheduledDate.day}/${scheduledDate.hour}:${scheduledDate.minute}',
      );
      // If grouped notification exists => update it
      groupedNotification != null
          ? notification = groupedNotification.copyWith(
              title: '${groupedNotification.title}, $medicationName',
              payload: NotificationsHelper.buildPayload(
                id: jsonDecode(groupedNotification.payload!)['id'] + ',$id',
                time: '${finalTime.hour}:${finalTime.minute}',
                isGrouped: true,
              ),
            )
          : // If grouped notification doesn't exist => create it
            notification = NotificationsHelper.buildNotification(
              id: id + scheduledDate.hour + scheduledDate.minute,
              medicationId: "$id",
              title: title,
              body: body,
              time: finalTime,
              matchComponents: DateTimeComponents.time,
              type: notificationType,
              isGrouped: true,
            );
      // Store notification, for later handling
      box.put(
        '${scheduledDate.day}/${scheduledDate.hour}:${scheduledDate.minute}',
        notification,
      );
      // Schedule the notification
      await scheduleNotification(notification: notification);
    } else {
      /// Schedule on each selected weekday
      for (final weekday in weekdays) {
        final tz.TZDateTime scheduledDate =
            TzDateHelper.nextInstanceOfDayAndTime(weekday, time);
        final tz.TZDateTime finalTime = tz.TZDateTime.from(
          scheduledDate.toUtc(),
          tz.local,
        );
        NotificationModel? groupedNotification = box.get(
          '${scheduledDate.day}/${scheduledDate.hour}:${scheduledDate.minute}',
        );
        // If grouped notification exists => update it
        groupedNotification != null
            ? notification = groupedNotification.copyWith(
                title: '${groupedNotification.title}, $medicationName',
                payload: NotificationsHelper.buildPayload(
                  id: jsonDecode(groupedNotification.payload!)['id'] + ',$id',
                  time: '${finalTime.hour}:${finalTime.minute}',
                  isGrouped: true,
                ),
              )
            : // If grouped notification doesn't exist => create it
              notification = NotificationsHelper.buildNotification(
                id:
                    id +
                    weekday.index +
                    scheduledDate.hour +
                    scheduledDate.minute,
                title: title,
                body: body,
                time: finalTime,
                matchComponents: DateTimeComponents.dayOfWeekAndTime,
                type: notificationType,
                isGrouped: true,
              );
        // Store notification, for later handling
        box.put(
          '${scheduledDate.day}/${scheduledDate.hour}:${scheduledDate.minute}',
          notification,
        );
        await scheduleNotification(notification: notification);
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
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }
  }

  @override
  Future<void> scheduleNotification({
    required NotificationModel notification,
  }) async {
    await _plugin.zonedSchedule(
      notification.id,
      notification.title,
      notification.body,
      notification.time,
      NotificationsHelper.getNotificationDetails(
        locale: json.decode(notification.payload!)['locale'],
      ),
      matchDateTimeComponents: notification.matchComponents,
      androidScheduleMode: notification.androidScheduleMode,
      payload: notification.payload,
    );
  }
}
