import 'package:flutter/material.dart';
import 'package:pills_reminder/core/styles/sizes.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? Function(String?)? validator;
  const CustomTextFormField({
    super.key,
    this.controller,
    required this.labelText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final OutlineInputBorder border = OutlineInputBorder(
      borderSide: BorderSide(
        color: theme.primaryFixedDim,
        width: AppSizes.borderWidth,
      ),
      borderRadius: BorderRadius.circular(AppSizes.roundedRadius),
    );
    return TextFormField(
      validator: validator,
      controller: controller,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      decoration: InputDecoration(
        focusedBorder: border,
        enabledBorder: border,
        disabledBorder: border,
        errorBorder: border.copyWith(
          borderSide: BorderSide(color: theme.error, width: 4),
        ),
        filled: true,
        fillColor: theme.surfaceContainerLowest,
        border: border,
        labelText: labelText,
        contentPadding: EdgeInsets.symmetric(
          vertical: AppSizes.largePadding,
          horizontal: AppSizes.largePadding,
        ),
        alignLabelWithHint: true,
      ),
    );
  }
}
