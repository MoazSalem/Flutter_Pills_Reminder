import 'package:flutter/foundation.dart';
import 'package:pills_reminder/core/utils/notifications_helper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

@pragma('vm:entry-point')
void notificationBackgroundHandler(NotificationResponse response) async {
  if (response.actionId == 'remind_again') {
    final plugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@drawable/icon');

    final InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
    );
    tz.initializeTimeZones();
    await plugin.initialize(
      initSettings,
      onDidReceiveBackgroundNotificationResponse: notificationBackgroundHandler,
    );
    final String localTimeZone = await tz.FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimeZone));
    final now = DateTime.now().add(const Duration(minutes: 2));
    final tzTime = tz.TZDateTime.from(now, tz.local);
    await plugin.zonedSchedule(
      UniqueKey().hashCode,
      NotificationsHelper.getReminderTitle(locale: response.payload),
      NotificationsHelper.getReminderBody(locale: response.payload),
      tzTime,
      NotificationsHelper.getNotificationDetails(locale: response.payload),
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      payload: response.payload,
    );

    debugPrint('notification reminder set');
  }
}
