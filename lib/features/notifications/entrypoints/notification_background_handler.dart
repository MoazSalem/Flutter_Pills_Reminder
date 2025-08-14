import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:pills_reminder/core/utils/notifications_helper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart' as tz;
import 'package:pills_reminder/features/medications/data/models/hive/hive_registrar.g.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

@pragma('vm:entry-point')
void notificationBackgroundHandler(NotificationResponse response) async {
  if (response.actionId == 'remind_again') {
    /// init FlutterLocalNotificationsPlugin
    final plugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@drawable/icon');
    final InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
    );
    await plugin.initialize(
      initSettings,
      onDidReceiveBackgroundNotificationResponse: notificationBackgroundHandler,
    );
    tz.initializeTimeZones();
    final String localTimeZone = await tz.FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimeZone));
    final now = DateTime.now().add(const Duration(minutes: 2));
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
      payload: locale,
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

    /// get medication
    final medication = box.get(int.parse(data['id']));

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
      int.parse(data['id']),
      medication.copyWith(amount: amount, timesPillTaken: timesPillTaken),
    );
  }
}
