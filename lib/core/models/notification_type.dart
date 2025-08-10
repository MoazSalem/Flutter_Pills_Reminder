import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
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
        return 'inexactDescription'.tr;
      case NotificationType.exact:
        return 'exactDescription'.tr;
      case NotificationType.alarmClock:
        return 'alarmClockDescription'.tr;
    }
  }

  String get label {
    switch (this) {
      case NotificationType.inexact:
        return 'inexact'.tr;
      case NotificationType.exact:
        return 'exact'.tr;
      case NotificationType.alarmClock:
        return 'alarmClock'.tr;
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
