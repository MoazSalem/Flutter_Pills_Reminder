import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/features/notifications/presentation/controllers/notifications_controller.dart';
import 'package:pills_reminder/features/notifications/presentation/screens/widgets/notifications_list.dart';

class NotificationsTab extends StatefulWidget {
  const NotificationsTab({super.key});

  @override
  State<NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {
  final controller = Get.find<NotificationsController>();
  @override
  Widget build(BuildContext context) {
    controller.getActiveNotifications();
    return Obx(() {
      return controller.notifications.isEmpty
          ? Center(child: Text('noNotifications'.tr))
          : NotificationsList(notifications: controller.notifications);
    });
  }
}
