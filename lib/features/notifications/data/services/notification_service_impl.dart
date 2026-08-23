import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/core/models/notification_model.dart';
import 'package:pills_reminder/core/models/notification_type.dart';
import 'package:pills_reminder/core/models/weekday.dart';
import 'package:pills_reminder/core/utils/debug_print.dart';
import 'package:pills_reminder/core/utils/notification_manager.dart';
import 'package:pills_reminder/core/utils/notifications_helper.dart';
import 'package:pills_reminder/core/utils/tz_date_helper.dart';
import 'package:pills_reminder/features/notifications/domain/services/notification_service.dart';
import 'package:pills_reminder/features/settings/presentation/controllers/settings_controller.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationServiceImpl implements NotificationService {
  final FlutterLocalNotificationsPlugin _plugin;

  NotificationServiceImpl(this._plugin);

  @override
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _plugin.pendingNotificationRequests();
  }

  @override
  Future<void> normalNotification({
    required String title,
    required String body,
  }) {
    return _plugin.show(
      id: 0,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(),
    );
  }

  @override
  Future<void> scheduleMedicationNotification({
    required int id,
    required String title,
    required String body,
    required String medicationName,
    required DateTime dateTime,
    NotificationType? notificationType,
    required bool isRepeating,
  }) async {
    NotificationModel notification = NotificationsHelper.buildNotification(
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
      final bool isGrouped =
          Get
              .find<SettingsController>()
              .groupedNotifications
              .value;
      if (isGrouped) {
        notification = await NotificationManager.saveGroupedNotification(
          notification: notification,
          medicationName: medicationName,
          newId: id,
        );
      } else {
        await NotificationManager.saveIndividualNotification(
          notification: notification,
          medicationId: id,
        );
      }
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
      await NotificationManager.saveIndividualNotification(
        notification: notification,
        medicationId: id,
      );
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
        await NotificationManager.saveIndividualNotification(
          notification: notification,
          medicationId: id,
        );
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
    /// If no weekdays selected => schedule daily
    if (weekdays.isEmpty) {
      final tz.TZDateTime scheduledDate = TzDateHelper.nextInstanceOfTime(time);
      final tz.TZDateTime finalTime = tz.TZDateTime.from(
        scheduledDate.toUtc(),
        tz.local,
      );

      final NotificationModel notification =
      NotificationsHelper.buildNotification(
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
      final NotificationModel savedNotification =
      await NotificationManager.saveGroupedNotification(
        notification: notification,
        medicationName: medicationName,
        newId: id,
      );

      // Schedule the notification
      await scheduleNotification(notification: savedNotification);
    } else {
      /// Schedule on each selected weekday
      for (final weekday in weekdays) {
        final tz.TZDateTime scheduledDate =
        TzDateHelper.nextInstanceOfDayAndTime(weekday, time);
        final tz.TZDateTime finalTime = tz.TZDateTime.from(
          scheduledDate.toUtc(),
          tz.local,
        );

        final NotificationModel notification =
        NotificationsHelper.buildNotification(
          id:
          id +
              weekday.index +
              scheduledDate.hour +
              scheduledDate.minute,
          medicationId: "$id",
          title: title,
          body: body,
          time: finalTime,
          matchComponents: DateTimeComponents.dayOfWeekAndTime,
          type: notificationType,
          isGrouped: true,
        );

        // Store notification, for later handling
        final NotificationModel savedNotification =
        await NotificationManager.saveGroupedNotification(
          notification: notification,
          medicationName: medicationName,
          newId: id,
        );

        await scheduleNotification(notification: savedNotification);
      }
    }
  }

  @override
  Future<void> cancelNotification(int id) async {
    debugOnlyPrint("Canceling notification with id: $id");
    await _plugin.cancel(id: id);
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
    await NotificationManager.scheduleNotification(
      plugin: _plugin,
      notification: notification,
    );
  }
}
