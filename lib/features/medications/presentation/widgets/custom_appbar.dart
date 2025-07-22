import 'package:flutter/material.dart';
import 'package:pills_reminder/core/styles/sizes.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSizes.normalPadding),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(AppSizes.circularRadius),
            child: Ink(
              height: AppSizes.roundedRadius,
              width: AppSizes.roundedRadius,
              decoration: BoxDecoration(
                color: theme.primaryContainer,
                borderRadius: BorderRadius.circular(AppSizes.circularRadius),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 3.0),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: AppSizes.largeIconSize,
                    color: theme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
