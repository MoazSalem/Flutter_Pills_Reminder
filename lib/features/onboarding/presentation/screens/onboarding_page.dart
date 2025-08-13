import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/core/styles/styles.dart';
import 'package:pills_reminder/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'widgets/page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = Get.put(OnboardingController());

  final List<Map<String, String>> pages = [
    {
      'title': 'Welcome to Pills Reminder',
      'subtitle': 'Never Forget to take your pills again.',
      'image': 'assets/images/welcome.png',
    },
    {
      'title': 'Reminders that fit your life',
      'subtitle':
          'Daily, on specific days, or monthly — we’ll remind you right on time.',
      'image': 'assets/images/reminders.png',
    },
    {
      'title': 'Stay on track',
      'subtitle':
          'Consistent medication keeps you healthy — we’re here to help.',
      'image': 'assets/images/healthy.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: theme.surface,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              itemCount: pages.length,
              itemBuilder: (_, index) {
                return Obx(() {
                  bool isCurrent = controller.currentPage.value == index;
                  return Column(
                    children: [
                      Flexible(
                        flex: 3,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: double.maxFinite,
                              height: double.maxFinite,
                              decoration: BoxDecoration(
                                color: theme.primaryContainer,
                                border: Border.all(
                                  color: theme.primaryFixedDim,
                                  width: AppSizes.borderWidth,
                                ),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(500),
                                  bottomRight: Radius.circular(500),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              height: 200,
                              child: AnimatedOpacity(
                                opacity: isCurrent ? 1.0 : 0.0,
                                duration: Duration(milliseconds: 500),
                                child: Image.asset(
                                  fit: BoxFit.contain,
                                  pages[index]['image']!,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              pages[index]['title']!,
                              style: AppStyles.title.copyWith(
                                fontSize: AppSizes.titleTextSize,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30.0,
                              ),
                              child: Text(
                                pages[index]['subtitle']!,
                                textAlign: TextAlign.center,
                                style: AppStyles.subTitle.copyWith(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 0,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(
                              () => FilledButton(
                                onPressed: () =>
                                    controller.nextPage(pages.length),
                                style: FilledButton.styleFrom(
                                  backgroundColor: theme.primaryContainer,
                                  foregroundColor: theme.onPrimaryContainer,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      width: AppSizes.borderWidth,
                                      color: theme.primaryFixedDim,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 40,
                                    vertical: 15,
                                  ),
                                ),
                                child: Text(
                                  controller.currentPage.value ==
                                          pages.length - 1
                                      ? 'Get Started'
                                      : 'Next',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppSizes.largePadding * 2,
                              ),
                              child: Obx(
                                () => PageIndicator(
                                  count: pages.length,
                                  currentIndex: controller.currentPage.value,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
