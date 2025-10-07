import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/core/models/medication_frequency.dart';
import 'package:pills_reminder/core/models/notification_type.dart';
import 'package:pills_reminder/core/models/weekday.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/core/widgets/custom_appbar.dart';
import 'package:pills_reminder/core/widgets/custom_button.dart';
import 'package:pills_reminder/core/widgets/custom_drop_down.dart';
import 'package:pills_reminder/features/medications/data/models/medication_model.dart';
import 'package:pills_reminder/features/medications/presentation/controllers/medications_controller.dart';
import 'package:pills_reminder/features/medications/presentation/screens/edit_medication_screen/widgets/custom_text_formfield.dart';
import 'package:pills_reminder/features/medications/presentation/screens/edit_medication_screen/widgets/day_picker.dart';
import 'package:pills_reminder/features/medications/presentation/screens/edit_medication_screen/widgets/delete_dialog.dart';
import 'package:pills_reminder/features/medications/presentation/screens/edit_medication_screen/widgets/notification_type_title.dart';
import 'package:pills_reminder/features/medications/presentation/screens/edit_medication_screen/widgets/pill_time.dart';
import 'package:pills_reminder/features/medications/presentation/screens/edit_medication_screen/widgets/weekday_picker.dart';
import 'package:pills_reminder/features/notifications/presentation/controllers/notifications_controller.dart';
import 'package:pills_reminder/features/settings/presentation/controllers/settings_controller.dart';

class EditMedicationScreen extends StatefulWidget {
  const EditMedicationScreen({super.key, this.medication});
  final MedicationModel? medication;

  @override
  State<EditMedicationScreen> createState() => _EditMedicationScreenState();
}

