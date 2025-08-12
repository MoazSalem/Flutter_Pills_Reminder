import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pills_reminder/core/models/notification_model.dart';
import 'package:pills_reminder/features/medications/data/models/hive/hive_registrar.g.dart';
import 'package:pills_reminder/features/notifications/data/services/notification_service_impl.dart';

@pragma('vm:entry-point')
void rescheduleAllNotifications() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Init Hive for the background isolate
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapters();
  // Initialize plugin
  final plugin = FlutterLocalNotificationsPlugin();
  const androidInit = AndroidInitializationSettings('@drawable/icon');
  final initSettings = InitializationSettings(android: androidInit);
  await plugin.initialize(initSettings);

  // Get stored notifications from Hive
  final box = await Hive.openBox<NotificationModel>('notifications');
  for (NotificationModel notif in box.values) {
    await plugin.zonedSchedule(
      notif.id,
      notif.title,
      notif.body,
      notif.time,
      NotificationServiceImpl.details,
      matchDateTimeComponents: notif.matchComponents,
      androidScheduleMode: notif.androidScheduleMode,
    );
  }
  // Tell native code we’re done
  const channel = MethodChannel("boot_reschedule_channel");
  await channel.invokeMethod("rescheduleComplete");
}
