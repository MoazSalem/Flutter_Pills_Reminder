import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/core/models/medication_frequency.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/core/widgets/custom_appbar.dart';
import 'package:pills_reminder/core/widgets/custom_button.dart';
import 'package:pills_reminder/core/widgets/custom_drop_down.dart';
import 'package:pills_reminder/features/medications/data/models/medication_model.dart';
import 'package:pills_reminder/features/medications/presentation/controllers/edit_medication_controller.dart';
import 'package:pills_reminder/features/medications/presentation/screens/edit_medication_screen/widgets/custom_text_formfield.dart';
import 'package:pills_reminder/features/medications/presentation/screens/edit_medication_screen/widgets/day_picker.dart';
import 'package:pills_reminder/features/medications/presentation/screens/edit_medication_screen/widgets/delete_dialog.dart';
import 'package:pills_reminder/features/medications/presentation/screens/edit_medication_screen/widgets/notification_type_title.dart';
import 'package:pills_reminder/features/medications/presentation/screens/edit_medication_screen/widgets/pill_time.dart';
import 'package:pills_reminder/features/medications/presentation/screens/edit_medication_screen/widgets/weekday_picker.dart';

class EditMedicationScreen extends StatefulWidget {
  const EditMedicationScreen({super.key, this.medication});
  final MedicationModel? medication;

  @override
  State<EditMedicationScreen> createState() => _EditMedicationScreenState();
}

class _EditMedicationScreenState extends State<EditMedicationScreen> {
  late final EditMedicationController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(
      EditMedicationController(originalMedication: widget.medication),
      tag: UniqueKey().toString(),
      permanent: false,
    );
  }

  // manually dispose of controller since we don't use getX navigation to get to this page
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.normalPadding),
        child: SingleChildScrollView(
          child: Obx(
            () => Form(
              key: controller.formKey,
              child: Column(
                spacing: AppSizes.normalPadding,
                children: [
                  /// Appbar with back button
                  const CustomAppbar(),

                  /// Medication name
                  CustomTextFormField(
                    initialValue: controller.name.value,
                    labelText: 'medicationName'.tr,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'medicationNameHint'.tr;
                      }
                      return null;
                    },
                    onSaved: (value) => controller.name.value = value!,
                  ),

                  /// Amount of pills available
                  CustomTextFormField(
                    initialValue: controller.amount.value,
                    labelText: 'pAmount'.tr,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return null;
                      }
                      final number = num.tryParse(value);
                      if (number == null) {
                        return 'pAmountHint'.tr;
                      }
                      return null;
                    },
                    onSaved: (value) => controller.amount.value = value!,
                  ),

                  /// Frequency of medication
                  CustomDropDown(
                    value: controller.frequency.value,
                    items: MedicationFrequency.values,
                    customNames: frequencies,
                    onChanged: (value) {
                      controller.frequency.value = value!;
                      controller.days.forEach(
                        (key, value) => controller.days[key] = false,
                      );
                      controller.selectedDays.clear();
                      controller.monthlyDay.value = null;
                    },
                    label: 'frequency'.tr,
                  ),

                  /// Days selection
                  if (controller.frequency.value ==
                      MedicationFrequency.daysPerWeek)
                    WeekdayPicker(
                      key: ValueKey(controller.frequency.value),
                      frequency: controller.frequency.value,
                      days: controller.days,
                      onChanged: (day, value) => {
                        controller.days[day] = value,
                        controller.selectedDays.clear(),
                        controller.days.forEach((key, value) {
                          if (value) {
                            controller.selectedDays.add(key);
                          }
                        }),
                      },
                    ),

                  /// Day of the month if frequency is once
                  if (controller.frequency.value == MedicationFrequency.once)
                    DayPicker(
                      selectedDate: controller.monthlyDay.value,
                      onTap: (DateTime date) {
                        controller.monthlyDay.value = date;
                      },
                    ),

                  /// Pills per day
                  CustomDropDown(
                    value: controller.timesRepeated.value,
                    items: List.generate(20, (i) => i + 1),
                    onChanged: (value) {
                      controller.timesRepeated.value = value!;
                      if (controller.timesRepeated < controller.times.length) {
                        int difference =
                            controller.times.length -
                            controller.timesRepeated.value;
                        for (var i = 0; i < difference; i++) {
                          controller.times.removeAt(
                            controller.times.length - 1,
                          );
                        }
                      } else if (controller.timesRepeated >
                          controller.times.length) {
                        int difference =
                            controller.timesRepeated.value -
                            controller.times.length;
                        controller.times.value = [
                          ...controller.times,
                          ...List.generate(difference, (_) => null),
                        ];
                      }
                    },
                    label: 'repeat'.tr,
                  ),

                  /// Pills times selection
                  ...List.generate(
                    controller.timesRepeated.value,
                    (i) => PillTime(
                      i: i,
                      validator: (value) {
                        if (value == null) {
                          return 'timesHint'.tr;
                        }
                        return null;
                      },
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime:
                              controller.times[i] ??
                              TimeOfDay(hour: 12, minute: 0),
                        );
                        if (time != null) {
                          controller.times[i];
                        }
                        return time;
                      },
                      time: i < controller.times.length
                          ? controller.times[i]
                          : null,
                      onChanged: (newTime) {
                        controller.times[i] = newTime;
                      },
                    ),
                  ),

                  /// Notification type
                  NotificationTypeTitle(
                    notificationType: controller.notificationType.value,
                    onChanged: (value) {
                      {
                        controller.notificationType.value = value!;
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: widget.medication != null
                        ? MainAxisAlignment.spaceBetween
                        : MainAxisAlignment.end,
                    children: [
                      /// delete medication
                      if (widget.medication != null)
                        CustomButton(
                          size: AppSizes.buttonSize,
                          color: colorScheme.errorContainer,
                          sideColor: colorScheme.onError,
                          icon: Icon(
                            size: AppSizes.largeIconSize,
                            Icons.delete_forever_outlined,
                            color: colorScheme.onErrorContainer,
                          ),
                          onTap: () => showDeleteDialog(
                            context: context,
                            deleteMedication: controller.deleteMedication,
                          ),
                        ),

                      /// Save medication
                      CustomButton(
                        size: AppSizes.buttonSize,
                        icon: Icon(
                          size: AppSizes.largeIconSize,
                          Icons.done,
                          color: colorScheme.onPrimaryContainer,
                        ),
                        onTap: controller.saveMedication,
                      ),
                    ],
                  ),
                  const SizedBox(width: AppSizes.normalPadding),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
