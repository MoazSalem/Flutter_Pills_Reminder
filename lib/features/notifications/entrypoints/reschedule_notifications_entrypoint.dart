import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:pills_reminder/core/models/notification_model.dart';
import 'package:pills_reminder/core/utils/notifications_helper.dart';
import 'package:pills_reminder/features/medications/data/models/hive/hive_registrar.g.dart';
import 'package:timezone/data/latest.dart' as tz;

@pragma('vm:entry-point')
void rescheduleAllNotifications() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize timezones db
  tz.initializeTimeZones();

  // init Hive for the background isolate
  await Hive.initFlutter();
  Hive.registerAdapters();

  // Initialize plugin
  final plugin = FlutterLocalNotificationsPlugin();
  const androidInit = AndroidInitializationSettings('@drawable/icon');
  final initSettings = InitializationSettings(android: androidInit);
  await plugin.initialize(initSettings);

  // Get stored notifications from Hive
  Box box = await Hive.openBox<NotificationList>('notifications');
  final allNotifications = box.values.toList();

  for (var notifications in allNotifications) {
    for (var notification in notifications.items) {
      await plugin.zonedSchedule(
        notification.id,
        notification.title,
        notification.body,
        notification.time,
        NotificationsHelper.getNotificationDetails(
          locale: notification.payload,
        ),
        matchDateTimeComponents: notification.matchComponents,
        androidScheduleMode: notification.androidScheduleMode,
      );
    }
  }
  // Tell native code we’re done
  const channel = MethodChannel("boot_reschedule_channel");
  await channel.invokeMethod("rescheduleComplete");
}
