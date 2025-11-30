import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:pills_reminder/core/models/notification_model.dart';
import 'package:pills_reminder/core/utils/debug_print.dart';
import 'package:pills_reminder/core/utils/notifications_helper.dart';

class NotificationManager {
  /// Retrieves all active notifications from Hive based on the current storage mode
  /// (Grouped or Individual). Opens necessary boxes if they are not already open.
  static Future<List<NotificationModel>> getAllNotifications() async {
    // Ensure Settings box is open to check the mode
    if (!Hive.isBoxOpen('Settings')) {
      await Hive.openBox('Settings');
    }
    final settingsBox = Hive.box('Settings');
    final bool isGrouped = settingsBox.get(
      'groupedNotifications',
      defaultValue: false,
    );

    List<NotificationModel> allNotifications = [];

    if (isGrouped) {
      // Grouped Mode: Notifications are stored as individual models in 'groupedNotifications' box
      if (!Hive.isBoxOpen('groupedNotifications')) {
        await Hive.openBox('groupedNotifications');
      }
      final groupedBox = Hive.box('groupedNotifications');
      for (var value in groupedBox.values) {
        if (value is NotificationModel) {
          allNotifications.add(value);
        }
      }
    } else {
      // Individual Mode: Notifications are stored as lists in 'notifications' box
      if (!Hive.isBoxOpen('notifications')) {
        await Hive.openBox<NotificationList>('notifications');
      }
      final notificationsBox = Hive.box<NotificationList>('notifications');
      for (var list in notificationsBox.values) {
        allNotifications.addAll(list.items);
      }
    }

    return allNotifications;
  }

  /// Schedules a single notification using the provided plugin.
  /// Handles payload decoding and logging.
  static Future<void> scheduleNotification({
    required FlutterLocalNotificationsPlugin plugin,
    required NotificationModel notification,
  }) async {
    String? locale;
    if (notification.payload != null) {
      try {
        final decoded = json.decode(notification.payload!);
        locale = decoded['locale'];
      } catch (e) {
        debugOnlyPrint(
          "Error decoding payload for notification ${notification.id}: $e",
        );
      }
    }

    await plugin.zonedSchedule(
      notification.id,
      notification.title,
      notification.body,
      notification.time,
      NotificationsHelper.getNotificationDetails(locale: locale),
      matchDateTimeComponents: notification.matchComponents,
      androidScheduleMode: notification.androidScheduleMode,
      payload: notification.payload,
    );

    debugOnlyPrint(
      "Scheduled notification with id: ${notification.id} with title: ${notification.title}",
    );
  }
}
