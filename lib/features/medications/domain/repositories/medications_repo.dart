import 'package:pills_reminder/features/medications/data/models/medication_model.dart';
import 'package:pills_reminder/features/medications/domain/entities/medication.dart';

abstract class MedicationsRepo {
  Future<List<Medication>> getAllMedications();
  Future<MedicationModel> getMedication(String id);
  Future<void> addMedication(MedicationModel med) async {}
  Future<void> updateMedication(MedicationModel med) async {}
  Future<void> deleteMedication(int id) async {}
}
