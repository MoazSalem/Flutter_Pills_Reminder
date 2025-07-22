import 'package:flutter/material.dart';
import 'package:pills_reminder/core/models/medication.dart';
import 'package:pills_reminder/core/styles/sizes.dart';
import 'package:pills_reminder/features/main_screen/presentation/screens/main_screen/main_screen.dart';
import 'package:pills_reminder/features/medications/presentation/widgets/custom_appbar.dart';
import 'package:pills_reminder/features/medications/presentation/widgets/custom_text_formfield.dart';
import 'package:pills_reminder/features/medications/presentation/widgets/custom_drop_down.dart';

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
  final List<DateTime> notificationTimes = [];

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
    MedicationFrequency.coupleTimes: "Couple Times",
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
                const CustomAppbar(),
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
                CustomDropDown(
                  value: frequency,
                  items: MedicationFrequency.values,
                  customNames: {
                    MedicationFrequency.daily: 'Daily',
                    MedicationFrequency.weekly: 'Weekly',
                    MedicationFrequency.monthly: 'Monthly',
                    MedicationFrequency.coupleTimes: 'Couple of Times',
                  },
                  onChanged: (value) => setState(() {
                    frequency = value!;
                  }),
                  label: 'Frequency',
                ),
                if (frequency == MedicationFrequency.daily)
                  CustomDropDown(
                    value: repeatTimes,
                    items: List.generate(20, (i) => i + 1),
                    onChanged: (value) => setState(() {
                      repeatTimes = value!;
                    }),
                    label: 'Number of times per ${frequencies[frequency]}',
                  ),
                // Days selection should be here
                Container(),
                // Notification Scheduling should be here
                Container(),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: AppSizes.buttonHeight,
                        child: ElevatedButton(
                          onPressed: () {
                            if (!formKey.currentState!.validate()) {
                              return;
                            }
                            final medication = Medication(
                              name: nameController.text,
                              amount: int.tryParse(amountController.text),
                              frequency: frequency,
                              days: selectedDays == [] ? null : selectedDays,
                              notificationTimes: notificationTimes,
                            );
                            Navigator.pop(context);
                          },
                          child: const Text('Save'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
