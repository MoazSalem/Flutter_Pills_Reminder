enum MedicationFrequency { daily, weekly, monthly, coupleTimes }

enum Weekday { saturday, sunday, monday, tuesday, wednesday, thursday, friday }

class Medication {
  final String name;
  int? amount;
  List<DateTime> notificationTimes;
  MedicationFrequency frequency;
  List<Weekday>? days;

  Medication({
    required this.name,
    this.amount,
    required this.notificationTimes,
    required this.frequency,
    this.days,
  });

  Medication copyWith({
    String? name,
    int? amount,
    List<DateTime>? notificationTimes,
    MedicationFrequency? frequency,
    List<Weekday>? days,
  }) {
    return Medication(
      name: name ?? this.name,
      amount: amount ?? this.amount,
      notificationTimes: notificationTimes ?? this.notificationTimes,
      frequency: frequency ?? this.frequency,
      days: days ?? this.days,
    );
  }
}
