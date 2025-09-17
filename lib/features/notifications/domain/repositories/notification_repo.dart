import 'package:flutter/material.dart';
import 'package:pills_reminder/core/models/notification_model.dart';
import 'package:pills_reminder/core/models/notification_type.dart';
import 'package:pills_reminder/core/models/weekday.dart';

abstract class NotificationRepo {
  Future<void> initNotificationService();
  Future<void> requestNotificationPermission();
  Future<void> requestExactAlarmPermission();
  Future<void> cancelNotification(int id);
  Future<void> cancelAllNotificationForMedication(int id);
  Future<void> normalNotification({
    required String title,
    required String body,
  });

  Future<void> scheduleNotification({
    required DateTime dateTime,
    required int id,
    String? title,
    String? body,
    required String medicationName,
    NotificationType? notificationType,
    required bool isRepeating,
  });

  Future<void> scheduleDailyOrWeeklyNotification({
    required int id,
    String? title,
    String? body,
    required String medicationName,
    required TimeOfDay time,
    required List<Weekday> weekdays,
    NotificationType? notificationType,
  });

  Future<void> scheduleGroupedDailyOrWeeklyNotification({
    required int id,
    String? title,
    String? body,
    required String medicationName,
    required TimeOfDay time,
    required List<Weekday> weekdays,
    NotificationType? notificationType,
  });

  Future<void> rescheduleNotification({
    required NotificationModel notification,
  });

  Future<void> rescheduleMedicationsNotifications({required int id});

  Future<void> rescheduleAllNotifications();
}
