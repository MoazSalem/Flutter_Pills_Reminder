import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:pills_reminder/core/models/notification_model.dart';
import 'package:pills_reminder/core/models/notification_type.dart';
import 'package:pills_reminder/core/models/weekday.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pills_reminder/features/notifications/data/services/notification_service_impl.dart';
import 'package:pills_reminder/features/notifications/domain/repositories/notification_repo.dart';
import 'package:pills_reminder/features/notifications/domain/services/notification_service.dart';
import 'package:pills_reminder/features/notifications/entrypoints/notification_background_handler.dart';

class NotificationRepoImpl implements NotificationRepo {
  bool isNotificationPermissionGranted = false;
  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  late final NotificationService notificationService;

  @override
  Future<void> initNotificationService() async {
    // Ensure plugin is initialized
    await notificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@drawable/icon'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveBackgroundNotificationResponse: notificationBackgroundHandler,
    );
    notificationService = NotificationServiceImpl(notificationsPlugin);
  }

  @override
  Future<void> requestNotificationPermission() async {
    if (isNotificationPermissionGranted) {
      return Future.value();
    }
    isNotificationPermissionGranted = true;
    final status = await Permission.notification.request();

    if (!status.isGranted) {
      isNotificationPermissionGranted = false;
      Get.snackbar(
        duration: const Duration(seconds: 5),
        'permissionDenied'.tr,
        'notificationsWillNotWork'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        mainButton: TextButton(
          onPressed: () {
            openAppSettings();
          },
          child: Text(
            'openSettings'.tr,
            style: TextStyle(color: Get.theme.colorScheme.onError),
          ),
        ),
      );
    }
  }

  @override
  Future<void> requestExactAlarmPermission() async {
    await notificationService.requestExactAlarmPermission();
  }

  @override
  Future<void> cancelNotification(int id) async {
    await notificationService.cancelNotification(id);
  }

  @override
  Future<void> cancelAllNotificationForMedication(int id) async {
    Box box = Hive.box<NotificationList>('notifications');
    NotificationList notifications = box.get(id) ?? NotificationList(items: []);
    for (var notification in notifications.items) {
      await notificationService.cancelNotification(notification.id);
    }
    box.delete(id);
  }

  @override
  Future<void> normalNotification({
    required String title,
    required String body,
  }) async {
    await requestNotificationPermission();
    await notificationService.normalNotification(title: title, body: body);
  }

  @override
  Future<void> scheduleNotification({
    required DateTime dateTime,
    required int id,
    String? title,
    String? body,
    required String medicationName,
    NotificationType? notificationType,
    required bool isRepeating,
  }) async {
    await notificationService.scheduleMedicationNotification(
      id: id,
      title: title ?? '${'notificationTitle'.tr} $medicationName',
      body: body ?? 'notificationBody'.tr,
      dateTime: dateTime,
      notificationType: notificationType,
      isRepeating: isRepeating,
    );
  }

  @override
  Future<void> scheduleDailyOrWeeklyNotification({
    required int id,
    String? title,
    String? body,
    required String medicationName,
    required TimeOfDay time,
    required List<Weekday> weekdays,
    NotificationType? notificationType,
  }) async {
    await notificationService.scheduleDailyOrWeeklyNotification(
      id: id,
      title: title ?? '${"notificationTitle".tr} $medicationName',
      body: body ?? 'notificationBody'.tr,
      time: time,
      weekdays: weekdays,
      notificationType: notificationType,
    );
  }

  @override
  Future<void> rescheduleNotification({
    required NotificationModel notification,
  }) {
    return notificationService.rescheduleNotification(
      notification: notification,
    );
  }

  @override
  Future<void> rescheduleMedicationsNotifications({required int id}) async {
    Box box = Hive.box<NotificationList>('notifications');
    final NotificationList notifications =
        box.get(id) ?? NotificationList(items: []);
    notifications.items.isEmpty
        ? showSnackBar('resetNotifications'.tr, 'resetWrong'.tr)
        : {
            for (var notification in notifications.items)
              {
                await rescheduleNotification(notification: notification),
                showSnackBar('resetNotifications'.tr, 'resetDone'.tr),
              },
          };
  }

  @override
  Future<void> rescheduleAllNotifications() async {
    Box box = Hive.box<NotificationList>('notifications');
    final allNotifications = box.values.toList();
    allNotifications.isEmpty
        ? showSnackBar('resetNotifications'.tr, 'resetWrong'.tr)
        : {
            for (var notifications in allNotifications)
              {
                for (var notification in notifications.items)
                  {await rescheduleNotification(notification: notification)},
              },
            showSnackBar('resetNotifications'.tr, 'resetDone'.tr),
          };
  }

  showSnackBar(String title, String message) {
    Get.snackbar(
      duration: const Duration(seconds: 5),
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
