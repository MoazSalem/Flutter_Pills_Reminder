import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/core/models/medication_frequency.dart';
import 'package:pills_reminder/features/medications/data/models/medication_model.dart';
import 'package:pills_reminder/features/medications/presentation/controllers/medications_controller.dart';
import 'package:pills_reminder/features/notifications/presentation/controllers/notifications_controller.dart';

Future<bool?> showDeleteDialog({
  required BuildContext context,
  required MedicationController medicationsController,
  required MedicationModel medication,
  required MedicationFrequency frequency,
  required NotificationsController notificationsController,
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('deleteMedication'.tr),
      content: Text("deleteMedicationDescription".tr),
      actions: [
        TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
        TextButton(
          onPressed: () async {
            await notificationsController.cancelNotifications(medication);
            await medicationsController.deleteMedication(medication.id);
            Get.until((route) => route.isFirst);
            Get.snackbar(
              'deleteMedication'.tr,
              'deleteDone'.tr,
              snackPosition: SnackPosition.BOTTOM,
            );
          },
          child: Text('delete'.tr, style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}
