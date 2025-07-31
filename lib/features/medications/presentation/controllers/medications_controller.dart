import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pills_reminder/core/models/weekday.dart';
import 'package:pills_reminder/features/medications/data/models/medication_model.dart';
import 'package:pills_reminder/features/medications/domain/entities/medication.dart';
import 'package:pills_reminder/features/medications/domain/repositories/medications_repo.dart';
import 'package:pills_reminder/features/notifications/domain/repositories/notification_repo.dart';

class MedicationController extends GetxController {
  final MedicationsRepo medicationsRepo;
  final NotificationRepo notificationRepo;
  MedicationController(this.medicationsRepo, this.notificationRepo);

  RxList<Medication> medications = <Medication>[].obs;
  final isReady = false.obs;

  @override
  void onInit() async {
    super.onInit();
    resetPillsProgress();
    getAllMedications();
    await notificationRepo.initNotificationService();
    isReady.value = true;
  }

  void resetPillsProgress() async {
    medicationsRepo.resetProgress();
  }

  void getAllMedications() async {
    final data = await medicationsRepo.getAllMedications();
    medications.assignAll(data);
  }

  Future<MedicationModel> getMedication(int id) async {
    final data = await medicationsRepo.getMedication(id);
    return data;
  }

  Future<void> addMedication(MedicationModel med) async {
    await medicationsRepo.addMedication(med);
    getAllMedications(); // Refresh
  }

  Future<void> updateMedication(MedicationModel med) async {
    await medicationsRepo.updateMedication(med);
    getAllMedications();
  }

  Future<void> deleteMedication(int id) async {
    await medicationsRepo.deleteMedication(id);
    getAllMedications();
  }

  Future<void> requestNotificationPermission() async {
    await notificationRepo.requestNotificationPermission();
  }

  Future<void> cancelNotification(int id) async {
    await notificationRepo.cancelNotification(id);
  }

  Future<void> cancelAllNotificationForMedication(int id) async {
    await notificationRepo.cancelAllNotificationForMedication(id);
  }

  Future<void> normalNotification({
    required String title,
    required String body,
  }) async {
    notificationRepo.normalNotification(title: title, body: body);
  }

  Future<void> scheduleNotificationOnce({
    required DateTime dateTime,
    required int id,
    String? title,
    String? body,
    required String medicationName,
  }) async {
    notificationRepo.scheduleNotificationOnce(
      dateTime: dateTime,
      id: id,
      title: title,
      body: body,
      medicationName: medicationName,
    );
  }

  Future<void> scheduleDailyOrWeeklyNotification({
    required int id,
    String? title,
    String? body,
    required String medicationName,
    required TimeOfDay time,
    required List<Weekday> weekdays,
  }) async {
    notificationRepo.scheduleDailyOrWeeklyNotification(
      id: id,
      title: title,
      body: body,
      medicationName: medicationName,
      time: time,
      weekdays: weekdays,
    );
  }
}
