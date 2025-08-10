import 'package:get/get_navigation/src/root/internacionalization.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': {
      'appName': 'Pills Reminder',
      'noPills': 'No Pills Scheduled for Reminder',
      'remaining': 'Remaining Pills:',
      'settings': 'Settings',
      'daily': 'Daily',
      'specificDays': 'Specific Days',
      'once': 'Once',
      'onDay': 'On Day',
      'taken': 'Taken',
      'notTaken': 'Not Taken',
      'medicationName': 'Medication Name',
      'medicationNameHint': 'Please Enter a Name',
      'pAmount': 'Pills Amount (Optional)',
      'pAmountHint': 'Please enter a valid number',
      'frequency': 'Frequency',
      'date': 'Date',
      'selectDate': 'Select Date',
      'toPill': 'Time of Pill',
      'notSet': 'Not Set',
      'timesHint': 'Please Select Time',
      'repeat': 'Amount of Pills Per Day',
      'notificationType': 'Notification Type',
      'inexact': 'Inexact',
      'inexactDescription':
          'Shows notification at roughly specified time, might not work on devices with heavy battery optimizations',
      'exact': 'Exact',
      'exactDescription':
          'Shows notification at exact time, might not work on devices with heavy battery optimizations',
      'alarmClock': 'Alarm Clock',
      'alarmClockDescription':
          'The best option. Shows notification at exact time, Use on devices with heavy battery optimizations like Samsung',
      'sat': 'Sat',
      'sun': 'Sun',
      'mon': 'Mon',
      'tue': 'Tue',
      'wed': 'Wed',
      'thu': 'Thu',
      'fri': 'Fri',
      'themeMode': 'Theme Mode',
      'followSystem': 'Follow System',
      'light': 'Light',
      'dark': 'Dark',
      'appsTheme': 'Apps Theme',
      'permissionDenied': 'Permission Denied',
      'notificationsWillNotWork':
          'Notifications will not work until permission is granted.',
      'openSettings': 'Open Settings',
      'notificationTitle': 'Take Your ',
      'notificationBody': 'Time to take your pill',
      'reminder': 'Reminder',
      'reminderDescription':
          '30 minutes has passed. It\'s time to take your medication! ',
      'remindAgain': 'Remind Again in 30 minutes',
    },
  };
}
