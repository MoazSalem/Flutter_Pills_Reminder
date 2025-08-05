import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/core/styles/strings.dart';
import 'package:pills_reminder/core/styles/styles.dart';
import 'package:pills_reminder/features/medications/domain/entities/medication.dart';
import 'package:pills_reminder/features/medications/presentation/controllers/medications_controller.dart';
import 'package:pills_reminder/features/medications/presentation/screens/medication_screen/medication_screen.dart';

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
        color: theme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.pillHeight),
          side: BorderSide(
            color: theme.primaryFixedDim,
            width: AppSizes.borderWidth,
          ),
        ),
        child: SizedBox(
          height: AppSizes.pillHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                medication.name,
                style: AppStyles.title.copyWith(
                  color: theme.onPrimaryContainer,
                ),
              ),
              if (medication.amount != null)
                Text(
                  '${AppStrings.remaining} ${medication.amount}',
                  style: AppStyles.subTitle,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
