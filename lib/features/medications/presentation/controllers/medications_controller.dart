import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pills_reminder/core/models/weekday.dart';
import 'package:pills_reminder/features/medications/data/models/medication_model.dart';
import 'package:pills_reminder/features/medications/data/repositories/medications_repo_impl.dart';
import 'package:pills_reminder/features/medications/domain/entities/medication.dart';
import 'package:pills_reminder/features/notifications/data/services/notification_service_impl.dart';
import 'package:pills_reminder/features/notifications/domain/services/notification_service.dart';

class MedicationController extends GetxController {
  final MedicationsRepoImpl repo;
  MedicationController(this.repo);

  RxList<Medication> medications = <Medication>[].obs;
  late final NotificationService notificationService;
  final isReady = false.obs;

  @override
  void onInit() async {
    super.onInit();
    getAllMedications();
    await initNotificationService();
    isReady.value = true;
  }

  void getAllMedications() async {
    final data = await repo.getAllMedications();
    medications.assignAll(data);
  }

  Future<void> initNotificationService() async {
    final notificationsPlugin = FlutterLocalNotificationsPlugin();
    // Ensure plugin is initialized
    await notificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    notificationService = NotificationServiceImpl(notificationsPlugin);
  }

  Future<MedicationModel> getMedication(int id) async {
    final data = await repo.getMedication(id);
    return data;
  }

  Future<void> addMedication(MedicationModel med) async {
    await repo.addMedication(med);
    getAllMedications(); // Refresh
  }

  Future<void> updateMedication(MedicationModel med) async {
    await repo.updateMedication(med);
    getAllMedications();
  }

  Future<void> deleteMedication(int id) async {
    await repo.deleteMedication(id);
    getAllMedications();
  }

  Future<void> requestNotificationPermission() async {
    final status = await Permission.notification.request();

    if (!status.isGranted) {
      Get.snackbar(
        duration: const Duration(seconds: 5),
        'Permission Denied',
        'Notifications will not work until permission is granted.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
        mainButton: TextButton(
          onPressed: () {
            openAppSettings();
          },
          child: Text(
            'Open Settings',
            style: TextStyle(color: Get.theme.colorScheme.onError),
          ),
        ),
      );
    }
  }

  Future<void> cancelNotification(int id) async {
    await notificationService.cancelNotification(id);
  }

  Future<void> normalNotification({
    required String title,
    required String body,
  }) async {
    requestNotificationPermission();
    await notificationService.normalNotification(title: title, body: body);
  }

  Future<void> scheduleNotificationOnce({
    required DateTime dateTime,
    required int id,
    String? title,
    required String body,
  }) async {
    requestNotificationPermission();
    debugPrint("Notification scheduled with id $id at $dateTime");
    await notificationService.scheduleMedicationNotificationOnce(
      id: id,
      title: title ?? 'Take Your Medication',
      body: body,
      dateTime: dateTime,
    );
  }

  Future<void> scheduleDailyOrWeeklyNotification({
    required int id,
    required String title,
    required String body,
    required TimeOfDay time,
    required List<Weekday> weekdays,
  }) async {
    requestNotificationPermission();
    debugPrint(
      "Weekly Notification scheduled with id $id at $time at $weekdays",
    );
    await notificationService.scheduleDailyOrWeeklyNotification(
      id: id,
      title: title,
      body: body,
      time: time,
      weekdays: weekdays,
    );
  }
}
