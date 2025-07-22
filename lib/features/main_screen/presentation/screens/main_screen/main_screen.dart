import 'package:flutter/material.dart';
import 'package:pills_reminder/core/models/medication.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/core/styles/strings.dart';
import 'package:pills_reminder/core/styles/styles.dart';
import 'package:pills_reminder/features/main_screen/presentation/widgets/medication_list.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final List<Medication> tempList = [];
    return Scaffold(
      backgroundColor: theme.surfaceContainerLow,
      appBar: AppBar(
        title: const Text(AppStrings.appName, style: AppStyles.title),
        centerTitle: true,
        toolbarHeight: AppSizes.appBarHeight,
        backgroundColor: theme.surfaceContainerHighest,
      ),
      body: tempList.isEmpty
          ? const Center(child: Text(AppStrings.noPills))
          : MedicationList(medicationList: tempList),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.primaryContainer,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
