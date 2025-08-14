import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsHelper {
  static NotificationDetails getNotificationDetails({String? locale}) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'medications_channel',
        'Medications Notifications',
        channelDescription: 'medication reminders',
        importance: Importance.max,
        priority: Priority.high,
        actions: [
          AndroidNotificationAction(
            'mark_done',
            locale == 'ar' ? 'تم التناول' : 'Mark as taken',
            showsUserInterface: false,
            cancelNotification: true,
          ),
          AndroidNotificationAction(
            'remind_again',
            locale == 'ar' ? 'ذكّرني بعد 30 دقيقة' : 'Remind me in 30 minutes',
            showsUserInterface: false,
            cancelNotification: true,
          ),
        ],
        playSound: true,
        sound: RawResourceAndroidNotificationSound('notification_sound'),
      ),
    );
  }

  static String getReminderTitle({String? locale}) {
    return locale == 'ar' ? 'تذكير' : 'Reminder';
  }

  static String getReminderBody({String? locale}) {
    return locale == 'ar'
        ? 'مرّت 30 دقيقة. حان وقت تناول دوائك!'
        : '30 minutes has passed. It\'s time to take your medication! ';
  }
}
