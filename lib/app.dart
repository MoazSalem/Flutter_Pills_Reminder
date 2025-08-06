import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/core/controllers/theme_controller.dart';
import 'package:pills_reminder/core/styles/strings.dart';
import 'package:pills_reminder/features/medications/presentation/screens/main_screen/main_screen.dart';
import 'features/medications/presentation/bindings/medications_binding.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Obx(
      () => GetMaterialApp(
        initialBinding: MedicationsBinding(),
        debugShowCheckedModeBanner: false,
        title: AppStrings.appName,
        theme: themeController.lightTheme.value,
        darkTheme: themeController.darkTheme.value,
        themeMode: themeController.themeMode.value,
        home: MainScreen(),
      ),
    );
  }
}
