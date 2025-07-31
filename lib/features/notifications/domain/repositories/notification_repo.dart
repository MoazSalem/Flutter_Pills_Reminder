import 'package:flutter/material.dart';
import 'package:pills_reminder/core/models/weekday.dart';

abstract class NotificationRepo {
  Future<void> initNotificationService();
  Future<void> requestNotificationPermission();
  Future<void> cancelNotification(int id);
  Future<void> cancelAllNotificationForMedication(int id);
  Future<void> normalNotification({
    required String title,
    required String body,
  });
  Future<void> scheduleNotificationOnce({
    required DateTime dateTime,
    required int id,
    String? title,
    String? body,
    required String medicationName,
  });
  Future<void> scheduleDailyOrWeeklyNotification({
    required int id,
    String? title,
    String? body,
    required String medicationName,
    required TimeOfDay time,
    required List<Weekday> weekdays,
  });
}
