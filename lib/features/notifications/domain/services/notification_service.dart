import 'package:flutter/material.dart';
import 'package:pills_reminder/core/models/notification_type.dart';
import 'package:pills_reminder/core/models/weekday.dart';

abstract class NotificationService {
  Future<void> normalNotification({
    required String title,
    required String body,
  });

  Future<void> scheduleMedicationNotificationOnce({
    required int id,
    String? title,
    required String body,
    required DateTime dateTime,
    NotificationType? notificationType,
  });

  Future<void> scheduleDailyOrWeeklyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
    required List<Weekday> weekdays,
    NotificationType? notificationType,
  });

  Future<void> cancelNotification(int id);
}
