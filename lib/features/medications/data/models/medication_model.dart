import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:pills_reminder/core/utils/helpers.dart';
import 'package:pills_reminder/features/medications/domain/entities/medication.dart';

class MedicationModel extends HiveObject {
  final String id;
  final String name;
  int? amount;
  MedicationFrequency frequency;

  /// the times the medication will be taken
  final List<TimeOfDay> times;

  /// Used if frequency is daysPerWeek or weekly
  final List<Weekday>? selectedDays;

  /// Used if frequency is monthly (e.g. 15 = 15th day of each month)
  final DateTime? monthlyDay;

  MedicationModel({
    required this.id,
    required this.name,
    this.amount,
    required this.times,
    required this.frequency,
    this.selectedDays,
    this.monthlyDay,
  });

  MedicationModel copyWith({
    String? name,
    int? amount,
    List<TimeOfDay>? times,
    MedicationFrequency? frequency,
    List<Weekday>? selectedDays,
    DateTime? monthlyDay,
  }) {
    return MedicationModel(
      id: id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      times: times ?? this.times,
      frequency: frequency ?? this.frequency,
      selectedDays: selectedDays ?? this.selectedDays,
      monthlyDay: monthlyDay ?? this.monthlyDay,
    );
  }

  Medication toEntity() => Medication(id: id, name: name, amount: amount);
}
