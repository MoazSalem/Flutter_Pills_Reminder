import 'package:flutter/material.dart';
import 'package:pills_reminder/core/styles/sizes.dart';

class PillTime extends StatelessWidget {
  const PillTime({
    super.key,
    required this.i,
    required this.times,
    this.validator,
    required this.onTap,
  });

  final int i;
  final List<TimeOfDay> times;
  final String? Function(TimeOfDay?)? validator;
  final Future<TimeOfDay?> Function() onTap;

  @override
  Widget build(BuildContext context) {
    return FormField<TimeOfDay>(
      key: ValueKey(i),
      initialValue: times.isNotEmpty && i < times.length ? times[i] : null,
      validator: validator,
      builder: (field) {
        final hasError = field.hasError;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(AppSizes.roundedRadius),
                border: hasError
                    ? Border.all(
                        color: Theme.of(context).colorScheme.error,
                        width: 1,
                      )
                    : null,
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.largePadding,
                ),
                title: Text('Pill ${i + 1} Time'),
                subtitle: field.value != null
                    ? Text(field.value!.format(context))
                    : const Text("Not Set"),
                trailing: InkWell(
                  borderRadius: BorderRadius.circular(AppSizes.roundedRadius),
                  onTap: () async {
                    final pickedTime = await onTap();
                    if (pickedTime != null) {
                      field.didChange(pickedTime);
                    }
                  },
                  child: const Icon(Icons.edit),
                ),
              ),
            ),
            if (hasError)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.largePadding,
                  vertical: 4,
                ),
                child: Text(
                  field.errorText!,
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
