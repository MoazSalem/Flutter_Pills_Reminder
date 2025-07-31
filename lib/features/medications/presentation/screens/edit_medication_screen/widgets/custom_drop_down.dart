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
    this.itemsWidget,
    this.selectedWidget,
  });

  final void Function(T? value) onChanged;
  final T value;
  final List<T> items;
  final List<DropdownMenuItem<T>>? itemsWidget;
  final List<Widget>? selectedWidget;
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
    final OutlineInputBorder border = OutlineInputBorder(
      borderSide: BorderSide(
        color: theme.colorScheme.primaryFixedDim,
        width: 4,
      ),
      borderRadius: BorderRadius.circular(AppSizes.roundedRadius),
    );
    return Center(
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButtonFormField<T>(
          menuMaxHeight: 300,
          value: selectedValue,
          onChanged: widget.onChanged,
          selectedItemBuilder: widget.selectedWidget != null
              ? (context) => widget.selectedWidget!
              : null,
          items:
              widget.itemsWidget ??
              widget.items
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
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(AppSizes.roundedRadius),
            ),
            contentPadding: const EdgeInsets.all(AppSizes.largePadding),
            alignLabelWithHint: true,
            labelText: widget.label,
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerLowest,
            enabledBorder: border,
            focusedBorder: border,
            disabledBorder: border,
          ),
          borderRadius: BorderRadius.circular(12),
          dropdownColor: theme.colorScheme.surfaceContainerLowest,
        ),
      ),
    );
  }
}
