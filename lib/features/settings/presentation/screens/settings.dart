import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/core/widgets/custom_drop_down.dart';
import 'package:pills_reminder/features/settings/presentation/widgets/custom_app_bar.dart';
import 'package:pills_reminder/features/settings/presentation/widgets/custom_theme_dropdown.dart';
import 'package:pills_reminder/features/settings/presentation/controllers/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final themeController = Get.find<ThemeController>();
    return Scaffold(
      backgroundColor: theme.surface,
      appBar: customAppBar(theme: theme),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.normalPadding),
        child: Column(
          children: [
            CustomDropDown(
              label: 'Theme Mode',
              value: themeController.themeMode.value,
              items: const [ThemeMode.system, ThemeMode.light, ThemeMode.dark],
              onChanged: (mode) => themeController.changeThemeMode(mode!),
              customNames: const {
                ThemeMode.system: 'Follow System',
                ThemeMode.light: 'Light',
                ThemeMode.dark: 'Dark',
              },
            ),
            const SizedBox(height: AppSizes.largePadding),
            CustomThemeDropdown(themeController: themeController),
          ],
        ),
      ),
    );
  }
}
