import 'package:flutter/material.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/core/styles/styles.dart';
import 'package:pills_reminder/features/medications/data/models/medication_model.dart';

class TimesItem extends StatelessWidget {
  const TimesItem({
    super.key,
    required this.index,
    required this.medication,
    this.onChanged,
  });
  final int index;
  final MedicationModel medication;
  final void Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSizes.tinyPadding),
      child: ListTile(
        tileColor: theme.surfaceContainer,
        contentPadding: const EdgeInsets.all(AppSizes.normalPadding),
        leading: Container(
          height: AppSizes.roundedRadius,
          width: AppSizes.roundedRadius,
          decoration: BoxDecoration(
            color: theme.primaryContainer,
            borderRadius: BorderRadius.circular(AppSizes.roundedRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                "${medication.times[index].hour.toString().padLeft(2, '0')}:${medication.times[index].minute.toString().padLeft(2, '0')}",
                style: TextStyle(fontSize: 14, color: theme.onPrimaryContainer),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        title: Text(
          medication.timesPillTaken[index] ? "Taken" : "Not Taken",
          style: AppStyles.subTitle.copyWith(
            fontSize: AppSizes.normalTextSize,
            fontFamily: 'Gambarino',
          ),
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSizes.roundedRadius),
        ),
        trailing: Checkbox(
          value: medication.timesPillTaken[index],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
