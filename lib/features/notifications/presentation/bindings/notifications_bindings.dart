import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pills_reminder/features/notifications/data/services/notification_service_impl.dart';
import 'package:pills_reminder/features/notifications/domain/services/notification_service.dart';

class NotificationsBindings extends Bindings {
  @override
  void dependencies() async {
    final notificationsPlugin = FlutterLocalNotificationsPlugin();

    // Ensure plugin is initialized
    await notificationsPlugin.initialize(const InitializationSettings());

    Get.lazyPut<NotificationService>(
      () => NotificationServiceImpl(notificationsPlugin),
    );
  }
}
