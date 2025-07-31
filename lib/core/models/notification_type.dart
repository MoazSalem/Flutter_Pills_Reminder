import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
part 'notification_type.g.dart';

@HiveType(typeId: 4)
enum NotificationType {
  @HiveField(0)
  inexact,
  @HiveField(1)
  exact,
  @HiveField(2)
  alarmClock,
}

extension WeekdayExtension on NotificationType {
  String get description {
    switch (this) {
      case NotificationType.inexact:
        return 'Shows notification at roughly specified time, might not work on devices with heavy battery optimizations';
      case NotificationType.exact:
        return 'Shows notification at exact time, might not work on devices with heavy battery optimizations';
      case NotificationType.alarmClock:
        return 'Shows notification at exact time, Use on devices with heavy battery optimizations';
    }
  }

  String get label {
    switch (this) {
      case NotificationType.inexact:
        return 'Inexact';
      case NotificationType.exact:
        return 'Exact';
      case NotificationType.alarmClock:
        return 'Alarm Clock';
    }
  }

  AndroidScheduleMode get androidScheduleMode {
    switch (this) {
      case NotificationType.inexact:
        return AndroidScheduleMode.inexactAllowWhileIdle;
      case NotificationType.exact:
        return AndroidScheduleMode.exactAllowWhileIdle;
      case NotificationType.alarmClock:
        return AndroidScheduleMode.exact;
    }
  }
}
