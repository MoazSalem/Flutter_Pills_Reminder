import 'package:flutter/material.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/core/styles/strings.dart';
import 'package:pills_reminder/core/styles/styles.dart';
import 'package:pills_reminder/features/main_screen/domain/entites/medication.dart';
import 'package:pills_reminder/features/main_screen/presentation/widgets/fab.dart';
import 'package:pills_reminder/features/main_screen/presentation/widgets/medication_list.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final List<Medication> tempList = [];
    return Scaffold(
      backgroundColor: theme.surfaceContainerHigh,
      appBar: AppBar(
        title: const Text(AppStrings.appName, style: AppStyles.title),
        centerTitle: true,
        toolbarHeight: AppSizes.appBarHeight,
        backgroundColor: theme.surfaceContainerLow,
      ),
      body: tempList.isEmpty
          ? const Center(child: Text(AppStrings.noPills))
          : MedicationList(medicationList: tempList),
      floatingActionButton: Fab(theme: theme),
    );
  }
}
