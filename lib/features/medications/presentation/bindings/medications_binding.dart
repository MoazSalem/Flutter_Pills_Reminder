import 'package:get/get.dart';
import 'package:hive_ce/hive.dart';
import 'package:pills_reminder/features/medications/data/datasources/medication_local_data_source_impl.dart';
import 'package:pills_reminder/features/medications/data/repositories/medications_repo_impl.dart';
import 'package:pills_reminder/features/medications/presentation/controllers/medications_controller.dart';

class MedicationsBinding extends Bindings {
  @override
  void dependencies() {
    Hive.openBox('medications');
    Get.lazyPut<MedicationController>(
      () => MedicationController(
        MedicationsRepoImpl(
          localDataSource: MedicationLocalDataSourceImpl(
            Hive.box('medications'),
          ),
        ),
      ),
    );
  }
}
