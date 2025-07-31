import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/core/widgets/custom_button.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key, this.action});
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.normalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomButton(
            icon: Padding(
              padding: const EdgeInsets.only(right: 3.0),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: AppSizes.normalIconSize,
                color: theme.onPrimaryContainer,
              ),
            ),
            onTap: () => Get.back(),
          ),
          ?action,
        ],
      ),
    );
  }
}
