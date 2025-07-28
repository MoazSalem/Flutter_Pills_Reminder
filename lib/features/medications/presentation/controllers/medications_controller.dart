import 'package:get/get.dart';
import 'package:pills_reminder/features/medications/data/models/medication_model.dart';
import 'package:pills_reminder/features/medications/data/repositories/medications_repo_impl.dart';
import 'package:pills_reminder/features/medications/domain/entities/medication.dart';

class MedicationController extends GetxController {
  final MedicationsRepoImpl repo;

  MedicationController(this.repo);

  var medications = <Medication>[].obs;

  @override
  void onInit() {
    super.onInit();
    getAllMedications();
  }

  void getAllMedications() async {
    final data = await repo.getAllMedications();
    medications.assignAll(data);
  }

  Future<MedicationModel> getMedication(String id) async {
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
}
