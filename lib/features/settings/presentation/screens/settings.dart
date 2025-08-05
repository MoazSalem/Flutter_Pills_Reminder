import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/core/styles/strings.dart';
import 'package:pills_reminder/core/styles/styles.dart';
import 'package:pills_reminder/core/widgets/custom_button.dart';
import 'package:pills_reminder/features/settings/presentation/widgets/custom_app_bar.dart';
import 'package:pills_reminder/features/settings/presentation/widgets/theme_popup_menu.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: theme.surface,
      appBar: customAppBar(theme: theme),
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.normalPadding),
        child: Column(
          children: [ThemePopupMenu(themeIndex: 0, onChanged: (newIndex) {})],
        ),
      ),
    );
  }
}
