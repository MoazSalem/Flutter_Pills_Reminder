import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/core/models/medication_frequency.dart';
import 'package:pills_reminder/core/models/notification_type.dart';
import 'package:pills_reminder/core/models/weekday.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/core/widgets/custom_button.dart';
import 'package:pills_reminder/features/medications/data/models/medication_model.dart';
import 'package:pills_reminder/features/medications/presentation/controllers/medications_controller.dart';
import 'package:pills_reminder/core/widgets/custom_appbar.dart';
import 'package:pills_reminder/features/medications/presentation/screens/edit_medication_screen/widgets/delete_dialog.dart';
import 'package:pills_reminder/features/notifications/presentation/controllers/notifications_controller.dart';
import 'package:pills_reminder/core/widgets/custom_drop_down.dart';
import 'package:pills_reminder/features/medications/presentation/screens/edit_medication_screen/widgets/custom_text_formfield.dart';
import 'package:pills_reminder/features/medications/presentation/screens/edit_medication_screen/widgets/day_picker.dart';
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
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  MedicationFrequency frequency = MedicationFrequency.daily;
  int repeatTimes = 1;
  List<Weekday> selectedDays = [];
  List<TimeOfDay?> times = [null];
  DateTime? monthlyDay;

  /// this is only needed for android
  NotificationType? notificationType;

  Map<Weekday, bool> days = {
    Weekday.saturday: false,
    Weekday.sunday: false,
    Weekday.monday: false,
    Weekday.tuesday: false,
    Weekday.wednesday: false,
    Weekday.thursday: false,
    Weekday.friday: false,
  };

  @override
  void initState() {
    super.initState();
    if (widget.medication != null) {
      nameController.text = widget.medication!.name;
      amountController.text = widget.medication!.amount == null
          ? ""
          : widget.medication!.amount.toString();
      frequency = widget.medication!.frequency;
      repeatTimes = widget.medication!.times.length;
      selectedDays = widget.medication!.selectedDays ?? [];
      days = {
        Weekday.saturday: selectedDays.contains(Weekday.saturday),
        Weekday.sunday: selectedDays.contains(Weekday.sunday),
        Weekday.monday: selectedDays.contains(Weekday.monday),
        Weekday.tuesday: selectedDays.contains(Weekday.tuesday),
        Weekday.wednesday: selectedDays.contains(Weekday.wednesday),
        Weekday.thursday: selectedDays.contains(Weekday.thursday),
        Weekday.friday: selectedDays.contains(Weekday.friday),
      };
      times = widget.medication!.times;
      monthlyDay = widget.medication!.monthlyDay;
      notificationType = widget.medication!.notificationType;
    }
    if (Platform.isAndroid && notificationType == null) {
      notificationType = NotificationType.alarmClock;
    }
  }

  onDispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final medicationsController = Get.find<MedicationController>();
    final notificationsController = Get.find<NotificationsController>();
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.normalPadding),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              spacing: AppSizes.normalPadding,
              children: [
                /// Appbar with back button
                const CustomAppbar(),

                /// Medication name
                CustomTextFormField(
                  controller: nameController,
                  labelText: 'medicationName'.tr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'medicationNameHint'.tr;
                    }
                    return null;
                  },
                ),

                /// Amount of pills available
                CustomTextFormField(
                  controller: amountController,
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
                ),

                /// Frequency of medication
                CustomDropDown(
                  value: frequency,
                  items: MedicationFrequency.values,
                  customNames: frequencies,
                  onChanged: (value) => setState(() {
                    frequency = value!;
                    days.forEach((key, value) => days[key] = false);
                    selectedDays.clear();
                    monthlyDay = null;
                  }),
                  label: 'frequency'.tr,
                ),

                /// Days selection
                if (frequency == MedicationFrequency.daysPerWeek)
                  WeekdayPicker(
                    key: ValueKey(frequency),
                    frequency: frequency,
                    days: days,
                    onChanged: (day, value) => setState(() {
                      days[day] = value;
                      selectedDays.clear();
                      days.forEach((key, value) {
                        if (value) {
                          selectedDays.add(key);
                        }
                      });
                    }),
                  ),

                /// Day of the month if frequency is once
                if (frequency == MedicationFrequency.once)
                  DayPicker(
                    selectedDate: monthlyDay,
                    onTap: (DateTime date) {
                      setState(() {
                        monthlyDay = date;
                      });
                    },
                  ),

                /// Pills per day
                CustomDropDown(
                  value: repeatTimes,
                  items: List.generate(20, (i) => i + 1),
                  onChanged: (value) => setState(() {
                    repeatTimes = value!;
                    if (repeatTimes < times.length) {
                      final difference = times.length - repeatTimes;
                      for (var i = 0; i < difference; i++) {
                        times.removeAt(times.length - 1);
                      }
                    } else if (repeatTimes > times.length) {
                      final difference = repeatTimes - times.length;
                      times = [
                        ...times,
                        ...List.generate(difference, (_) => null),
                      ];
                    }
                  }),
                  label: 'repeat'.tr,
                ),

                /// Pills times selection
                ...List.generate(
                  repeatTimes,
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
                        initialTime: times[i] ?? TimeOfDay(hour: 12, minute: 0),
                      );
                      if (time != null) {
                        setState(() => times[i]);
                      }
                      return time;
                    },
                    time: i < times.length ? times[i] : null,
                    onChanged: (newTime) {
                      setState(() => times[i] = newTime);
                    },
                  ),
                ),

                /// Notification type
                if (notificationType != null)
                  NotificationTypeTitle(
                    notificationType: notificationType!,
                    onChanged: (value) {
                      setState(() {
                        notificationType = value;
                      });
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
                        color: theme.errorContainer,
                        sideColor: theme.onError,
                        icon: Icon(
                          size: AppSizes.largeIconSize,
                          Icons.delete_forever_outlined,
                          color: theme.onErrorContainer,
                        ),
                        onTap: () => showDeleteDialog(
                          context: context,
                          medicationsController: medicationsController,
                          medication: widget.medication!,
                          frequency: frequency,
                          notificationsController: notificationsController,
                        ),
                      ),

                    /// Save medication
                    CustomButton(
                      size: AppSizes.buttonSize,
                      icon: Icon(
                        size: AppSizes.largeIconSize,
                        Icons.done,
                        color: theme.onPrimaryContainer,
                      ),
                      onTap: () async {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }

                        /// create medication model
                        final medication = MedicationModel(
                          name: nameController.text,
                          amount: int.tryParse(amountController.text),
                          frequency: frequency,
                          selectedDays:
                              frequency == MedicationFrequency.daysPerWeek
                              ? selectedDays
                              : null,
                          monthlyDay: frequency == MedicationFrequency.once
                              ? monthlyDay
                              : null,
                          times: List<TimeOfDay>.from(times),
                          timesPillTaken: List<bool>.filled(repeatTimes, false),
                          id: widget.medication?.id ?? UniqueKey().hashCode,
                          notificationType: notificationType,
                        );

                        /// if this is edit medication
                        if (widget.medication != null) {
                          medicationsController.updateMedication(medication);

                          /// we reset the notifications if the medication is edited
                          await cancelNotification(
                            notificationsController: notificationsController,
                            medication: medication,
                            frequency: frequency,
                          );
                        } else {
                          /// if this is add medication
                          medicationsController.addMedication(medication);
                        }

                        /// setup notifications for both add medication and edit medication
                        setupNotification(
                          notificationsController: notificationsController,
                          medication: medication,
                          frequency: frequency,
                        );
                        Get.until((route) => route.isFirst);
                      },
                    ),
                  ],
                ),
                const SizedBox(width: AppSizes.normalPadding),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> cancelNotification({
  required MedicationModel medication,
  required MedicationFrequency frequency,
  required NotificationsController notificationsController,
}) async {
  frequency == MedicationFrequency.once
      ? [
          for (int i = 0; i < medication.times.length; i++)
            await notificationsController.cancelNotification(medication.id + i),
        ]
      : await notificationsController.cancelAllNotificationForMedication(
          medication.id,
        );
}

setupNotification({
  required MedicationModel medication,
  required MedicationFrequency frequency,
  required NotificationsController notificationsController,
}) async {
  frequency == MedicationFrequency.once
      ? [
          for (int i = 0; i < medication.times.length; i++)
            await notificationsController.scheduleNotification(
              id: medication.id + i,
              medicationName: medication.name,
              dateTime: DateTime(
                medication.monthlyDay!.year,
                medication.monthlyDay!.month,
                medication.monthlyDay!.day,
                medication.times[i].hour,
                medication.times[i].minute,
              ),
              notificationType: medication.notificationType,
              isRepeating: true,
            ),
        ]
      : {
          for (int i = 0; i < medication.times.length; i++)
            {
              await notificationsController.scheduleDailyOrWeeklyNotification(
                id: medication.id,
                medicationName: medication.name,
                time: medication.times[i],
                weekdays: medication.selectedDays ?? [],
                notificationType: medication.notificationType,
              ),
            },
        };
}
