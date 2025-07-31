import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:pills_reminder/core/models/medication_frequency.dart';
import 'package:pills_reminder/core/models/notification_type.dart';
import 'package:pills_reminder/core/models/weekday.dart';
import 'package:pills_reminder/features/medications/domain/entities/medication.dart';

class MedicationModel extends HiveObject {
  final int id;
  final String name;
  int? amount;
  MedicationFrequency frequency;

  /// the times the medication will be taken
  final List<TimeOfDay> times;

  final List<bool> timesPillTaken;

  /// Used if frequency is daysPerWeek or weekly
  final List<Weekday>? selectedDays;

  /// Used if frequency is monthly (e.g. 15 = 15th day of each month)
  final DateTime? monthlyDay;

  final NotificationType? notificationType;

  MedicationModel({
    required this.id,
    required this.name,
    this.amount,
    required this.times,
    required this.timesPillTaken,
    required this.frequency,
    this.selectedDays,
    this.monthlyDay,
    this.notificationType,
  });

  MedicationModel copyWith({
    String? name,
    int? amount,
    List<TimeOfDay>? times,
    List<bool>? timesPillTaken,
    MedicationFrequency? frequency,
    List<Weekday>? selectedDays,
    DateTime? monthlyDay,
    NotificationType? notificationType,
  }) {
    return MedicationModel(
      id: id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      times: times ?? this.times,
      timesPillTaken: timesPillTaken ?? this.timesPillTaken,
      frequency: frequency ?? this.frequency,
      selectedDays: selectedDays ?? this.selectedDays,
      monthlyDay: monthlyDay ?? this.monthlyDay,
      notificationType: notificationType ?? this.notificationType,
    );
  }

  Medication toEntity() => Medication(id: id, name: name, amount: amount);
}
