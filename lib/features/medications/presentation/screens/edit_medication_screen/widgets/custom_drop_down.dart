import 'package:flutter/material.dart';
import 'package:pills_reminder/core/styles/sizes.dart';

class CustomDropDown<T> extends StatefulWidget {
  const CustomDropDown({
    super.key,
    required this.onChanged,
    required this.label,
    required this.value,
    required this.items,
    this.customNames,
  });

  final void Function(T? value) onChanged;
  final T value;
  final List<T> items;
  final String label;
  final Map<dynamic, dynamic>? customNames;

  @override
  State<CustomDropDown<T>> createState() => _CustomDropDownState<T>();
}

class _CustomDropDownState<T> extends State<CustomDropDown<T>> {
  T? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButtonFormField<T>(
        menuMaxHeight: 200,
        value: selectedValue,
        onChanged: widget.onChanged,
        items: widget.items
            .map(
              (item) => DropdownMenuItem<T>(
                value: item,
                child: Text(
                  widget.customNames != null
                      ? widget.customNames![item]
                      : item.toString(),
                ),
              ),
            )
            .toList(),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(AppSizes.largePadding),
          alignLabelWithHint: true,
          labelText: widget.label,
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerLowest,
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(AppSizes.roundedRadius),
          ),
        ),
        borderRadius: BorderRadius.circular(12),
        dropdownColor: theme.colorScheme.surfaceContainerLowest,
      ),
    );
  }
}
