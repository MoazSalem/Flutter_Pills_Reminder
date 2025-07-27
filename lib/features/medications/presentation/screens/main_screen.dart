import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/core/styles/strings.dart';
import 'package:pills_reminder/core/styles/styles.dart';
import 'package:pills_reminder/features/medications/domain/entities/medication.dart';
import 'package:pills_reminder/features/medications/presentation/controllers/medications_controller.dart';
import 'package:pills_reminder/features/medications/presentation/widgets/fab.dart';
import 'package:pills_reminder/features/medications/presentation/widgets/medication_list.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MedicationController>();
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.surfaceContainerHigh,
      appBar: AppBar(
        title: const Text(AppStrings.appName, style: AppStyles.title),
        centerTitle: true,
        toolbarHeight: AppSizes.appBarHeight,
        backgroundColor: theme.surfaceContainerLow,
      ),
      body: Obx(() {
        final medications = controller.medications;
        return medications.isEmpty
            ? const Center(child: Text(AppStrings.noPills))
            : MedicationList(medicationList: medications);
      }),
      floatingActionButton: Fab(theme: theme),
    );
  }
}
