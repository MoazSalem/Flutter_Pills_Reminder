import 'package:flutter/material.dart';
import 'package:pills_reminder/core/models/medication.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/core/styles/strings.dart';
import 'package:pills_reminder/core/styles/styles.dart';

class MedicationWidget extends StatelessWidget {
  final Medication medication;
  const MedicationWidget({super.key, required this.medication});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Card(
      color: theme.primaryContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.pillHeight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.largePadding),
        child: SizedBox(
          height: AppSizes.pillHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: AppSizes.tinyPadding,
            children: [
              Text(medication.name, style: AppStyles.title),
              if (medication.amount != null)
                Text(
                  '${AppStrings.remaining} ${medication.amount}',
                  style: AppStyles.subTitle.copyWith(
                    color: theme.onPrimaryContainer,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
