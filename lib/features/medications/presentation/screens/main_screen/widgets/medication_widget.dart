import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/core/styles/strings.dart';
import 'package:pills_reminder/core/styles/styles.dart';
import 'package:pills_reminder/features/medications/domain/entities/medication.dart';
import 'package:pills_reminder/features/medications/presentation/controllers/medications_controller.dart';
import 'package:pills_reminder/features/medications/presentation/screens/medication_scren/medication_screen.dart';

class MedicationWidget extends StatelessWidget {
  final Medication medication;
  const MedicationWidget({super.key, required this.medication});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () async {
        final model = await Get.find<MedicationController>().getMedication(
          medication.id,
        );
        if (context.mounted) {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => MedicationScreen(medication: model),
          );
        }
      },
      child: Card(
        elevation: 0,
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
      ),
    );
  }
}
