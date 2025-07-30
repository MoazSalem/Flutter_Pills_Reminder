import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/core/models/medication_frequency.dart';
import 'package:pills_reminder/core/models/weekday.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/features/medications/data/models/medication_model.dart';
import 'package:pills_reminder/features/medications/presentation/controllers/medications_controller.dart';
import 'package:pills_reminder/core/widgets/custom_appbar.dart';
import 'package:pills_reminder/features/medications/presentation/screens/edit_medication_screen/widgets/custom_drop_down.dart';
import 'package:pills_reminder/features/medications/presentation/screens/edit_medication_screen/widgets/custom_text_formfield.dart';
import 'package:pills_reminder/features/medications/presentation/screens/edit_medication_screen/widgets/day_picker.dart';
import 'package:pills_reminder/features/medications/presentation/screens/edit_medication_screen/widgets/pill_time.dart';
import 'package:pills_reminder/features/medications/presentation/screens/edit_medication_screen/widgets/rounded_icon_button.dart';
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
      amountController.text = widget.medication!.amount.toString();
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
    }
  }

  onDispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MedicationController>();
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
                  labelText: 'Medication Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a medication name';
                    }
                    return null;
                  },
                ),

                /// Amount of pills available
                CustomTextFormField(
                  controller: amountController,
                  labelText: 'Amount (Optional)',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null;
                    }
                    final number = num.tryParse(value);
                    if (number == null) {
                      return 'Please enter a valid number';
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
                  label: 'Frequency',
                ),

                /// Days selection
                if (frequency == MedicationFrequency.daysPerWeek ||
                    frequency == MedicationFrequency.weekly)
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

                /// Day of the month if frequency is monthly
                if (frequency == MedicationFrequency.monthly)
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
                    times = List.generate(repeatTimes, (_) => null);
                  }),
                  label: 'Pills Per Day',
                ),

                /// Pills times selection
                ...List.generate(
                  repeatTimes,
                  (i) => PillTime(
                    i: i,
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a time';
                      }
                      return null;
                    },
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(hour: 12, minute: 0),
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

                Row(
                  mainAxisAlignment: widget.medication != null
                      ? MainAxisAlignment.spaceBetween
                      : MainAxisAlignment.end,
                  children: [
                    /// delete medication
                    if (widget.medication != null)
                      RoundedIconButton(
                        color: theme.errorContainer,
                        icon: Icon(
                          size: AppSizes.largeIconSize,
                          Icons.delete_forever_outlined,
                          color: theme.onErrorContainer,
                        ),
                        onPressed: () {
                          controller
                              .deleteMedication(widget.medication!.id)
                              .then((value) {
                                Get.until((route) => route.isFirst);
                              });
                        },
                      ),

                    /// Save medication
                    RoundedIconButton(
                      color: theme.primaryContainer,
                      icon: Icon(
                        size: AppSizes.largeIconSize,
                        Icons.done,
                        color: theme.onPrimaryContainer,
                      ),
                      onPressed: () {
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        final medication = MedicationModel(
                          name: nameController.text,
                          amount: int.tryParse(amountController.text),
                          frequency: frequency,
                          selectedDays:
                              frequency == MedicationFrequency.weekly ||
                                  frequency == MedicationFrequency.daysPerWeek
                              ? selectedDays
                              : null,
                          monthlyDay: frequency == MedicationFrequency.monthly
                              ? monthlyDay
                              : null,
                          times: List<TimeOfDay>.from(times),
                          timesPillTaken: List<bool>.filled(repeatTimes, false),
                          id: widget.medication?.id ?? UniqueKey().hashCode,
                        );
                        if (widget.medication != null) {
                          controller.updateMedication(medication);
                        } else {
                          controller.addMedication(medication);
                        }
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
