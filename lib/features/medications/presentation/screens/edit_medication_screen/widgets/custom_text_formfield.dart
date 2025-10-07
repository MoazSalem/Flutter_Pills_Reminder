import 'package:flutter/material.dart';
import 'package:pills_reminder/core/styles/sizes.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final String? Function(String?)? validator;
  final void Function(String?) onSaved;
  const CustomTextFormField({
    super.key,
    required this.labelText,
    this.validator, required this.onSaved,
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
      onSaved: onSaved,
      validator: validator,
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
        labelStyle: TextStyle(color: theme.primaryFixedDim),
        contentPadding: EdgeInsets.symmetric(
          vertical: AppSizes.largePadding,
          horizontal: AppSizes.largePadding,
        ),
        alignLabelWithHint: true,
      ),
    );
  }
}
