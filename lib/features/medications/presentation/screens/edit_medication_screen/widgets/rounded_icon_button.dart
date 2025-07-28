import 'package:flutter/material.dart';
import 'package:pills_reminder/core/styles/sizes.dart';

class RoundedIconButton extends StatelessWidget {
  const RoundedIconButton({
    super.key,
    required this.color,
    this.onPressed,
    required this.icon,
  });
  final Color color;
  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.buttonHeight,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.largePadding - 3,
          ),
          elevation: 0,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSizes.roundedRadius),
          ),
        ),
        onPressed: onPressed,
        child: icon,
      ),
    );
  }
}
