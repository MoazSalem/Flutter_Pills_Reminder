import 'package:flutter/material.dart';
import 'package:pills_reminder/core/models/weekday.dart';
import 'package:timezone/timezone.dart' as tz;

class TzDateHelper {
  /// Helper function to get the next notification time
  static tz.TZDateTime nextInstanceOfTime(TimeOfDay time) {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  /// Helper function to get the notifications for each weekday
  static tz.TZDateTime nextInstanceOfDayAndTime(
    Weekday weekday,
    TimeOfDay time,
  ) {
    tz.TZDateTime scheduled = nextInstanceOfTime(time);
    while (timeZonesDayToWeekday(scheduled.weekday) != weekday) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
