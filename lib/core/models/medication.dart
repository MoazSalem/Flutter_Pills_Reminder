import 'package:flutter/material.dart';

enum MedicationFrequency {
  daily, // every day
  daysPerWeek, // e.g. Mon, Wed, Fri
  weekly, // Once a specific day of the week
  monthly, // Once a month on specific day
}

enum Weekday { saturday, sunday, monday, tuesday, wednesday, thursday, friday }

class Medication {
  final String name;
  int? amount;
  MedicationFrequency frequency;

  /// the times the medication will be taken
  final List<TimeOfDay> times;

  /// Used if frequency is daysPerWeek or weekly
  final List<Weekday>? selectedDays;

  /// Used if frequency is monthly (e.g. 15 = 15th day of each month)
  final DateTime? monthlyDay;

  Medication({
    required this.name,
    this.amount,
    required this.times,
    required this.frequency,
    this.selectedDays,
    this.monthlyDay,
  });

  Medication copyWith({
    String? name,
    int? amount,
    List<TimeOfDay>? times,
    MedicationFrequency? frequency,
    List<Weekday>? selectedDays,
    DateTime? monthlyDay,
  }) {
    return Medication(
      name: name ?? this.name,
      amount: amount ?? this.amount,
      times: times ?? this.times,
      frequency: frequency ?? this.frequency,
      selectedDays: selectedDays ?? this.selectedDays,
      monthlyDay: monthlyDay ?? this.monthlyDay,
    );
  }
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
