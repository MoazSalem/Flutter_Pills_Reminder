import 'package:flutter/material.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/features/medications/data/models/medication_model.dart';
import 'package:pills_reminder/features/medications/presentation/screens/edit_medication_screen/edit_medication_screen.dart';

class EditIcon extends StatelessWidget {
  const EditIcon({super.key, required this.medication});
  final MedicationModel medication;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () {
        /// Edit medication screen
        showModalBottomSheet(
          isScrollControlled: true,
          context: context,
          builder: (context) => EditMedicationScreen(medication: medication),
        );
      },
      borderRadius: BorderRadius.circular(AppSizes.circularRadius),
      child: Ink(
        height: AppSizes.roundedRadius,
        width: AppSizes.roundedRadius,
        decoration: BoxDecoration(
          color: theme.primaryContainer,
          borderRadius: BorderRadius.circular(AppSizes.circularRadius),
        ),
        child: Center(
          child: Icon(
            Icons.edit,
            size: AppSizes.normalIconSize,
            color: theme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }
}
