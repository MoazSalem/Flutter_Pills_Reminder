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
    return TextFormField(
      validator: validator,
      controller: controller,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      decoration: InputDecoration(
        filled: true,
        fillColor: theme.surfaceContainerLowest,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(
            Radius.circular(AppSizes.roundedRadius),
          ),
        ),
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
