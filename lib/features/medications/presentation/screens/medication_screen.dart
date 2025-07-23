import 'package:flutter/material.dart';
import 'package:pills_reminder/core/models/medication.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/features/medications/presentation/widgets/custom_appbar.dart';
import 'package:pills_reminder/features/medications/presentation/widgets/custom_text_formfield.dart';
import 'package:pills_reminder/features/medications/presentation/widgets/custom_drop_down.dart';
import 'package:pills_reminder/features/medications/presentation/widgets/pill_time.dart';

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

  final List<TimeOfDay> times = [];

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
                  }),
                  label: 'Frequency',
                ),

                /// Days selection should be here

                /// Pills per day
                CustomDropDown(
                  value: repeatTimes,
                  items: List.generate(20, (i) => i + 1),
                  onChanged: (value) => setState(() {
                    repeatTimes = value!;
                  }),
                  label: 'Pills Per Day',
                ),

                /// Pills times selection
                ...List.generate(
                  repeatTimes,
                  (i) => PillTime(
                    i: i,
                    times: times,
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a time';
                      }
                      return null;
                    },
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() => times.add(time));
                      }
                      return time;
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
                          // final medication = Medication(
                          //   name: nameController.text,
                          //   amount: int.tryParse(amountController.text),
                          //   frequency: frequency,
                          //   days: selectedDays == [] ? null : selectedDays,
                          //   notificationTimes: notificationTimes,
                          // );
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
