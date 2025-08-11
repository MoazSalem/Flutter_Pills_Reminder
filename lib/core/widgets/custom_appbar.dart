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
      padding: const EdgeInsets.only(
        top: AppSizes.largePadding,
        bottom: AppSizes.normalPadding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomButton(
            icon: Icon(
              Icons.arrow_back,
              size: AppSizes.largeIconSize,
              color: theme.onPrimaryContainer,
            ),
            onTap: () => Get.back(),
          ),
          ?action,
        ],
      ),
    );
  }
}
