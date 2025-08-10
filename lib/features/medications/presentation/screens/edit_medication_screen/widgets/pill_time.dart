import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:pills_reminder/core/styles/sizes.dart';

class PillTime extends StatelessWidget {
  const PillTime({
    super.key,
    required this.i,
    required this.time,
    this.validator,
    required this.onChanged,
    required this.onTap,
  });

  final int i;
  final TimeOfDay? time;
  final String? Function(TimeOfDay?)? validator;
  final ValueChanged<TimeOfDay?> onChanged;
  final Future<TimeOfDay?> Function() onTap;

  @override
  Widget build(BuildContext context) {
    return FormField<TimeOfDay>(
      validator: validator,
      builder: (field) {
        final error = field.errorText;
        final isError = field.hasError;

        // keep the form value in sync with external value
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (field.value != time) {
            field.didChange(time);
          }
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(AppSizes.roundedRadius),
                border: Border.all(
                  color: isError
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.primaryFixedDim,
                  width: AppSizes.borderWidth,
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.largePadding,
                ),
                title: Text('${'toPill'.tr} ${i + 1}'),
                subtitle: time != null
                    ? Text(time!.format(context))
                    : Text('notSet'.tr),
                trailing: InkWell(
                  borderRadius: BorderRadius.circular(AppSizes.roundedRadius),
                  onTap: () async {
                    final newTime = await onTap();
                    if (newTime != null) {
                      onChanged(newTime); // updates external state
                      field.didChange(newTime); // updates internal field value
                    }
                  },
                  child: const Icon(Icons.edit),
                ),
              ),
            ),
            if (isError)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.largePadding,
                  vertical: 4,
                ),
                child: Text(
                  error!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
