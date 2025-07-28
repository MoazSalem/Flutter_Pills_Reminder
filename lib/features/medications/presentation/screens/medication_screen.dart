import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/core/models/medication_frequency.dart';
import 'package:pills_reminder/core/models/weekday.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/features/medications/data/models/medication_model.dart';
import 'package:pills_reminder/features/medications/presentation/controllers/medications_controller.dart';
import 'package:pills_reminder/features/medications/presentation/widgets/custom_appbar.dart';
import 'package:pills_reminder/features/medications/presentation/widgets/custom_text_formfield.dart';
import 'package:pills_reminder/features/medications/presentation/widgets/custom_drop_down.dart';
import 'package:pills_reminder/features/medications/presentation/widgets/day_picker.dart';
import 'package:pills_reminder/features/medications/presentation/widgets/pill_time.dart';
import 'package:pills_reminder/features/medications/presentation/widgets/weekday_picker.dart';

class MedicationScreen extends StatefulWidget {
  const MedicationScreen({super.key});

  @override
  State<MedicationScreen> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
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

  Map<MedicationFrequency, String> frequencies = {
    MedicationFrequency.daily: "Daily",
    MedicationFrequency.weekly: "Weekly",
    MedicationFrequency.monthly: "Monthly",
    MedicationFrequency.daysPerWeek: "Couple of Days per Week",
  };

  onDispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MedicationController>();
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
                      if (value) {
                        selectedDays.add(day);
                      } else {
                        selectedDays.remove(day);
                      }
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
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: AppSizes.buttonHeight,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primaryContainer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppSizes.roundedRadius,
                            ),
                          ),
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
                            timesPillTaken: List<bool>.filled(
                              repeatTimes,
                              false,
                            ),
                            id: DateTime.now().millisecondsSinceEpoch
                                .toString(),
                          );
                          controller.addMedication(medication);
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.done, size: AppSizes.largeIconSize),
                      ),
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
