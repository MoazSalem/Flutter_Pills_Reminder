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
        return 'Sat';
      case Weekday.sunday:
        return 'Sun';
      case Weekday.monday:
        return 'Mon';
      case Weekday.tuesday:
        return 'Tue';
      case Weekday.wednesday:
        return 'Wed';
      case Weekday.thursday:
        return 'Thu';
      case Weekday.friday:
        return 'Fri';
    }
  }
}
