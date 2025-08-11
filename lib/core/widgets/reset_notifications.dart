import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/core/styles/styles.dart';
import 'package:pills_reminder/core/widgets/custom_button.dart';
import 'package:pills_reminder/features/notifications/presentation/controllers/notifications_controller.dart';

class ResetNotifications extends StatelessWidget {
  const ResetNotifications({super.key, this.id});
  final int? id;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final controller = Get.find<NotificationsController>();
    return Container(
      height: AppSizes.appBarHeight,
      decoration: BoxDecoration(
        color: theme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSizes.roundedRadius),
        border: Border.all(
          color: theme.primaryFixedDim,
          width: AppSizes.borderWidth,
        ),
      ),
      child: Center(
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.smallPadding,
            ),
            child: Text(
              'resetNotifications'.tr,
              style: AppStyles.title.copyWith(
                fontSize: AppSizes.normalTextSize,
              ),
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.smallPadding,
            ),
            child: Text(
              id != null
                  ? 'resetNotificationsDescription'.tr
                  : 'resetAllNotificationsDescription'.tr,
              style: AppStyles.subTitle.copyWith(
                fontSize: AppSizes.tinyTextSize,
              ),
            ),
          ),
          trailing: CustomButton(
            size: 40,
            icon: Icon(
              Icons.refresh,
              size: AppSizes.largeIconSize,
              color: theme.onPrimaryContainer,
            ),
            onTap: () async {
              id != null
                  ? await controller.rescheduleMedicationsNotifications(id: id!)
                  : await controller.rescheduleAllNotifications();
            },
          ),
        ),
      ),
    );
  }
}
