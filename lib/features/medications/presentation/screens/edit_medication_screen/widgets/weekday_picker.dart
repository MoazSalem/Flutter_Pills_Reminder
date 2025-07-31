import 'package:flutter/material.dart';
import 'package:pills_reminder/core/models/medication_frequency.dart';
import 'package:pills_reminder/core/models/weekday.dart';
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.largePadding),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 16,
        children: Weekday.values.map((day) {
          final selected = days[day] ?? false;
          return FilterChip(
            selectedColor: Theme.of(context).colorScheme.primaryContainer,
            label: Text(day.label),
            selected: selected,
            onSelected: (bool value) {
              onChanged(day, value);
            },
          );
        }).toList(),
      ),
    );
  }
}
