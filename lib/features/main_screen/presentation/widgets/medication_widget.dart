import 'package:flutter/material.dart';
import 'package:pills_reminder/core/models/medication.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/core/styles/strings.dart';

class MedicationWidget extends StatelessWidget {
  final Medication medication;
  const MedicationWidget({super.key, required this.medication});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.smallPadding),
        child: Column(
          children: [
            Row(
              children: [
                Text(medication.name),
                const Spacer(),
                if (medication.amount != null)
                  Text('${AppStrings.remaining} ${medication.amount}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
