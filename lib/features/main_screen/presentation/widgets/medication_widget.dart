import 'package:flutter/material.dart';
import 'package:pills_reminder/core/models/medication.dart';

class MedicationWidget extends StatelessWidget {
  final Medication medication;
  const MedicationWidget({super.key, required this.medication});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Text(medication.name),
                const Spacer(),
                if (medication.amount != null)
                  Text('Remaining Pills: ${medication.amount}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
