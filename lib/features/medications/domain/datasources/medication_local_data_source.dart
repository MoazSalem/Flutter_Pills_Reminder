import 'package:pills_reminder/features/medications/data/models/medication_model.dart';

abstract class MedicationLocalDataSource {
  Future<List<MedicationModel>> getAll();
  Future<MedicationModel> get(String id);
  Future<void> add(MedicationModel medication);
  Future<void> update(MedicationModel medication);
  Future<void> delete(String id);
}
