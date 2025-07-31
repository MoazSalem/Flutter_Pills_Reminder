import 'package:flutter/material.dart';
import 'package:pills_reminder/core/models/medication_frequency.dart';
import 'package:pills_reminder/core/models/weekday.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/core/styles/styles.dart';
import 'package:pills_reminder/features/medications/data/models/medication_model.dart';

class FrequencyAndDays extends StatelessWidget {
  const FrequencyAndDays({super.key, required this.medication});
  final MedicationModel medication;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(AppSizes.normalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: AppSizes.tinyPadding,
        children: [
          if (medication.frequency != MedicationFrequency.daysPerWeek)
            Chip(
              label: Text(
                "${frequencies[medication.frequency]!}${medication.frequency == MedicationFrequency.once ? " On Day ${medication.monthlyDay!.day}" : ''}",
                style: AppStyles.subTitle.copyWith(
                  color: theme.onPrimaryContainer,
                ),
              ),
              backgroundColor: theme.primaryContainer,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSizes.roundedRadius),
              ),
            ),
          if (medication.selectedDays != null)
            ...List.generate(
              medication.selectedDays!.length,
              (i) => Chip(
                label: Text(
                  medication.selectedDays![i].label,
                  style: AppStyles.subTitle.copyWith(
                    color: theme.onPrimaryContainer,
                  ),
                ),
                backgroundColor: theme.primaryContainer,
                side: BorderSide.none,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.roundedRadius),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
