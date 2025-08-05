import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/core/styles/strings.dart';
import 'package:pills_reminder/core/styles/styles.dart';
import 'package:pills_reminder/features/medications/presentation/controllers/medications_controller.dart';
import 'package:pills_reminder/features/medications/presentation/screens/main_screen/widgets/fab.dart';
import 'package:pills_reminder/features/medications/presentation/screens/main_screen/widgets/medication_list.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MedicationController>();
    final theme = Theme.of(context);

    return Obx(() {
      if (!controller.isReady.value) {
        return CircularProgressIndicator();
      }
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: theme.colorScheme.surface,
          systemNavigationBarIconBrightness: theme.brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
        ),
        child: Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.normalPadding,
              ),
              child: Text(
                AppStrings.appName,
                style: AppStyles.title.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontSize: AppSizes.titleTextSize,
                ),
              ),
            ),
            centerTitle: false,
            toolbarHeight: AppSizes.appBarHeight,
          ),
          body: Obx(() {
            final medications = controller.medications;
            return medications.isEmpty
                ? const Center(child: Text(AppStrings.noPills))
                : MedicationList(medicationList: medications);
          }),
          floatingActionButton: Fab(theme: theme.colorScheme),
        ),
      );
    });
  }
}