class _EditMedicationScreenState extends State<EditMedicationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Temporary State Variables
  String _name = '';
  String _amount = '';
  MedicationFrequency _frequency = MedicationFrequency.daily;
  int _timesRepeated = 1;
  List<Weekday> _selectedDays = [];
  List<TimeOfDay?> _times = [null];
  DateTime? _monthlyDay;

  Map<Weekday, bool> _days = {
    Weekday.saturday: false,
    Weekday.sunday: false,
    Weekday.monday: false,
    Weekday.tuesday: false,
    Weekday.wednesday: false,
    Weekday.thursday: false,
    Weekday.friday: false,
  };

  /// this is only needed for android
  NotificationType? _notificationType = NotificationType.alarmClock;

  @override
  void initState() {
    super.initState();
    _setupFields();
  }

  void _setupFields() {
    if (widget.medication != null) {
      _name = widget.medication!.name;
      _amount = widget.medication!.amount == null
          ? ""
          : widget.medication!.amount.toString();
      _frequency = widget.medication!.frequency;
      _timesRepeated = widget.medication!.times.length;
      _selectedDays = widget.medication!.selectedDays ?? [];
      _days = {
        Weekday.saturday: _selectedDays.contains(Weekday.saturday),
        Weekday.sunday: _selectedDays.contains(Weekday.sunday),
        Weekday.monday: _selectedDays.contains(Weekday.monday),
        Weekday.tuesday: _selectedDays.contains(Weekday.tuesday),
        Weekday.wednesday: _selectedDays.contains(Weekday.wednesday),
        Weekday.thursday: _selectedDays.contains(Weekday.thursday),
        Weekday.friday: _selectedDays.contains(Weekday.friday),
      };
      _times.assignAll(widget.medication!.times);
      _monthlyDay = widget.medication!.monthlyDay;
      _notificationType = widget.medication!.notificationType ?? NotificationType.alarmClock;
    }
  }

  @override
  Widget build(BuildContext context) {
    final medicationsController = Get.find<MedicationController>();
    final notificationsController = Get.find<NotificationsController>();
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.normalPadding),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              spacing: AppSizes.normalPadding,
              children: [
                /// Appbar with back button
                const CustomAppbar(),

                /// Medication name
                CustomTextFormField(
                  labelText: 'medicationName'.tr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'medicationNameHint'.tr;
                    }
                    return null;
                  },
                  onSaved: (value) => _name = value!,
                ),

                /// Amount of pills available
                CustomTextFormField(
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
                  onSaved: (value) => _amount = value!,
                ),

                /// Frequency of medication
                CustomDropDown(
                  value: _frequency,
                  items: MedicationFrequency.values,
                  customNames: frequencies,
                  onChanged: (value) => setState(() {
                    _frequency = value!;
                    _days.forEach((key, value) => _days[key] = false);
                    _selectedDays.clear();
                    _monthlyDay = null;
                  }),
                  label: 'frequency'.tr,
                ),

                /// Days selection
                if (_frequency == MedicationFrequency.daysPerWeek)
                  WeekdayPicker(
                    key: ValueKey(_frequency),
                    frequency: _frequency,
                    days: _days,
                    onChanged: (day, value) => setState(() {
                      _days[day] = value;
                      _selectedDays.clear();
                      _days.forEach((key, value) {
                        if (value) {
                          _selectedDays.add(key);
                        }
                      });
                    }),
                  ),

                /// Day of the month if frequency is once
                if (_frequency == MedicationFrequency.once)
                  DayPicker(
                    selectedDate: _monthlyDay,
                    onTap: (DateTime date) {
                      setState(() {
                        _monthlyDay = date;
                      });
                    },
                  ),

                /// Pills per day
                CustomDropDown(
                  value: _timesRepeated,
                  items: List.generate(20, (i) => i + 1),
                  onChanged: (value) => setState(() {
                    _timesRepeated = value!;
                    if (_timesRepeated < _times.length) {
                      final difference = _times.length - _timesRepeated;
                      for (var i = 0; i < difference; i++) {
                        _times.removeAt(_times.length - 1);
                      }
                    } else if (_timesRepeated > _times.length) {
                      final difference = _timesRepeated - _times.length;
                      _times = [
                        ..._times,
                        ...List.generate(difference, (_) => null),
                      ];
                    }
                  }),
                  label: 'repeat'.tr,
                ),

                /// Pills times selection
                ...List.generate(
                  _timesRepeated,
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
                            _times[i] ?? TimeOfDay(hour: 12, minute: 0),
                      );
                      if (time != null) {
                        setState(() => _times[i]);
                      }
                      return time;
                    },
                    time: i < _times.length ? _times[i] : null,
                    onChanged: (newTime) {
                      setState(() => _times[i] = newTime);
                    },
                  ),
                ),

                /// Notification type
                if (_notificationType != null)
                  NotificationTypeTitle(
                    notificationType: _notificationType!,
                    onChanged: (value) {
                      setState(() {
                        _notificationType = value;
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
                        color: colorScheme.errorContainer,
                        sideColor: colorScheme.onError,
                        icon: Icon(
                          size: AppSizes.largeIconSize,
                          Icons.delete_forever_outlined,
                          color: colorScheme.onErrorContainer,
                        ),
                        onTap: () => showDeleteDialog(
                          context: context,
                          medicationsController: medicationsController,
                          medication: widget.medication!,
                          frequency: _frequency,
                          notificationsController: notificationsController,
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
                      onTap: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        // if valid
                        _formKey.currentState!.save();

                        /// create medication model
                        final medication = MedicationModel(
                          name: _name,
                          amount: int.tryParse(_amount),
                          frequency: _frequency,
                          selectedDays:
                              _frequency == MedicationFrequency.daysPerWeek
                              ? _selectedDays
                              : null,
                          monthlyDay: _frequency == MedicationFrequency.once
                              ? _monthlyDay
                              : null,
                          times: List<TimeOfDay>.from(_times),
                          timesPillTaken: List<bool>.filled(
                            _timesRepeated,
                            false,
                          ),
                          id: widget.medication?.id ?? UniqueKey().hashCode,
                          notificationType: _notificationType,
                        );

                        /// if this is edit medication
                        if (widget.medication != null) {
                          medicationsController.updateMedication(medication);

                          /// we reset the notifications if the medication is edited
                          await cancelNotification(
                            notificationsController: notificationsController,
                            medication: widget.medication!,
                          );
                        } else {
                          /// if this is add medication
                          medicationsController.addMedication(medication);
                        }

                        /// setup notifications for both add medication and edit medication
                        setupNotification(
                          notificationsController: notificationsController,
                          medication: medication,
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
  required NotificationsController notificationsController,
}) async {
  medication.frequency == MedicationFrequency.once
      ? [
          for (int i = 0; i < medication.times.length; i++)
            await notificationsController.cancelNotification(medication.id + i),
        ]
      : await notificationsController.cancelAllNotificationForMedication(
          medication,
        );
}

Future<void> setupNotification({
  required MedicationModel medication,
  required NotificationsController notificationsController,
}) async {
  final groupedNotifications =
      Get.find<SettingsController>().groupedNotifications.value;
  medication.frequency == MedicationFrequency.once
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
              if (groupedNotifications)
                {
                  await notificationsController
                      .scheduleGroupedDailyOrWeeklyNotification(
                        id: medication.id,
                        medicationName: medication.name,
                        time: medication.times[i],
                        weekdays: medication.selectedDays ?? [],
                        notificationType: medication.notificationType,
                      ),
                }
              else
                {
                  await notificationsController
                      .scheduleDailyOrWeeklyNotification(
                        id: medication.id,
                        medicationName: medication.name,
                        time: medication.times[i],
                        weekdays: medication.selectedDays ?? [],
                        notificationType: medication.notificationType,
                      ),
                },
            },
        };
}
