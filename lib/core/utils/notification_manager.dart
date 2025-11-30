import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart' as tz;
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:pills_reminder/core/models/notification_model.dart';
import 'package:pills_reminder/core/utils/debug_print.dart';
import 'package:pills_reminder/core/utils/notifications_helper.dart';
import 'package:pills_reminder/features/notifications/entrypoints/reschedule_notifications_entrypoint.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationManager {
  /// Initializes the FlutterLocalNotificationsPlugin with default settings.
  /// Also initializes timezones.
  static Future<FlutterLocalNotificationsPlugin> initPlugin({
    void Function(NotificationResponse)?
    onDidReceiveBackgroundNotificationResponse,
  }) async {
    // Initialize timezones
    tz.initializeTimeZones();
    final String localTimeZone = await tz.FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimeZone));

    final plugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@drawable/icon');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: DarwinInitializationSettings(),
    );
    await plugin.initialize(
      initSettings,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );
    return plugin;
  }

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

  /// Saves a grouped notification to Hive.
  /// If a notification for the same time exists, it updates it by appending the new medication ID.
  /// Otherwise, it creates a new grouped notification.
  /// Returns the final notification model that was saved (merged or new).
  static Future<NotificationModel> saveGroupedNotification({
    required NotificationModel notification,
    required String medicationName,
    required int newId,
  }) async {
    if (!Hive.isBoxOpen('groupedNotifications')) {
      await Hive.openBox('groupedNotifications');
    }
    final Box box = Hive.box('groupedNotifications');

    // Key format: M{day}/{hour}:{minute} or {weekday}/{hour}:{minute} or {hour}:{minute}
    // We need to construct the key based on the notification type/components
    String key;
    if (notification.matchComponents == DateTimeComponents.dayOfMonthAndTime) {
      key =
          'M${notification.time.day}/${notification.time.hour}:${notification.time.minute}';
    } else if (notification.matchComponents ==
        DateTimeComponents.dayOfWeekAndTime) {
      key =
          '${notification.time.weekday}/${notification.time.hour}:${notification.time.minute}';
    } else {
      key = '${notification.time.hour}:${notification.time.minute}';
    }

    NotificationModel? existingNotification = box.get(key);

    late final NotificationModel finalNotification;

    if (existingNotification != null) {
      // Update existing
      final existingPayload = jsonDecode(existingNotification.payload!);
      final List ids = existingPayload['id']
          .split(',')
          .map((e) => e.trim()) // Handle potential spaces
          .toList();

      // Avoid duplicates
      if (!ids.contains(newId.toString())) {
        ids.add(newId.toString());
      }

      finalNotification = existingNotification.copyWith(
        title:
            '${existingNotification.title}, ${NotificationsHelper.stripPrefix(notification.title)}',
        payload: NotificationsHelper.buildPayload(
          id: ids.join(", "),
          time: '${notification.time.hour}:${notification.time.minute}',
          isGrouped: true,
        ),
      );
    } else {
      // Create new
      finalNotification = notification.copyWith(
        payload: NotificationsHelper.buildPayload(
          id: '$newId',
          time: '${notification.time.hour}:${notification.time.minute}',
          isGrouped: true,
        ),
      );
    }

    await box.put(key, finalNotification);
    return finalNotification;
  }

  /// Saves an individual notification to Hive.
  /// Appends the notification to the list for the given medication ID.
  static Future<void> saveIndividualNotification({
    required NotificationModel notification,
    required int medicationId,
  }) async {
    if (!Hive.isBoxOpen('notifications')) {
      await Hive.openBox<NotificationList>('notifications');
    }
    final Box box = Hive.box<NotificationList>('notifications');

    final NotificationList notifications =
        box.get(medicationId) ?? NotificationList(items: []);

    notifications.items.add(notification);
    await box.put(medicationId, notifications);
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

  /// a useless function to keep the import from getting tree shaken
  void uselessFunction() {
    nothing();
  }
}
