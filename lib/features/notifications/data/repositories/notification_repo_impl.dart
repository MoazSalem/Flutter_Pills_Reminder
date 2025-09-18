import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pills_reminder/core/models/notification_model.dart';
import 'package:pills_reminder/core/models/notification_type.dart';
import 'package:pills_reminder/core/models/weekday.dart';
import 'package:pills_reminder/core/utils/notifications_helper.dart';
import 'package:pills_reminder/features/medications/data/models/medication_model.dart';
import 'package:pills_reminder/features/notifications/data/services/notification_service_impl.dart';
import 'package:pills_reminder/features/notifications/domain/repositories/notification_repo.dart';
import 'package:pills_reminder/features/notifications/domain/services/notification_service.dart';
import 'package:pills_reminder/features/notifications/entrypoints/notification_background_handler.dart';
import 'package:pills_reminder/features/settings/presentation/controllers/settings_controller.dart';

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
  Future<void> cancelAllNotificationForMedication(
    MedicationModel medication,
  ) async {
    final isGrouped = Get.find<SettingsController>().groupedNotifications.value;
    if (isGrouped) {
      Box box = Hive.box('groupedNotifications');
      // loop through all the notifications, and check if the medication id is in the notifications payload, not the best way but its the easiest way with current implementation
      for (NotificationModel notification in box.values) {
        final payloadMap = jsonDecode(notification.payload!);
        final List ids = payloadMap['id']
            .split(',')
            .map((e) => e.trim())
            .toList();
        if (ids.contains(medication.id.toString())) {
          // get the key of the notification to schedule it again
          final key = NotificationsHelper.findKeyByValue(box, notification);
          // make a new notification with the updated payload that removes the old medication id, and the name from the title
          final updatedNotification = notification.copyWith(
            title: NotificationsHelper.removeWithPrefix(
              notification.title,
              medication.name,
              ", ",
              NotificationsHelper.getTitlePrefix(
                locale: Get.locale?.languageCode ?? '',
              ),
            ),
            payload: jsonEncode({
              "locale": Get.locale?.languageCode ?? '',
              "id": NotificationsHelper.removeFromString(
                payloadMap['id'],
                medication.id.toString(),
                ',',
              ),
              "pill time": payloadMap["pill time"],
              "is Grouped": "true",
            }),
          );
          // remove the medication id from the list
          ids.remove(medication.id.toString());
          // cancel the old notification, if it's not empty schedule it again
          await notificationService.cancelNotification(notification.id);
          if (ids.isNotEmpty) {
            await notificationService.scheduleNotification(
              notification: updatedNotification,
            );
            // update the notification in the box
            box.put(key, updatedNotification);
          } else {
            // don't schedule if the notification is empty, delete it
            box.delete(key);
          }
        }
      }
    } else {
      final id = medication.id;
      Box box = Hive.box<NotificationList>('notifications');
      NotificationList notifications =
          box.get(id) ?? NotificationList(items: []);
      for (var notification in notifications.items) {
        await notificationService.cancelNotification(notification.id);
      }
      box.delete(id);
    }
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
      medicationName: medicationName,
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
  Future<void> scheduleGroupedDailyOrWeeklyNotification({
    required int id,
    String? title,
    String? body,
    required String medicationName,
    required TimeOfDay time,
    required List<Weekday> weekdays,
    NotificationType? notificationType,
  }) async {
    await notificationService.scheduleGroupedDailyOrWeeklyNotification(
      id: id,
      title: title ?? '${"notificationTitle".tr} $medicationName',
      body: body ?? 'notificationBody'.tr,
      medicationName: medicationName,
      time: time,
      weekdays: weekdays,
      notificationType: notificationType,
    );
  }

  @override
  Future<void> rescheduleNotification({
    required NotificationModel notification,
  }) {
    return notificationService.scheduleNotification(notification: notification);
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
  Future<void> rescheduleAllNotifications({required bool isGrouped}) async {
    late final Box box;
    if (isGrouped) {
      box = Hive.box('groupedNotifications');
      final allNotifications = box.values.toList();
      allNotifications.isEmpty
          ? showSnackBar('resetNotifications'.tr, 'resetWrong'.tr)
          : {
              for (var notification in allNotifications)
                {await rescheduleNotification(notification: notification)},
              showSnackBar('resetNotifications'.tr, 'resetDone'.tr),
            };
    } else {
      box = Hive.box<NotificationList>('notifications');
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
  }

  showSnackBar(String title, String message) {
    Get.snackbar(
      duration: const Duration(seconds: 5),
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Future<void> convertNormalToGrouped({
    required Box<NotificationList> normalBox,
    required Box groupedBox,
  }) async {
    for (var notificationList in normalBox.values) {
      for (var notification in notificationList.items) {
        final payload = jsonDecode(notification.payload!);
        String specificKey;
        notification.matchComponents == DateTimeComponents.dayOfWeekAndTime
            ? specificKey = "W"
            : notification.matchComponents ==
                  DateTimeComponents.dayOfMonthAndTime
            ? specificKey = "M"
            : specificKey = '';
        final key =
            '$specificKey${notification.time.day}/${notification.time.hour}:${notification.time.second}';

        final id = int.parse(payload['id']);

        // check if a grouped notification for this time exists
        final existing = groupedBox.get(key);

        if (existing != null) {
          final existingPayload = jsonDecode(existing.payload!);
          final List ids = existingPayload['id']
              .split(',')
              .map(int.parse)
              .toList();

          if (!ids.contains(id)) {
            ids.add(id);
          }

          final updated = existing.copyWith(
            title:
                "${existing.title}, ${NotificationsHelper.stripPrefix(notification.title)}", // concat
            payload: jsonEncode({
              ...existingPayload,
              "id": ids.join(", "),
              "is Grouped": "true",
            }),
          );

          await groupedBox.put(key, updated);
        } else {
          final grouped = notification.copyWith(
            payload: jsonEncode({...payload, "is Grouped": "true"}),
          );
          await groupedBox.put(key, grouped);
        }
      }
    }
    // cancel all grouped notifications
    await notificationsPlugin.cancelAll();
    // schedule all normal notifications
    await rescheduleAllNotifications(isGrouped: true);
    // delete all normal notifications
    normalBox.clear();
    // show snackbar that the conversion is done
    showSnackBar('conversionDone'.tr, 'conversionGroupedDoneMessage'.tr);
  }

  @override
  Future<void> convertGroupedToNormal({
    required Box<NotificationList> normalBox,
    required Box groupedBox,
  }) async {
    for (NotificationModel notification in groupedBox.values) {
      final payload = jsonDecode(notification.payload!);
      final List ids = payload['id'].split(',').map(int.parse).toList();

      final titles = NotificationsHelper.stripPrefix(
        notification.title,
      ).split(',').map((t) => t.trim()).where((t) => t.isNotEmpty).toList();

      for (int i = 0; i < ids.length; i++) {
        final id = ids[i];
        final title = i < titles.length
            ? "${NotificationsHelper.getTitlePrefix(locale: Get.locale?.languageCode ?? "")} ${titles[i]}"
            : notification.title;

        final single = notification.copyWith(
          title: title,
          payload: jsonEncode({...payload, "id": "$id", "is Grouped": "false"}),
        );

        NotificationList existingList = NotificationList(items: []);
        existingList.items = normalBox.get(id)?.items ?? [];
        existingList.items.add(single);
        await normalBox.put(id, existingList);
      }
    }
    // cancel all grouped notifications
    await notificationsPlugin.cancelAll();
    // schedule all normal notifications
    await rescheduleAllNotifications(isGrouped: false);
    // delete all grouped notifications
    groupedBox.clear();
    // show snackbar that the conversion is done
    showSnackBar('conversionDone'.tr, 'conversionNormalDoneMessage'.tr);
  }
}
