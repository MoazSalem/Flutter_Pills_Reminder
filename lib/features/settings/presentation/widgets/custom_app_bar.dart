import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/core/styles/styles.dart';
import 'package:pills_reminder/core/widgets/custom_button.dart';

PreferredSizeWidget customAppBar({required ColorScheme theme}) {
  return AppBar(
    automaticallyImplyLeading: false,
    leadingWidth: 90,
    leading: Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSizes.normalPadding + 5,
        horizontal: AppSizes.normalPadding,
      ),
      child: CustomButton(
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
    ),
    title: Text(
      'settings'.tr,
      style: AppStyles.title.copyWith(
        color: theme.onPrimaryContainer,
        fontSize: AppSizes.titleTextSize,
      ),
    ),
    toolbarHeight: AppSizes.appBarHeight,
  );
}
