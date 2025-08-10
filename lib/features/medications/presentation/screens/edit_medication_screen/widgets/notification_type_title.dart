import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:pills_reminder/core/models/notification_type.dart';
import 'package:pills_reminder/core/widgets/custom_drop_down.dart';

class NotificationTypeTitle extends StatelessWidget {
  const NotificationTypeTitle({
    super.key,
    required this.notificationType,
    required this.onChanged,
  });
  final NotificationType notificationType;
  final void Function(NotificationType?) onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomDropDown(
      label: 'notificationType'.tr,
      value: notificationType,
      items: NotificationType.values,
      customNames: Map.fromEntries(
        NotificationType.values.map((e) => MapEntry(e, e.label)),
      ),
      selectedWidget: NotificationType.values
          .map((e) => Text(e.label))
          .toList(),
      itemsWidget: NotificationType.values
          .map(
            (item) => DropdownMenuItem<NotificationType>(
              value: item,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(item.label),
                    subtitle: Text(item.description),
                  ),
                ],
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
