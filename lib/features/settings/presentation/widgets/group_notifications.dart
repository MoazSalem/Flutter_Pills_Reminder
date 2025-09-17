import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/core/styles/styles.dart';
import 'package:pills_reminder/features/settings/presentation/controllers/settings_controller.dart';

class GroupNotifications extends StatelessWidget {
  const GroupNotifications({super.key, required this.themeController});

  final SettingsController themeController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: theme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSizes.roundedRadius),
        border: Border.all(
          color: theme.primaryFixedDim,
          width: AppSizes.borderWidth,
        ),
      ),
      child: Obx(
        () => Padding(
          padding: const EdgeInsets.all(AppSizes.smallPadding),
          child: SwitchListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.roundedRadius),
            ),
            value: themeController.groupedNotifications.value,
            onChanged: (value) => themeController.changeNotificationMode(value),
            title: Text(
              'groupNotifications'.tr,
              style: AppStyles.title.copyWith(
                fontSize: AppSizes.normalTextSize,
              ),
            ),
            subtitle: Text(
              'groupNotificationsDescription'.tr,
              style: AppStyles.subTitle.copyWith(
                fontSize: AppSizes.tinyTextSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
