import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
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

  static String removeNameFromTitle(
    String text,
    String nameToRemove,
    String locale,
  ) {
    // Remove the prefix
    String prefix = getReminderTitle(locale: locale);
    String withoutPrefix = text.startsWith(prefix)
        ? text.substring(prefix.length)
        : text;

    // Split names by comma, trim spaces
    List<String> names = withoutPrefix.split(',').map((n) => n.trim()).toList();

    // Remove the target name (case insensitive)
    names.removeWhere((n) => n.toLowerCase() == nameToRemove.toLowerCase());

    // Rebuild the string
    return names.isEmpty
        ? prefix
              .trim() // return just "reminder for" if no names left
        : "$prefix${names.join(', ')}";
  }

  static String removeIdFromList(String ids, String idToRemove) {
    // Split by comma and trim spaces
    List<String> list = ids.split(',').map((e) => e.trim()).toList();

    // Remove the given id
    list.removeWhere((e) => e == idToRemove);

    // Rebuild into string
    return list.join(',');
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
}
