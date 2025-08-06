import 'package:flutter/material.dart';
import 'package:pills_reminder/core/models/notification_type.dart';
import 'package:pills_reminder/core/models/weekday.dart';

abstract class NotificationService {
  Future<void> normalNotification({
    required String title,
    required String body,
  });

  Future<void> scheduleMedicationNotification({
    required int id,
    String? title,
    required String body,
    required DateTime dateTime,
    NotificationType? notificationType,
    required bool isRepeating,
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

  Future<void> requestExactAlarmPermission();
}
