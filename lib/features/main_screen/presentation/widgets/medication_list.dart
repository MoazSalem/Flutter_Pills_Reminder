import 'package:flutter/material.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/features/main_screen/domain/entites/medication.dart';
import 'package:pills_reminder/features/main_screen/presentation/widgets/medication_widget.dart';

class MedicationList extends StatelessWidget {
  final List<Medication> medicationList;
  const MedicationList({super.key, required this.medicationList});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.largePadding),
      child: ListView.builder(
        itemCount: medicationList.length,
        itemBuilder: (context, index) =>
            MedicationWidget(medication: medicationList[index]),
      ),
    );
  }
}
