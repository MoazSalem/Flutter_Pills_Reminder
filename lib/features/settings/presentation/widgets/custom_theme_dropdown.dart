import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/core/styles/theme.dart';
import 'package:pills_reminder/core/widgets/custom_drop_down.dart';
import 'package:pills_reminder/features/settings/presentation/controllers/settings_controller.dart';

class CustomThemeDropdown extends StatelessWidget {
  const CustomThemeDropdown({super.key, required this.themeController});
  final SettingsController themeController;

  @override
  Widget build(BuildContext context) {
    return CustomDropDown(
      label: 'appsTheme'.tr,
      value: AppThemes.themeColors.keys.toList()[themeController.themeIndex],
      items: AppThemes.themeColors.keys.toList(),
      onChanged: (index) => themeController.changeTheme(
        AppThemes.themeColors.keys.toList().indexOf(index!),
      ),
      itemsWidget: List.generate(
        AppThemes.themeColors.length,
        (index) => DropdownMenuItem<String>(
          value: AppThemes.themeColors.keys.toList()[index],
          child: Row(
            spacing: AppSizes.largePadding,
            children: [
              Icon(
                Icons.lens,
                color: AppThemes.themeColors.values.toList()[index],
              ),
              Text(AppThemes.themeColors.keys.toList()[index]),
            ],
          ),
        ),
      ),
      selectedWidget: List.generate(
        AppThemes.themeColors.length,
        (index) => Row(
          spacing: AppSizes.largePadding,
          children: [
            Icon(
              Icons.lens,
              color: AppThemes.themeColors.values.toList()[index],
            ),
            Text(AppThemes.themeColors.keys.toList()[index]),
          ],
        ),
      ),
    );
  }
}
