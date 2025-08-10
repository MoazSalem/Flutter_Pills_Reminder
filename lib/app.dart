import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/core/bindings/app_bindings.dart';
import 'package:pills_reminder/core/styles/strings.dart';
import 'package:pills_reminder/features/settings/presentation/controllers/settings_controller.dart';
import 'package:pills_reminder/features/medications/presentation/screens/main_screen/main_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<SettingsController>();
    return Obx(
      () => GetMaterialApp(
        translations: AppTranslations(),
        locale: themeController.locale.value,
        initialBinding: AppBindings(),
        debugShowCheckedModeBanner: false,
        title: 'appName'.tr,
        theme: themeController.lightTheme.value,
        darkTheme: themeController.darkTheme.value,
        themeMode: themeController.themeMode.value,
        home: MainScreen(),
      ),
    );
  }
}
