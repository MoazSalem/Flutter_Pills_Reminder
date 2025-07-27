import 'package:hive_ce_flutter/hive_flutter.dart';
part 'medication_frequency.g.dart';

@HiveType(typeId: 2)
enum MedicationFrequency {
  @HiveField(0)
  daily, // every day
  @HiveField(1)
  daysPerWeek, // e.g. Mon, Wed, Fri
  @HiveField(2)
  weekly, // Once a specific day of the week
  @HiveField(3)
  monthly, // Once a month on specific day
}
