import 'package:pills_reminder/features/main_screen/data/models/medication_model.dart';

abstract class MedicationLocalDataSource {
  Future<List<MedicationModel>> getAll();
  Future<void> add(MedicationModel medication);
  Future<void> update(MedicationModel medication);
  Future<void> delete(String id);
}
