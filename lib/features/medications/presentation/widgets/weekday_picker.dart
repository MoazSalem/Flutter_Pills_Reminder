import 'package:flutter/material.dart';
import 'package:pills_reminder/core/models/medication.dart';
import 'package:pills_reminder/core/styles/sizes.dart';

class WeekdayPicker extends StatelessWidget {
  final Map<Weekday, bool> days;
  final void Function(Weekday, bool) onChanged;
  final MedicationFrequency frequency;

  const WeekdayPicker({
    super.key,
    required this.days,
    required this.onChanged,
    required this.frequency,
  });

  @override
  Widget build(BuildContext context) {
    final isSingleSelection = frequency == MedicationFrequency.weekly;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.largePadding),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 16,
        children: Weekday.values.map((day) {
          final selected = days[day] ?? false;

          return FilterChip(
            label: Text(day.label),
            selected: selected,
            onSelected: (bool value) {
              if (isSingleSelection) {
                // Clear all, select only this one
                for (final key in days.keys) {
                  days[key] = false;
                }
                onChanged(day, true);
              } else {
                onChanged(day, value);
              }
            },
          );
        }).toList(),
      ),
    );
  }
}
