import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:pills_reminder/core/utils/notification_manager.dart';
import 'package:pills_reminder/features/medications/data/models/hive/hive_registrar.g.dart';

@pragma('vm:entry-point')
void rescheduleAllNotifications() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init Hive for the background isolate
  await Hive.initFlutter();
  Hive.registerAdapters();

  // Initialize plugin
  final plugin = await NotificationManager.initPlugin();

  // Get stored notifications from Hive (handling both grouped and individual)
  final allNotifications = await NotificationManager.getAllNotifications();

  for (var notification in allNotifications) {
    await NotificationManager.scheduleNotification(
      plugin: plugin,
      notification: notification,
    );
  }
  // Tell native code we’re done
  const channel = MethodChannel("boot_reschedule_channel");
  await channel.invokeMethod("rescheduleComplete");
}
