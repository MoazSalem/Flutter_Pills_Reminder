import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:pills_reminder/app.dart';
import 'package:pills_reminder/core/models/notification_model.dart';
import 'package:pills_reminder/features/medications/data/models/hive/hive_registrar.g.dart';
import 'package:pills_reminder/features/medications/data/models/medication_model.dart';
import 'package:pills_reminder/features/settings/presentation/controllers/settings_controller.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await Hive.initFlutter();
  Hive.registerAdapters();
  await Hive.openBox<MedicationModel>('medications');
  final settingsBox = await Hive.openBox('Settings');
  settingsBox.get('groupedNotifications', defaultValue: false)
      ? await Hive.openBox('groupedNotifications')
      : await Hive.openBox<NotificationList>('notifications');
  Get.put<SettingsController>(SettingsController(settingsBox));
  runApp(const MyApp());
}
