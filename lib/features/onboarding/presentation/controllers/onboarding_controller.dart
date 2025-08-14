import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:pills_reminder/features/medications/presentation/screens/main_screen/main_screen.dart';
import 'package:pills_reminder/features/notifications/presentation/controllers/notifications_controller.dart';

class OnboardingController extends GetxController {
  var currentPage = 0.obs;
  final pageController = PageController();

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage(int totalPages) {
    if (currentPage.value < totalPages - 1) {
      pageController.nextPage(
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      finishOnboarding();
    }
  }

  void finishOnboarding() async {
    Hive.box('Settings').put('onboarded', '1');
    final NotificationsController controller =
        Get.find<NotificationsController>();
    await controller.requestNotificationPermission();
    if (Platform.isAndroid) {
      await controller.requestExactAlarmPermission();
    }
    Get.offAll(MainScreen());
  }
}
