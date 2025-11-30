import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/core/styles/styles.dart';

class NotificationDetails extends StatelessWidget {
  final PendingNotificationRequest notification;
  const NotificationDetails({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final List<String> pillTime = jsonDecode(
      notification.payload ?? "",
    )["pill time"].split(":");
    return Card(
      color: colorScheme.surfaceContainerLowest,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.pillHeight),
        side: BorderSide(
          color: colorScheme.primaryFixedDim,
          width: AppSizes.borderWidth,
        ),
      ),
      margin: const EdgeInsets.only(bottom: AppSizes.normalPadding),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.normalPadding),
        child: Center(
          child: ListTile(
            leading: Icon(
              Icons.notifications_active,
              color: colorScheme.primary,
              size: AppSizes.largeIconSize,
            ),
            title: Text(
              notification.title ?? "No Title",
              style: AppStyles.title.copyWith(
                fontSize: AppSizes.normalTextSize,
              ),
            ),
            subtitle: Text(
              "Scheduled at ${pillTime[0]}:${pillTime[1].padLeft(2, "0")}",
            ),
          ),
        ),
      ),
    );
  }
}
