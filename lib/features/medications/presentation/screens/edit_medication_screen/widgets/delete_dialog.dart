import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool?> showDeleteDialog({
  required BuildContext context,
  required Function deleteMedication,
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
            await deleteMedication();
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
