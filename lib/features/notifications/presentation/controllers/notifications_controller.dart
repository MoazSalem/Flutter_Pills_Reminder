import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:pills_reminder/core/models/notification_model.dart';
import 'package:pills_reminder/core/models/notification_type.dart';
import 'package:pills_reminder/core/models/weekday.dart';
import 'package:pills_reminder/features/medications/data/models/medication_model.dart';
import 'package:pills_reminder/features/notifications/domain/repositories/notification_repo.dart';

class NotificationsController extends GetxController {
  final NotificationRepo notificationRepo;
  NotificationsController(this.notificationRepo);
  RxList<PendingNotificationRequest> notifications =
      <PendingNotificationRequest>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await notificationRepo.initNotificationService();
  }

  Future<void> getActiveNotifications() async {
    notifications.value = await notificationRepo.getPendingNotifications();
    update();
  }

  Future<void> requestNotificationPermission() async {
    await notificationRepo.requestNotificationPermission();
  }

  Future<void> requestExactAlarmPermission() async {
    await notificationRepo.requestExactAlarmPermission();
  }

  Future<void> cancelNotification(int id) async {
    await notificationRepo.cancelNotification(id);
  }

  Future<void> cancelAllNotificationForMedication(
    MedicationModel medication,
  ) async {
    await notificationRepo.cancelAllNotificationForMedication(medication);
  }

  Future<void> normalNotification({
    required String title,
    required String body,
  }) async {
    notificationRepo.normalNotification(title: title, body: body);
  }

  Future<void> scheduleNotification({
    required DateTime dateTime,
    required int id,
    String? title,
    String? body,
    required String medicationName,
    NotificationType? notificationType,
    bool isRepeating = false,
  }) async {
    notificationRepo.scheduleNotification(
      dateTime: dateTime,
      id: id,
      title: title,
      body: body,
      medicationName: medicationName,
      notificationType: notificationType,
      isRepeating: isRepeating,
    );
  }

  Future<void> scheduleDailyOrWeeklyNotification({
    required int id,
    String? title,
    String? body,
    required String medicationName,
    required TimeOfDay time,
    required List<Weekday> weekdays,
    NotificationType? notificationType,
  }) async {
    notificationRepo.scheduleDailyOrWeeklyNotification(
      id: id,
      title: title,
      body: body,
      medicationName: medicationName,
      time: time,
      weekdays: weekdays,
      notificationType: notificationType,
    );
  }

  Future<void> scheduleGroupedDailyOrWeeklyNotification({
    required int id,
    String? title,
    String? body,
    required String medicationName,
    required TimeOfDay time,
    required List<Weekday> weekdays,
    NotificationType? notificationType,
  }) async {
    notificationRepo.scheduleGroupedDailyOrWeeklyNotification(
      id: id,
      title: title,
      body: body,
      medicationName: medicationName,
      time: time,
      weekdays: weekdays,
      notificationType: notificationType,
    );
  }

  Future<void> rescheduleNotification({
    required NotificationModel notification,
  }) async {
    notificationRepo.rescheduleNotification(notification: notification);
  }

  Future<void> rescheduleMedicationsNotifications({required int id}) async {
    notificationRepo.rescheduleMedicationsNotifications(id: id);
  }

  Future<void> rescheduleAllNotifications(bool isGrouped) async {
    notificationRepo.rescheduleAllNotifications(isGrouped: isGrouped);
  }

  Future<void> convertNormalToGrouped({
    required Box<NotificationList> normalBox,
    required Box groupedBox,
  }) async {
    notificationRepo.convertNormalToGrouped(
      normalBox: normalBox,
      groupedBox: groupedBox,
    );
  }

  Future<void> convertGroupedToNormal({
    required Box<NotificationList> normalBox,
    required Box groupedBox,
  }) async {
    notificationRepo.convertGroupedToNormal(
      normalBox: normalBox,
      groupedBox: groupedBox,
    );
  }
}
