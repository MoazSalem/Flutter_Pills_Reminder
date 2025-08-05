import 'package:flutter/material.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/core/styles/theme.dart';

class ThemePopupMenu extends StatelessWidget {
  const ThemePopupMenu({
    super.key,
    required this.themeIndex,
    required this.onChanged,
    this.contentPadding,
  });

  final int themeIndex;
  final ValueChanged<int> onChanged;
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context) {
    final themesValues = AppThemes.themeColors.values.toList();
    final themesNames = AppThemes.themeColors.keys.toList();
    final theme = Theme.of(context).colorScheme;
    final OutlineInputBorder border = OutlineInputBorder(
      borderSide: BorderSide(
        color: theme.primaryFixedDim,
        width: AppSizes.borderWidth,
      ),
      borderRadius: BorderRadius.circular(AppSizes.roundedRadius),
    );
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSizes.roundedRadius),
        border: Border.all(
          color: Theme.of(context).colorScheme.primaryFixedDim,
          width: AppSizes.borderWidth,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.normalPadding),
        child: PopupMenuButton<int>(
          tooltip: '',
          padding: EdgeInsets.zero,
          onSelected: onChanged,
          itemBuilder: (BuildContext context) => <PopupMenuItem<int>>[
            for (int i = 0; i < themesNames.length; i++)
              PopupMenuItem<int>(
                value: i,
                child: ListTile(
                  dense: true,
                  leading: Icon(Icons.lens, color: themesValues[i], size: 35),
                  title: Text(themesNames[i]),
                ),
              ),
          ],
          child: ListTile(
            contentPadding:
                contentPadding ?? const EdgeInsets.symmetric(horizontal: 16),
            title: Text(
              "Apps Theme",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
            ),
            subtitle: Text(
              "Current Theme:  ${themesNames[themeIndex]} ",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
            ),
            trailing: Icon(
              Icons.lens,
              color: themesValues[themeIndex],
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}
