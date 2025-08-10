import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
part 'weekday.g.dart';

@HiveType(typeId: 3)
enum Weekday {
  @HiveField(0)
  saturday,
  @HiveField(1)
  sunday,
  @HiveField(2)
  monday,
  @HiveField(3)
  tuesday,
  @HiveField(4)
  wednesday,
  @HiveField(5)
  thursday,
  @HiveField(6)
  friday,
}

extension WeekdayExtension on Weekday {
  String get label {
    switch (this) {
      case Weekday.saturday:
        return 'sat'.tr;
      case Weekday.sunday:
        return 'sun'.tr;
      case Weekday.monday:
        return 'mon'.tr;
      case Weekday.tuesday:
        return 'tue'.tr;
      case Weekday.wednesday:
        return 'wed'.tr;
      case Weekday.thursday:
        return 'thu'.tr;
      case Weekday.friday:
        return 'fri'.tr;
    }
  }
}
