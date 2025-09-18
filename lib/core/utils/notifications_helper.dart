import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:pills_reminder/core/models/notification_model.dart';
import 'package:pills_reminder/core/models/notification_type.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationsHelper {
  static NotificationDetails getNotificationDetails({String? locale}) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'medications_channel',
        'Medications Notifications',
        channelDescription: 'medication reminders',
        importance: Importance.max,
        priority: Priority.high,
        actions: [
          AndroidNotificationAction(
            'mark_done',
            locale == 'ar' ? 'تم التناول' : 'Mark as taken',
            showsUserInterface: false,
            cancelNotification: true,
          ),
          AndroidNotificationAction(
            'remind_again',
            locale == 'ar' ? 'ذكّرني بعد 30 دقيقة' : 'Remind me in 30 minutes',
            showsUserInterface: false,
            cancelNotification: true,
          ),
        ],
        playSound: true,
        sound: RawResourceAndroidNotificationSound('notification_sound'),
      ),
    );
  }

  static String getReminderTitle({String? locale}) {
    return locale == 'ar' ? 'تذكير' : 'Reminder';
  }

  static String getReminderBody({String? locale}) {
    return locale == 'ar'
        ? 'مرّت 30 دقيقة. حان وقت تناول دوائك!'
        : '30 minutes has passed. It\'s time to take your medication! ';
  }

  static String getTitlePrefix({String? locale}) {
    return locale == 'ar' ? 'تناول' : 'Take Your';
  }

  static String stripPrefix(String title) {
    final prefix = NotificationsHelper.getTitlePrefix();
    if (title.startsWith(prefix)) {
      return title.substring(prefix.length).trim();
    }
    return title;
  }

  static String removeWithPrefix(
    String original,
    String toRemove,
    String separator,
    String prefix,
  ) {
    // strip prefix if present
    String withoutPrefix = original.startsWith(prefix)
        ? original.substring(prefix.length).trim()
        : original;

    // remove the item
    String cleaned = removeFromString(withoutPrefix, toRemove, separator);

    // add prefix back if there's anything left
    return cleaned.isNotEmpty ? "$prefix $cleaned" : prefix.trim();
  }

  static String removeFromString(
    String original,
    String toRemove,
    String separator,
  ) {
    // Split by comma and trim spaces
    List<String> list = original.split(separator).map((e) => e.trim()).toList();

    // Remove the given string
    list.removeWhere((e) => e == toRemove);

    // Rebuild into string
    return list.join(separator);
  }

  static NotificationModel buildNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime time,
    required DateTimeComponents? matchComponents,
    NotificationType? type,
    bool isGrouped = false,
    String? medicationId,
  }) {
    return NotificationModel(
      id: id,
      title: title,
      body: body,
      time: time,
      matchComponents: matchComponents,
      androidScheduleMode:
          type?.androidScheduleMode ?? AndroidScheduleMode.alarmClock,
      payload: buildPayload(
        id: medicationId ?? "$id",
        time: '${time.hour}:${time.minute}',
        isGrouped: isGrouped,
      ),
    );
  }

  static String buildPayload({
    required String id,
    required String time,
    bool isGrouped = false,
  }) {
    return jsonEncode({
      "locale": Get.locale?.languageCode ?? '',
      "id": id,
      "pill time": time,
      if (isGrouped) "is Grouped": "true",
    });
  }

  static dynamic findKeyByValue(Box box, dynamic target) {
    for (final key in box.keys) {
      if (box.get(key) == target) return key;
    }
    return null;
  }
}
