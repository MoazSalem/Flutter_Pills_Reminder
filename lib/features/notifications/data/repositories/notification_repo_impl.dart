import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:pills_reminder/core/models/notification_type.dart';
import 'package:pills_reminder/core/models/weekday.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pills_reminder/features/medications/presentation/controllers/medications_controller.dart';
import 'package:pills_reminder/features/notifications/data/services/notification_service_impl.dart';
import 'package:pills_reminder/features/notifications/domain/repositories/notification_repo.dart';
import 'package:pills_reminder/features/notifications/domain/services/notification_service.dart';
import 'package:timezone/timezone.dart' as tz;

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
      onDidReceiveNotificationResponse: (response) async {
        if (response.notificationResponseType ==
            NotificationResponseType.selectedNotificationAction) {
          final medicationController = Get.find<MedicationController>();
          final String actionId = response.actionId!;
          final data = jsonDecode(response.payload!);
          // Reschedule in 30 minutes
          if (actionId == 'remind_again') {
            await reschedule(
              data: data,
              medicationController: medicationController,
              notificationService: notificationService,
            );
          }
          // Mark the medication as taken and decrement the count by 1
          else if (actionId == 'mark_as_done') {
            await markAsDone(
              data: data,
              medicationController: medicationController,
            );
          }
        }
      },
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
        'Permission Denied',
        'Notifications will not work until permission is granted.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        mainButton: TextButton(
          onPressed: () {
            openAppSettings();
          },
          child: Text(
            'Open Settings',
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
    var box = await Hive.openBox('notificationsIds');
    var ids = box.get(id) ?? [];
    for (var id in ids) {
      await notificationService.cancelNotification(id);
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
    await requestNotificationPermission();
    if (Platform.isAndroid && notificationType != NotificationType.inexact) {
      await requestExactAlarmPermission();
    }
    await notificationService.scheduleMedicationNotification(
      id: id,
      title: title ?? 'Take Your $medicationName',
      body: body ?? 'Time to take your pill',
      dateTime: dateTime,
      notificationType: notificationType,
      isRepeating: isRepeating,
    );
    debugPrint("Notification scheduled with id $id at $dateTime");
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
    await requestNotificationPermission();
    if (Platform.isAndroid && notificationType != NotificationType.inexact) {
      await requestExactAlarmPermission();
    }
    await notificationService.scheduleDailyOrWeeklyNotification(
      id: id,
      title: title ?? 'Take Your $medicationName',
      body: body ?? 'Time to take your pill',
      time: time,
      weekdays: weekdays,
      notificationType: notificationType,
    );
    debugPrint(
      "Weekly Notification scheduled with id $id at $time at $weekdays",
    );
  }
}

Future<void> reschedule({
  required data,
  required MedicationController medicationController,
  required NotificationService notificationService,
}) async {
  final newTime = tz.TZDateTime.now(tz.local).add(const Duration(minutes: 30));
  final int id = data['id'] ?? 600;
  final medication = await medicationController.getMedication(id);

  await notificationService.scheduleMedicationNotification(
    id: id + 60302, // use a different ID to avoid conflicts
    title: 'Reminder for ${medication.name}',
    body: 'please take your pill 30 minutes has passed.',
    dateTime: newTime,
    notificationType: medication.notificationType,
    isRepeating: false,
  );
}

Future<void> markAsDone({required data, required medicationController}) async {
  final int id = data['id'] ?? 700;
  final time = TimeOfDay(
    hour: int.parse(data['pill time'].split(':')[0]),
    minute: int.parse(data['pill time'].split(':')[1]),
  );
  final medication = await medicationController.getMedication(id);
  final timesPillTaken = List.generate(medication.times.length, (i) {
    if (medication.times[i] == time) {
      return true;
    } else {
      return false;
    }
  });
  medicationController.updateMedication(
    medication.copyWith(
      amount: medication.amount != null && medication.amount! > 0
          ? medication.amount! - 1
          : null,
      timesPillTaken: timesPillTaken,
    ),
  );
}
