import 'package:flutter/material.dart';
import 'package:pills_reminder/core/models/medication.dart';
import 'package:pills_reminder/features/main_screen/presentation/widgets/medication_widget.dart';

class MedicationList extends StatelessWidget {
  final List<Medication> medicationList;
  const MedicationList({super.key, required this.medicationList});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: medicationList.length,
        itemBuilder: (context, index) =>
            MedicationWidget(medication: medicationList[index]),
      ),
    );
  }
}
