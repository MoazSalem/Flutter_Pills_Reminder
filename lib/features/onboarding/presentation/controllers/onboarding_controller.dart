import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:pills_reminder/features/medications/presentation/screens/main_screen/main_screen.dart';

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

  void finishOnboarding() {
    Hive.box('Settings').put('onboarded', '1');
    Get.offAll(MainScreen());
  }
}
