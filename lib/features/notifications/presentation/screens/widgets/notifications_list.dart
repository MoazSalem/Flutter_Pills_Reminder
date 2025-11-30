import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    hide NotificationDetails;
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/features/notifications/presentation/screens/widgets/notification_details.dart';

class NotificationsList extends StatelessWidget {
  final List<PendingNotificationRequest> notifications;
  const NotificationsList({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.largePadding),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          childAspectRatio: 3,
          crossAxisSpacing: 20,
          maxCrossAxisExtent: 450,
        ),
        itemCount: notifications.length,
        itemBuilder: (context, index) =>
            NotificationDetails(notification: notifications[index]),
      ),
    );
  }
}
