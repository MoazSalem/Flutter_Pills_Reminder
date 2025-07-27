enum MedicationFrequency {
  daily, // every day
  daysPerWeek, // e.g. Mon, Wed, Fri
  weekly, // Once a specific day of the week
  monthly, // Once a month on specific day
}

enum Weekday { saturday, sunday, monday, tuesday, wednesday, thursday, friday }

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
