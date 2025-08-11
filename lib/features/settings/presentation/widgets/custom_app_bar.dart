import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/core/styles/styles.dart';
import 'package:pills_reminder/core/widgets/custom_button.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSizes.largePadding,
        bottom: AppSizes.normalPadding,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: AppSizes.largePadding,
        children: [
          CustomButton(
            icon: Icon(
              Icons.arrow_back,
              size: AppSizes.largeIconSize,
              color: theme.onPrimaryContainer,
            ),
            onTap: () => Get.back(),
          ),
          Text(
            'settings'.tr,
            style: AppStyles.title.copyWith(
              color: theme.onPrimaryContainer,
              fontSize: AppSizes.titleTextSize,
            ),
          ),
        ],
      ),
    );
  }
}
