import 'package:flutter/material.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/core/styles/styles.dart';
import 'package:pills_reminder/core/widgets/custom_appbar.dart';
import 'package:pills_reminder/features/medications/data/models/medication_model.dart';
import 'package:pills_reminder/features/medications/presentation/screens/medication_screen/widgets/edit_icon.dart';
import 'package:pills_reminder/features/medications/presentation/screens/medication_screen/widgets/frequency_and_days.dart';
import 'package:pills_reminder/features/medications/presentation/screens/medication_screen/widgets/times_item.dart';

class MedicationScreen extends StatelessWidget {
  const MedicationScreen({super.key, required this.medication});
  final MedicationModel medication;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.normalPadding),
        child: SingleChildScrollView(
          child: Column(
            spacing: AppSizes.tinyPadding,
            children: [
              CustomAppbar(action: EditIcon(medication: medication)),

              /// Medication name
              Text(
                medication.name,
                style: AppStyles.title.copyWith(
                  fontSize: AppSizes.extraLargeTextSize,
                ),
              ),

              /// Medication amount
              Text(
                "Pills Left: ${medication.amount}",
                style: AppStyles.subTitle.copyWith(
                  color: theme.onPrimaryContainer,
                ),
              ),

              /// Frequency and days
              FrequencyAndDays(medication: medication),

              if (medication.selectedDays == null)
                SizedBox(height: AppSizes.normalPadding),

              /// Times pills are taken
              ...List.generate(
                medication.times.length,
                (i) => TimesItem(index: i, medication: medication),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
