import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/core/styles/styles.dart';

class LangSwitcher extends StatefulWidget {
  const LangSwitcher({super.key});

  @override
  State<LangSwitcher> createState() => _LangSwitcherState();
}

class _LangSwitcherState extends State<LangSwitcher> {
  bool isEng = Get.locale!.languageCode == 'en';
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSizes.largePadding * 2,
        horizontal: AppSizes.largePadding,
      ),
      child: InkWell(
        onTap: () => {
          setState(() {
            Get.updateLocale(Locale(isEng ? 'ar' : 'en'));
            Hive.box('Settings').put('lang', isEng ? 'ar' : 'en');
            isEng = !isEng;
          }),
        },
        child: Container(
          decoration: BoxDecoration(
            color: theme.primary,
            borderRadius: BorderRadius.circular(AppSizes.roundedRadius),
            border: Border.all(
              color: theme.primaryFixedDim,
              width: AppSizes.borderWidth,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.smallPadding),
            child: Text(
              isEng ? 'ar'.tr : 'en'.tr,
              style: AppStyles.subTitle.copyWith(color: theme.onPrimary),
            ),
          ),
        ),
      ),
    );
  }
}
