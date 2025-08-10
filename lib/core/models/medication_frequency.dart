import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
part 'medication_frequency.g.dart';

@HiveType(typeId: 2)
enum MedicationFrequency {
  @HiveField(0)
  daily, // every day
  @HiveField(1)
  daysPerWeek, // e.g. Mon, Wed, Fri
  @HiveField(2)
  once, // Once a month on specific day
}

Map<MedicationFrequency, String> frequencies = {
  MedicationFrequency.daily: 'daily'.tr,
  MedicationFrequency.daysPerWeek: 'specificDays'.tr,
  MedicationFrequency.once: 'once'.tr,
};
