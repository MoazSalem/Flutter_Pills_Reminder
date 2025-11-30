import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:pills_reminder/core/utils/notification_manager.dart';
import 'package:pills_reminder/core/utils/notifications_helper.dart';
import 'package:pills_reminder/features/medications/data/models/hive/hive_registrar.g.dart';
import 'package:pills_reminder/features/medications/data/models/medication_model.dart';
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
void notificationBackgroundHandler(NotificationResponse response) async {
  if (response.actionId == 'remind_again') {
    /// init FlutterLocalNotificationsPlugin
    final plugin = await NotificationManager.initPlugin(
      onDidReceiveBackgroundNotificationResponse: notificationBackgroundHandler,
    );

    final now = DateTime.now().add(const Duration(minutes: 30));
    final tzTime = tz.TZDateTime.from(now, tz.local);
    final String locale = json.decode(response.payload!)['locale'];

    /// schedule notification
    await plugin.zonedSchedule(
      UniqueKey().hashCode,
      NotificationsHelper.getReminderTitle(locale: locale),
      NotificationsHelper.getReminderBody(locale: locale),
      tzTime,
      NotificationsHelper.getNotificationDetails(locale: locale),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      payload: response.payload,
    );
  }
  if (response.actionId == 'mark_done') {
    WidgetsFlutterBinding.ensureInitialized();
    final data = json.decode(response.payload!);

    /// init Hive for the background isolate
    await Hive.initFlutter();
    Hive.registerAdapters();

    /// open medications box
    Box box = await Hive.openBox('medications');

    final List ids = data['id'].split(',').map(int.parse).toList();

    /// get medications
    List<MedicationModel> medications = [];
    for (final id in ids) {
      medications.add(box.get(id));
    }

    /// update each medication
    for (final medication in medications) {
      /// decrease amount
      int? amount;
      if (medication.amount != null) {
        medication.amount! > 0 ? amount = medication.amount! - 1 : null;
      }

      /// get which pill from time in payload
      final time = TimeOfDay(
        hour: int.parse(data['pill time'].split(':')[0]),
        minute: int.parse(data['pill time'].split(':')[1]),
      );

      /// generate timesPillTaken list
      List<bool> timesPillTaken = medication.timesPillTaken;

      for (int i = 0; i < medication.times.length; i++) {
        if (medication.times[i] == time) {
          timesPillTaken[i] = true;
        }
      }

      /// update medication
      await box.put(
        medication.id,
        medication.copyWith(amount: amount, timesPillTaken: timesPillTaken),
      );
    }

    /// update last opened date
    var dateBox = await Hive.openBox('date');
    dateBox.put('lastOpenedDate', DateTime.now().weekday);

    /// check for last notification regeneration
    if (dateBox.get('lastNotificationRegenerationDate') == null) {
      /// if this is the first time this feature works, store the current date
      dateBox.put('lastNotificationRegenerationDate', DateTime.now());
    } else {
      /// check if 2 days have passed since last notification regeneration
      if (DateTime.now()
              .difference(dateBox.get('lastNotificationRegenerationDate'))
              .inDays >=
          2) {
        /// reschedule all notifications
        // init FlutterLocalNotificationsPlugin
        final plugin = await NotificationManager.initPlugin(
          onDidReceiveBackgroundNotificationResponse:
              notificationBackgroundHandler,
        );

        // Get stored notifications from Hive (handling both grouped and individual)
        final allNotifications =
            await NotificationManager.getAllNotifications();

        for (var notification in allNotifications) {
          await NotificationManager.scheduleNotification(
            plugin: plugin,
            notification: notification,
          );
        }
      } // else, do nothing
    }
    box.close();
    dateBox.close();
  }
}
