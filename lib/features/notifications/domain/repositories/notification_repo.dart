import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:pills_reminder/core/models/notification_model.dart';
import 'package:pills_reminder/core/models/notification_type.dart';
import 'package:pills_reminder/core/models/weekday.dart';
import 'package:pills_reminder/features/medications/data/models/medication_model.dart';

abstract class NotificationRepo {
  Future<void> initNotificationService();
  Future<void> requestNotificationPermission();
  Future<void> requestExactAlarmPermission();
  Future<void> cancelNotification(int id);
  Future<void> cancelAllNotificationForMedication(MedicationModel medication);
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

  Future<void> convertNormalToGrouped({
    required Box<NotificationList> normalBox,
    required Box groupedBox,
  });

  Future<void> convertGroupedToNormal({
    required Box<NotificationList> normalBox,
    required Box groupedBox,
  });
}
