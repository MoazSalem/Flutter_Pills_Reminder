import 'package:flutter/material.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/features/medications/data/models/medication_model.dart';
import 'package:pills_reminder/features/medications/presentation/screens/edit_medication_screen/edit_medication_screen.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size,
    this.color,
    this.sideColor,
  });
  final Widget icon;
  final VoidCallback? onTap;
  final double? size;
  final Color? color;
  final Color? sideColor;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size ?? AppSizes.circularRadius),
      child: Ink(
        height: size ?? AppSizes.roundedRadius,
        width: size ?? AppSizes.roundedRadius,
        decoration: BoxDecoration(
          color: color ?? theme.surfaceContainerLowest,
          border: Border.all(
            color: sideColor ?? theme.primaryFixedDim,
            width: 4,
          ),
          borderRadius: BorderRadius.circular(size ?? AppSizes.circularRadius),
        ),
        child: Center(child: icon),
      ),
    );
  }
}
