import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/features/medications/presentation/controllers/medications_controller.dart';
import 'package:pills_reminder/features/medications/presentation/screens/main_screen/widgets/medication_list.dart';

class MedicationsTab extends StatelessWidget {
  final MedicationController controller;
  const MedicationsTab({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final medications = controller.medications;
      return medications.isEmpty
          ? Center(child: Text('noPills'.tr))
          : MedicationList(medicationList: medications);
    });
  }
}
