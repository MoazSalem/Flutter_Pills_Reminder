import 'package:get/get.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:pills_reminder/features/medications/data/datasources/medication_local_data_source_impl.dart';
import 'package:pills_reminder/features/medications/data/models/medication_model.dart';
import 'package:pills_reminder/features/medications/data/repositories/medications_repo_impl.dart';
import 'package:pills_reminder/features/medications/presentation/controllers/medications_controller.dart';
import 'package:pills_reminder/features/medications/presentation/controllers/notifications_controller.dart';
import 'package:pills_reminder/features/notifications/data/repositories/notification_repo_impl.dart';

class MedicationsBinding extends Bindings {
  @override
  void dependencies() {
    final Box<MedicationModel> box = Hive.box('medications');
    final localDataSource = MedicationLocalDataSourceImpl(box);
    Get.put<MedicationController>(
      MedicationController(
        MedicationsRepoImpl(localDataSource: localDataSource),
      ),
    );
    Get.put<NotificationsController>(
      NotificationsController(NotificationRepoImpl()),
    );
  }
}
