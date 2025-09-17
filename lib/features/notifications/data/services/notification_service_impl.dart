import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
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
      payload: jsonEncode({
        "locale": Get.locale?.languageCode ?? '',
        "id": "$id",
        "pill time": "${dateTime.hour}:${dateTime.minute}",
      }),
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
      NotificationsHelper.getNotificationDetails(
        locale: json.decode(notification.payload!)['locale'],
      ),
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
        payload: jsonEncode({
          "locale": Get.locale?.languageCode ?? '',
          "id": "$id",
          "pill time": '${scheduledDate.hour}:${scheduledDate.minute}',
        }),
      );
      // Store notification, for later handling
      notifications.items.add(notification);
      box.put(id, notifications);
      // Schedule the notification
      await _plugin.zonedSchedule(
        notification.id, // unique ID per weekday and time
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
          payload: jsonEncode({
            "locale": Get.locale?.languageCode ?? '',
            "id": "$id",
            "pill time": '${scheduledDate.hour}:${scheduledDate.minute}',
          }),
        );

        // Store notification, for later handling
        notifications.items.add(notification);
        box.put(id, notifications);
        // Schedule the notification
        await _plugin.zonedSchedule(
          notification.id, // unique ID per weekday and time
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
    final String localTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimeZone));
    late final NotificationModel notification;

    /// Initialize the grouped notifications box
    final Box box = Hive.box('groupedNotifications');

    /// If no weekdays selected => schedule daily
    if (weekdays.isEmpty) {
      final tz.TZDateTime scheduledDate = TzDateHelper.nextInstanceOfTime(time);
      NotificationModel? groupedNotification = box.get(
        'daily at ${scheduledDate.hour}:${scheduledDate.minute}',
      );
      // If grouped notification exists => update it
      groupedNotification != null
          ? notification = groupedNotification.copyWith(
              title: '${groupedNotification.title}, $medicationName',
              payload: jsonEncode({
                "locale": Get.locale?.languageCode ?? '',
                "id": jsonDecode(groupedNotification.payload!)['id'] + ',$id',
                "pill time": '${scheduledDate.hour}:${scheduledDate.minute}',
                "is Grouped": "true",
              }),
            )
          : // If grouped notification doesn't exist => create it
            notification = NotificationModel(
              id: (id + scheduledDate.hour + scheduledDate.minute).toInt(),
              title: title,
              body: body,
              time: tz.TZDateTime.from(scheduledDate.toUtc(), tz.local),
              matchComponents: DateTimeComponents.time,
              androidScheduleMode:
                  notificationType?.androidScheduleMode ??
                  AndroidScheduleMode.alarmClock,
              payload: jsonEncode({
                "locale": Get.locale?.languageCode ?? '',
                "id": "$id",
                "pill time": '${scheduledDate.hour}:${scheduledDate.minute}',
                "is Grouped": "true",
              }),
            );
      // Store notification, for later handling
      box.put(
        'daily at ${scheduledDate.hour}:${scheduledDate.minute}',
        notification,
      );
      // Schedule the notification
      await _plugin.zonedSchedule(
        notification.id, // unique ID per weekday and time
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
    } else {
      /// Schedule on each selected weekday
      for (final weekday in weekdays) {
        final tz.TZDateTime scheduledDate =
            TzDateHelper.nextInstanceOfDayAndTime(weekday, time);
        NotificationModel? groupedNotification = box.get(
          '$weekday/${scheduledDate.hour}:${scheduledDate.minute}',
        );
        // If grouped notification exists => update it
        groupedNotification != null
            ? notification = groupedNotification.copyWith(
                title: '${groupedNotification.title}, $medicationName',
                payload: jsonEncode({
                  "locale": Get.locale?.languageCode ?? '',
                  "id": jsonDecode(groupedNotification.payload!)['id'] + ',$id',
                  "pill time": '${scheduledDate.hour}:${scheduledDate.minute}',
                  "is Grouped": "true",
                }),
              )
            : // If grouped notification doesn't exist => create it
              notification = NotificationModel(
                id:
                    id +
                    weekday.index +
                    scheduledDate.hour +
                    scheduledDate.minute,
                title: title,
                body: body,
                time: tz.TZDateTime.from(scheduledDate.toUtc(), tz.local),
                matchComponents: DateTimeComponents.dayOfWeekAndTime,
                androidScheduleMode:
                    notificationType?.androidScheduleMode ??
                    AndroidScheduleMode.alarmClock,
                payload: jsonEncode({
                  "locale": Get.locale?.languageCode ?? '',
                  "id": "$id",
                  "pill time": '${scheduledDate.hour}:${scheduledDate.minute}',
                  "is Grouped": "true",
                }),
              );
        // Store notification, for later handling
        box.put(
          '$weekday/${scheduledDate.hour}:${scheduledDate.minute}',
          notification,
        );
        await _plugin.zonedSchedule(
          notification.id, // unique ID per weekday and time
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
  Future<void> rescheduleNotification({
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
