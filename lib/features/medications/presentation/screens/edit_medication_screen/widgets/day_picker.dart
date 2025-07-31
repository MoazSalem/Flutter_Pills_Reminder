import 'package:flutter/material.dart';
import 'package:pills_reminder/core/styles/sizes.dart';

class DayPicker extends StatelessWidget {
  const DayPicker({super.key, required this.onTap, this.selectedDate});
  final void Function(DateTime) onTap;
  final DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(AppSizes.roundedRadius),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSizes.largePadding,
            ),
            title: Text('Date'),
            subtitle: Text(
              selectedDate == null
                  ? 'Not Set'
                  : "${selectedDate!.year}/${selectedDate!.month}/${selectedDate!.day}",
            ),
            trailing: InkWell(
              borderRadius: BorderRadius.circular(AppSizes.roundedRadius),
              onTap: () async {
                final date = await pickDate(context);
                if (date != null) {
                  onTap(date);
                }
              },
              child: const Icon(Icons.edit),
            ),
          ),
        ),
      ],
    );
  }
}

Future<DateTime?> pickDate(BuildContext context) async {
  final today = DateTime.now();

  final pickedDate = await showDatePicker(
    context: context,
    initialDate: today,
    firstDate: DateTime(today.year - 1),
    lastDate: DateTime(today.year + 2),
    helpText: 'Select Date',
  );

  return pickedDate; // Will be null if user cancels
}
