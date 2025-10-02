import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/core/styles/styles.dart';
import 'package:pills_reminder/features/medications/presentation/controllers/medications_controller.dart';
import 'package:pills_reminder/features/medications/presentation/screens/main_screen/medications_tab.dart';
import 'package:pills_reminder/features/medications/presentation/screens/main_screen/widgets/fab.dart';
import 'package:pills_reminder/features/notifications/presentation/screens/notifications_tab.dart';
import 'package:pills_reminder/features/settings/presentation/screens/settings.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MedicationController>();
    final theme = Theme.of(context);

    return Obx(() {
      if (!controller.isReady.value) {
        return CircularProgressIndicator();
      }
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          systemNavigationBarColor: theme.colorScheme.surface,
          systemNavigationBarIconBrightness: theme.brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
        ),
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: theme.colorScheme.surface,
            appBar: AppBar(
              actionsPadding: const EdgeInsets.symmetric(
                horizontal: AppSizes.normalPadding,
              ),
              title: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.normalPadding,
                ),
                child: Text(
                  'appName'.tr,
                  style: AppStyles.title.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontSize: AppSizes.titleTextSize,
                  ),
                ),
              ),
              bottom: TabBar(
                tabs: [
                  Tab(
                    child: Text(
                      'medications'.tr,
                      style: AppStyles.title.copyWith(
                        fontSize: AppSizes.smallTextSize,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      'notifications'.tr,
                      style: AppStyles.title.copyWith(
                        fontSize: AppSizes.smallTextSize,
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  onPressed: () => Get.to(() => const SettingsScreen()),
                  icon: Image.asset(
                    'assets/icons/settings.png',
                    width: AppSizes.largeIconSize,
                    height: AppSizes.largeIconSize,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
              toolbarHeight: AppSizes.appBarHeight,
            ),
            body: TabBarView(
              children: [
                MedicationsTab(controller: controller),
                const NotificationsTab(),
              ],
            ),
            floatingActionButton: Fab(theme: theme.colorScheme),
          ),
        ),
      );
    });
  }
}
