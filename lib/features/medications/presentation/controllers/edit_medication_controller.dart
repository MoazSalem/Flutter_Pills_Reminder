import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/core/models/medication_frequency.dart';
import 'package:pills_reminder/core/models/notification_type.dart';
import 'package:pills_reminder/core/models/weekday.dart';
import 'package:pills_reminder/core/utils/debug_print.dart';
import 'package:pills_reminder/features/medications/data/models/medication_model.dart';
import 'package:pills_reminder/features/medications/presentation/controllers/medications_controller.dart';
import 'package:pills_reminder/features/notifications/presentation/controllers/notifications_controller.dart';

class EditMedicationController extends GetxController {
  final MedicationController _medicationController = Get.find();
  final NotificationsController _notificationsController = Get.find();

  // The original medication, if we are editing
  final MedicationModel? originalMedication;

  EditMedicationController({this.originalMedication});

  final formKey = GlobalKey<FormState>();

  // Convert all state variables to Rx types
  final name = ''.obs;
  final amount = ''.obs;
  final frequency = MedicationFrequency.daily.obs;
  final timesRepeated = 1.obs;
  final selectedDays = <Weekday>[].obs;
  final times = <TimeOfDay?>[null].obs;
  final monthlyDay = Rx<DateTime?>(null);
  final notificationType = NotificationType.alarmClock.obs;

  RxMap<Weekday, bool> days = {
    Weekday.saturday: false,
    Weekday.sunday: false,
    Weekday.monday: false,
    Weekday.tuesday: false,
    Weekday.wednesday: false,
    Weekday.thursday: false,
    Weekday.friday: false,
  }.obs;

  @override
  void onInit() {
    super.onInit();
    _setupFields();
  }

  @override
  void dispose() {
    super.dispose();
    debugOnlyPrint('Controller disposed');
  }

  void _setupFields() {
    if (originalMedication != null) {
      name.value = originalMedication!.name;
      amount.value = originalMedication!.amount?.toString() ?? "";
      frequency.value = originalMedication!.frequency;
      timesRepeated.value = originalMedication!.times.length;
      selectedDays.value = originalMedication!.selectedDays ?? [];
      times.assignAll(originalMedication!.times);
      monthlyDay.value = originalMedication!.monthlyDay;
      notificationType.value =
          originalMedication!.notificationType ?? NotificationType.alarmClock;
    }
  }

  Future<void> deleteMedication() async {
    if (originalMedication == null) return;
    await _notificationsController.cancelNotifications(originalMedication!);
    await _medicationController.deleteMedication(originalMedication!.id);
  }

  Future<void> saveMedication() async {
    if (!formKey.currentState!.validate()) return;

    formKey.currentState!.save(); // This still works with onSaved

    // create medication model
    final medication = MedicationModel(
      name: name.value,
      amount: int.tryParse(amount.value),
      frequency: frequency.value,
      selectedDays: frequency.value == MedicationFrequency.daysPerWeek
          ? selectedDays.map((weekday) => weekday).toList()
          : null,
      monthlyDay: frequency.value == MedicationFrequency.once
          ? monthlyDay.value
          : null,
      times: List<TimeOfDay>.from(times.map((time) => time!)),
      timesPillTaken: List<bool>.filled(timesRepeated.value, false),
      id: originalMedication?.id ?? UniqueKey().hashCode,
      notificationType: notificationType.value,
    );

    if (originalMedication != null) {
      // if this is edit medication
      _medicationController.updateMedication(medication);
      await _notificationsController.cancelNotifications(medication);
    } else {
      // if this is add medication
      _medicationController.addMedication(medication);
    }
    // setup notifications for both add medication and edit medication
    _notificationsController.setupNotifications(medication);
    Get.until((route) => route.isFirst);
  }
}
