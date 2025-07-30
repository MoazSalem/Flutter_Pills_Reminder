import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
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
  bool isNotificationPermissionGranted = false;

  @override
  void onInit() async {
    super.onInit();
    resetProgress();
    getAllMedications();
    await initNotificationService();
    isReady.value = true;
  }

  void resetProgress() async {
    var box = await Hive.openBox('date');
    final int lastOpenedDay =
        box.get('lastOpenedDate') ?? DateTime.now().weekday;
    if (lastOpenedDay == DateTime.now().weekday) {
      box.put('lastOpenedDate', DateTime.now().weekday);
      return;
    } else {
      box.put('lastOpenedDate', DateTime.now().weekday);
      await repo.resetProgress();
    }
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
    if (isNotificationPermissionGranted) {
      return;
    }
    isNotificationPermissionGranted = true;
    final status = await Permission.notification.request();

    if (!status.isGranted) {
      isNotificationPermissionGranted = false;
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

  Future<void> cancelAllNotificationForMedication(int id) async {
    var box = await Hive.openBox('notificationsIds');
    var ids = box.get(id);
    for (var id in ids) {
      await notificationService.cancelNotification(id);
    }
  }

  Future<void> normalNotification({
    required String title,
    required String body,
  }) async {
    await requestNotificationPermission();
    await notificationService.normalNotification(title: title, body: body);
  }

  Future<void> scheduleNotificationOnce({
    required DateTime dateTime,
    required int id,
    String? title,
    required String medicationName,
  }) async {
    await requestNotificationPermission();
    debugPrint("Notification scheduled with id $id at $dateTime");
    await notificationService.scheduleMedicationNotificationOnce(
      id: id,
      title: title ?? 'Take Your Medication',
      body: 'Time to take your $medicationName pill',
      dateTime: dateTime,
    );
  }

  Future<void> scheduleDailyOrWeeklyNotification({
    required int id,
    String? title,
    required String medicationName,
    required TimeOfDay time,
    required List<Weekday> weekdays,
  }) async {
    await requestNotificationPermission();
    debugPrint(
      "Weekly Notification scheduled with id $id at $time at $weekdays",
    );
    await notificationService.scheduleDailyOrWeeklyNotification(
      id: id,
      title: title ?? 'Take Your Medication',
      body: 'Time to take your $medicationName pill',
      time: time,
      weekdays: weekdays,
    );
  }
}
