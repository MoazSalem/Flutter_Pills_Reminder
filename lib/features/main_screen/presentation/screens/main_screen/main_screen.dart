import 'package:flutter/material.dart';
import 'package:pills_reminder/core/models/medication.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/core/styles/strings.dart';
import 'package:pills_reminder/features/main_screen/presentation/widgets/medication_list.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final List<Medication> tempList = [];
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        toolbarHeight: AppSizes.appBarHeight,
        backgroundColor: theme.surfaceContainerHigh,
      ),
      body: tempList.isEmpty
          ? const Center(child: Text(AppStrings.noPills))
          : MedicationList(medicationList: tempList),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
