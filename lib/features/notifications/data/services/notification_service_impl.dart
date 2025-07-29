import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pills_reminder/features/notifications/domain/services/notification_service.dart';
import 'package:timezone/timezone.dart';

class NotificationServiceImpl implements NotificationService {
  final FlutterLocalNotificationsPlugin _plugin;

  NotificationServiceImpl(this._plugin);

  @override
  Future<void> scheduleMedicationNotification({
    required int id,
    required String title,
    required DateTime dateTime,
  }) async {
    await _plugin.zonedSchedule(
      id,
      'Medication Reminder',
      title,
      TZDateTime.from(dateTime.toUtc(), local),
      const NotificationDetails(
        android: AndroidNotificationDetails('med_channel', 'Medications'),
      ),
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  @override
  Future<void> normalNotification({
    required String title,
    required String body,
  }) {
    return _plugin.show(
      0,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails('med_channel', 'Medications'),
      ),
    );
  }

  @override
  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }
}
